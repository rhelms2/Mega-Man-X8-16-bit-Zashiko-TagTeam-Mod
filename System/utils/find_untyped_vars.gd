extends Node

func _ready():
	var results = []
	_scan_dir("res://", results)

	var file = File.new()
	if file.open("user://untyped_variables_report.txt", File.WRITE) == OK:
		for line in results:
			file.store_line(line)
		file.close()

func _scan_dir(path: String, results: Array) -> void :
	print("Scan dir: ", path)
	var dir = Directory.new()
	if dir.open(path) != OK:
		return

	dir.list_dir_begin(true, true)
	var file_name = dir.get_next()
	while file_name != "":
		var full_path = path.plus_file(file_name)
		if dir.current_is_dir():
			_scan_dir(full_path, results)
		elif file_name.ends_with(".gd"):
			_check_file(full_path, results)
		file_name = dir.get_next()
	dir.list_dir_end()


















func _check_file(path, results):
	print("check file", path)
	var file = File.new()
	if file.open(path, File.READ) != OK:
		return

	var lines = []
	var changed: bool = false
	while not file.eof_reached():
		var line = file.get_line()
		var new_line = typify_bool_line(line)
		if new_line != line:
			changed = true
			results.append(path + " (line changed)")
		lines.append(new_line)
	file.close()

	if changed:
		if file.open(path, File.WRITE) == OK:
			for l in lines:
				file.store_line(l)
			file.close()
			print("Updated file:", path)


func typify_bool_line(line: String) -> String:
	
	var regex = RegEx.new()
	regex.compile("var\\s+(\\w+)\\s*=\\s*(true|false)")
	
	var _match = regex.search(line)
	if _match:
		var var_name = _match.get_string(1)
		var bool_value = _match.get_string(2)
		
		if ":" in line.split("=")[0]:
			return line
		return "var %s: bool = %s" % [var_name, bool_value]
	return line

