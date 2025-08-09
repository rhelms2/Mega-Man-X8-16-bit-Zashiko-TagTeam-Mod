extends Label


func _ready() -> void :
	if Configurations.get("ShowDebug"):
		visible = true
	else:
		visible = false
