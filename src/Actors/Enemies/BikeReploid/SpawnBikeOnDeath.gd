extends Node
onready var character: KinematicBody2D = $".."

export var bike : PackedScene
export var spawn_damaged := false

func _ready() -> void:
	character.listen("zero_health",self,"instantiate")

func instantiate() -> void:
	call_deferred("instantiate_bike")

func instantiate_bike() -> void:
	var instance = bike.instance()
	get_tree().current_scene.add_child(instance,true)
	instance.set_global_position(character.global_position) 
	instance.set_direction(character.get_facing_direction())
	if instance.has_method("set_actual_speed"):
		instance.set_actual_speed(character.get_actual_horizontal_speed())

	if GameManager.is_player_in_scene():
		if GameManager.player.ride:
			if GameManager.player.ride.current_health > 0:
				instance.current_health = 0
			else:
				if spawn_damaged:
					instance.current_health = 16
				return
		else:
			if GameManager.is_bike_nearby(character):
				instance.current_health = 0
	character.emit_spawned_child(instance)
		
