class_name Achievement extends Resource

export var icon : Texture
export var location : String
export var disabled := false
var unlocked := false
var date := "locked"

func get_description() -> String:
	return tr(get_id() + "_DISC")
	
func get_title() -> String:
	return tr(get_id() + "_TITLE")
	
func get_icon() -> Texture:
	return icon

func get_id() -> String:
	return resource_path.get_file().trim_suffix('.tres')

func unlock() -> void:
	if not disabled:
		unlocked = true
		date = Time.get_datetime_string_from_system(false,true)
		print ("Achievements: unlocked " + get_id())
	
func lock() -> void :
	if not disabled:
		unlocked = false
		date = "locked"