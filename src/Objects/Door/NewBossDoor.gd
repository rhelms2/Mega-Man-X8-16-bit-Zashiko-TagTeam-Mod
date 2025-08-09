extends NewDoor

export  var open_signal: String = "boss_door_open"


func _on_Open_start(_ability_name) -> void :
	Event.emit_signal(open_signal)
	._on_Open_start(_ability_name)

func _on_Explode_start(_ability_name) -> void :
	Event.emit_signal(open_signal)
	._on_Explode_start(_ability_name)
