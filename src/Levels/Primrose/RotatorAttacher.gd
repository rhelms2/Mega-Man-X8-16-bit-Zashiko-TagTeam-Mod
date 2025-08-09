extends Node2D

onready var rotator = get_child(0)
func _ready() -> void :
	Event.connect("respawned", self, "attach_rotator")
	pass

func attach_rotator(enemy: Node2D):
	
	if not "Turret" in enemy.name:
		var new_rotator = rotator.duplicate()
		enemy.call_deferred("add_child", new_rotator)
