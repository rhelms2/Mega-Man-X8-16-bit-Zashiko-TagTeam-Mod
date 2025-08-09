# Adapted BSON serializer for Godot 3.5.3 (no PackedByteArray.encode_s* methods)
# COPYRIGHT 2025 Colormatic Studios and contributors.
# This file is the BSON serializer for the Godot Engine,
# published under the MIT license. https://opensource.org/license/MIT

class_name BSON

static func to_bson(data: Dictionary) -> PoolByteArray:
	var document := dictionary_to_bytes(data)
	document.append(0x00)
	var buffer := PoolByteArray()
	buffer = append_array(buffer, int32_to_bytes(document.size() + 4))
	buffer = append_array(buffer, document)
	return buffer

static func get_byte_type(value):
	match typeof(value):
		TYPE_STRING:
			return 0x02
		TYPE_INT:
			if abs(value) < 2147483647:
				return 0x10
			else:
				return 0x12
		TYPE_REAL:
			return 0x01
		TYPE_ARRAY:
			return 0x04
		TYPE_DICTIONARY:
			return 0x03
		TYPE_BOOL:
			return 0x08
		TYPE_NIL:
			return 0x0a
		_:
			push_error("BSON serialization error: Unsupported type: " + str(typeof(value)))
			return 0x00

static func int32_to_bytes(value):
	var a = PoolByteArray()
	a.resize(4)
	a[0] = value & 0xFF
	a[1] = (value >> 8) & 0xFF
	a[2] = (value >> 16) & 0xFF
	a[3] = (value >> 24) & 0xFF
	return a

static func int64_to_bytes(value):
	var a = PoolByteArray()
	a.resize(8)
	for i in range(8):
		a[i] = (value >> (8 * i)) & 0xFF
	return a

static func double_to_bytes(value):
	var buffer = StreamPeerBuffer.new()
	buffer.put_double(value)
	return buffer.get_data_array()

static func dictionary_to_bytes(dict) -> PoolByteArray:
	var buffer := PoolByteArray()
	for key in dict.keys():
		buffer.append(get_byte_type(dict[key]))
		buffer = append_array(buffer, key.to_utf8())
		buffer.append(0x00)
		buffer = append_array(buffer, serialize_variant(dict[key]))
	return buffer

static func array_to_bytes(array):
	var buffer := PoolByteArray()
	for index in range(array.size()):
		buffer.append(get_byte_type(array[index]))
		buffer = append_array(buffer, str(index).to_utf8())
		buffer.append(0x00)
		buffer = append_array(buffer, serialize_variant(array[index]))
	return buffer

static func serialize_variant(data):
	var buffer := PoolByteArray()
	match typeof(data):
		TYPE_DICTIONARY:
			var document = dictionary_to_bytes(data)
			buffer = append_array(buffer, int32_to_bytes(document.size()))
			buffer = append_array(buffer, document)
			buffer.append(0x00)
		TYPE_ARRAY:
			var b_array = array_to_bytes(data)
			buffer = append_array(buffer, int32_to_bytes(b_array.size()))
			buffer = append_array(buffer, b_array)
			buffer.append(0x00)
		TYPE_STRING:
			var str_as_bytes = data.to_utf8()
			buffer = append_array(buffer, int32_to_bytes(str_as_bytes.size() + 1))
			buffer = append_array(buffer, str_as_bytes)
			buffer.append(0x00)
		TYPE_INT:
			if abs(data) < 2147483647:
				buffer = append_array(buffer, int32_to_bytes(data))
			else:
				buffer = append_array(buffer, int64_to_bytes(data))
		TYPE_REAL:
			buffer = append_array(buffer, double_to_bytes(data))
		TYPE_BOOL:
			buffer.append(0x01 if data else 0x00)
		_:
			buffer.append(0x00)
	return buffer

static func append_array(base: PoolByteArray, extra: PoolByteArray) -> PoolByteArray:
	for b in extra:
		base.append(b)
	return base

static func from_bson(data: PoolByteArray) -> Dictionary:
	if data[data.size() - 1] != 0x00:
		push_error("BSON deserialization error: Document is not null terminated. It is likely that the provided buffer is not BSON.")
	return Deserializer.new(data).read_dictionary()

class Deserializer:
	var buffer: PoolByteArray
	var read_position := 0

	func _init(_buffer: PoolByteArray):
		buffer = _buffer

	func get_int8() -> int:
		var value = buffer[read_position]
		read_position += 1
		return value

	func get_int32() -> int:
		var result = 0
		for i in range(4):
			result |= buffer[read_position + i] << (8 * i)
		read_position += 4
		return result

	func get_int64() -> int:
		var result = 0
		for i in range(8):
			result |= buffer[read_position + i] << (8 * i)
		read_position += 8
		return result

	func get_double() -> float:
		var peer = StreamPeerBuffer.new()
		peer.data_array = buffer.subarray(read_position, read_position + 8)
		read_position += 8
		return peer.get_double()

	func get_string() -> String:
		var expected_size = get_int32()
		var s_value = ""
		var iter = 0
		while true:
			iter += 1
			var b_char = get_int8()
			if b_char == 0x00:
				break
			s_value += char(b_char)
		if expected_size != iter:
			push_error("BSON deserialization error: String was the wrong size. Position: " + str(read_position - iter) + ", stated size: " + str(expected_size) + ", actual size: " + str(iter))
		return s_value

	func get_bool() -> bool:
		return get_int8() == 1

	func read_dictionary() -> Dictionary:
		var object = {}
		var expected_size = get_int32()
		var iter = 0
		while true:
			iter += 1
			var type = get_int8()
			if type == 0x00:
				break
			var key = ""
			while true:
				var k_char = get_int8()
				if k_char == 0x00:
					break
				key += char(k_char)
			match type:
				0x02: object[key] = get_string()
				0x10: object[key] = get_int32()
				0x12: object[key] = get_int64()
				0x01: object[key] = get_double()
				0x08: object[key] = get_bool()
				0x04: object[key] = read_array()
				0x03: object[key] = read_dictionary()
				0x0a: object[key] = null
				_: push_error("BSON deserialization error: Unsupported type " + str(type) + " at byte " + str(read_position - 1))
		if iter > expected_size and expected_size > 0:
			push_warning("BSON deserialization warning: Dictionary is the wrong length. Expected: " + str(expected_size) + ", Actual: " + str(iter))
		return object

	func read_array() -> Array:
		var array = []
		var expected_size = get_int32()
		var iter = 0
		while true:
			iter += 1
			var type = get_int8()
			if type == 0x00:
				break
			var key = ""
			while true:
				var k_char = get_int8()
				if k_char == 0x00:
					break
				key += char(k_char)
			match type:
				0x02: array.append(get_string())
				0x10: array.append(get_int32())
				0x12: array.append(get_int64())
				0x01: array.append(get_double())
				0x08: array.append(get_bool())
				0x04: array.append(read_array())
				0x03: array.append(read_dictionary())
				0x0a: array.append(null)
				_: push_error("BSON deserialization error: Unsupported type: " + str(type))
		if iter > expected_size and expected_size > 0:
			push_warning("BSON deserialization warning: Array is the wrong length. Expected: " + str(expected_size) + ", Actual: " + str(iter))
		return array
