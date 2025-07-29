extends Object
class_name Encryption


static func get_secret_key() -> String:
	var parts: Array = [
		"aMiPhjUfzKFawasKe6yUQMe2sGkXX", 
		"ZjgWRkc6pO5kWESyp6960cSWWYtwfgkfs4RoCLHOGQHq1Y8IC", 
		"DUkTjr4Sg1sHmwYmA9", 
		"uw0hjDW54W1KYaeW7d04H5bhph", 
		"jq19xW5Tps", 
		"Q1idVc57hR92HodzGqYWCyBYDsUDCQ2ORTzJhRFg9WPpHda9WBMb", 
		"EXdlI6GmryuO5LbsIgsB0LqhgS8Rc3doJAKS91", 
		"w47trZ90j3evGoDUfEsmdCGsLPaA1DfFyi", 
		"O5wtslptiaKgyKIEzypyV7aPYeD", 
		"FhavzqgXhktoHKYk0WDsD27lDBVRSD9WhAkS3xcBMCL", 
		"4xrtkK7pJzKyFcPaFw6cj341yu1yJ6Ow", 
		"zdycx3sAJ816AcMybKOcpOKJ71YeAUu3H8Y7fgMW31xq", 
		"cdpaQDSdjVzIAvgoQVvYXajvf6Y7sqagUG7jGbGjhdRU3x1TzL62cKGmS", 
		"glaQsv93LUDODJuBiXU1OudE460xpaBiQptB2cUJ9Gk0kUhP0lSI8", 
	]
	var k: String = ""
	for part in parts:
		k += part
	parts = []
	var hashed_k: String = k.sha256_text()
	return hashed_k

static func get_api_key() -> String:
	var parts: Array = [
		"jPhAQD0JlJCZdFj", 
		"Ls9fUakwX6HWuaYxxELsreF", 
		"UuXKC3fR5PH4liggg", 
		"oHEkgZT0yPbAEraRQW5p", 
		"3hOq9ZRW7tMgcsiijh2RhYOFQE", 
		"yu1FK6uxzcWURm", 
		"cVZYWbV6MgfII2cmR9eVt8rT3ziGlmyY", 
		"ZlfwaXxemSCgG9Tm7498Bkak", 
		"HfsCQv75UMXr5iH5eHrZS49AaZYRM4gZo3p8k5hM", 
		"5OyFuo7fYYSbkAe1d6VodWSJ", 
		"18HtVVz4Jxr1lOke0ZatM", 
	]
	var k: String = ""
	for part in parts:
		k += part
	parts = []
	var hashed_k: String = k.sha256_text()
	return hashed_k

static func canonical_json_stringify(value) -> String:
	if typeof(value) == TYPE_DICTIONARY:
		var keys: Array = value.keys()
		keys.sort()
		var parts: Array = []
		for k in keys:
			parts.append(JSON.print(k) + ":" + canonical_json_stringify(value[k]))
		return "{" + ",".join(parts) + "}"
	elif typeof(value) == TYPE_ARRAY:
		var parts: Array = []
		for item in value:
			parts.append(canonical_json_stringify(item))
		return "[" + ",".join(parts) + "]"
	else:
		return JSON.print(value)



static func encrypt_sha256_aes_cbc(_data: String, _iv: String, _payload: String) -> Dictionary:
	var key: PoolByteArray = hex_to_bytes(get_secret_key())
	
	var crypto: Crypto = Crypto.new()
	var iv: PoolByteArray = crypto.generate_random_bytes(16)
	
	var aes: AESContext = AESContext.new()
	aes.start(AESContext.MODE_CBC_ENCRYPT, key, iv)
	
	secure_wipe_bytes(key)
	
	var data_bytes: PoolByteArray = _data.to_utf8()
	data_bytes = add_pkcs7_padding(data_bytes, 16)
	
	var encrypted: PoolByteArray = aes.update(data_bytes)
	var finished = aes.finish()
	if finished != null:
		encrypted += finished
		
	secure_wipe_bytes(data_bytes)
	
	var iv_b64: String = Marshalls.raw_to_base64(iv)
	var payload_b64: String = Marshalls.raw_to_base64(encrypted)
	
	secure_wipe_bytes(encrypted)
	
	return {
		_iv: iv_b64, 
		_payload: payload_b64
	}

static func decrypt_sha256_aes_cbc(iv_b64: String, payload_b64: String) -> Dictionary:
	var key: PoolByteArray = hex_to_bytes(get_secret_key())
	
	var iv: PoolByteArray = Marshalls.base64_to_raw(iv_b64)
	var cipher_text: PoolByteArray = Marshalls.base64_to_raw(payload_b64)
	
	var aes: AESContext = AESContext.new()
	var err = aes.start(AESContext.MODE_CBC_DECRYPT, key, iv)
	
	secure_wipe_bytes(key)
	
	if err != OK:
		return {}
		
	var decrypted_raw: PoolByteArray = aes.update(cipher_text)
	var finish_data = aes.finish()
	if finish_data != null:
		decrypted_raw += finish_data
		
	secure_wipe_bytes(cipher_text)
		
	decrypted_raw = remove_pkcs7_padding(decrypted_raw)
	
	var json_string: String = decrypted_raw.get_string_from_utf8()
	
	secure_wipe_bytes(decrypted_raw)
	
	var parsed = JSON.parse(json_string)
	if parsed.error != OK:
		return {}
	return parsed.result


static func add_pkcs7_padding(data: PoolByteArray, block_size: int) -> PoolByteArray:
	var pad_len: int = block_size - (data.size() %block_size)
	for i in range(pad_len):
		data.append(pad_len)
	return data

static func remove_pkcs7_padding(data: PoolByteArray) -> PoolByteArray:
	if data.size() == 0:
		return data
	var padding_len: int = data[data.size() - 1]
	if padding_len <= 0 or padding_len > 16:
		return data
	for i in range(data.size() - padding_len, data.size()):
		if data[i] != padding_len:
			return data
	var result = data.subarray(0, data.size() - padding_len)
	secure_wipe_bytes(data)
	return result


static func hex_to_bytes(hex_str: String) -> PoolByteArray:
	var bytes: PoolByteArray = PoolByteArray()
	for i in range(0, hex_str.length(), 2):
		var byte_str: String = hex_str.substr(i, 2)
		var byte_val: int = parse_hex_byte(byte_str)
		bytes.append(byte_val)
	return bytes

static func parse_hex_byte(hex_byte: String) -> int:
	var hex_digits: String = "0123456789abcdef"
	var byte_val: int = 0
	for i in range(2):
		var c: String = hex_byte[i].to_lower()
		var digit_val: int = hex_digits.find(c)
		if digit_val == - 1:
			return 0
		byte_val = byte_val * 16 + digit_val
	return byte_val


static func secure_wipe_bytes(arr: PoolByteArray) -> void :
	arr.fill(0)
	arr.resize(0)
