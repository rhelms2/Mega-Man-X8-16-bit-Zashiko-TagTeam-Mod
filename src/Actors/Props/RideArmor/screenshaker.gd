extends Node

export var active := true

func _on_RideArmor_land() -> void:
	if active:
		Event.emit_signal("screenshake",0.8)
