extends Node
onready var character: KinematicBody2D = $".."

export var spawn : PackedScene

func _ready() -> void:
	character.listen("zero_health",self,"instantiate")

func instantiate() -> void:
	call_deferred("instantiate_spawn")

func instantiate_spawn() -> void:
	var instance = spawn.instance()
	get_tree().current_scene.add_child(instance,true)
	instance.set_global_position(character.global_position) 
	instance.set_direction(character.get_facing_direction())
	instance.set_vertical_speed(-250)
	call_deferred("activate_shield", instance)
	character.emit_spawned_child(instance)

func activate_shield(instance) -> void:
	var ai = instance.get_node("AI")
	ai.activate_ability(ai._on_see_player)
	
