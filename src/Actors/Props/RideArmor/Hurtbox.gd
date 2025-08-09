extends KinematicBody2D

onready var character: KinematicBody2D = $".."

func deactivate() -> void:
	$CollisionShape2D.disabled = true

func damage(value, inflicter) -> float:
	return character.damage(value, inflicter)

func hit(_body: Node) -> void:
	character.hit(_body)

func deflect(_body: Node) -> void:
	pass

func leave(_body: Node) -> void:
	pass

func add_conveyor_belt_speed(conveyor_speed : float):
	character.add_conveyor_belt_speed(conveyor_speed)
func reduce_conveyor_belt_speed(conveyor_speed : float):
	character.reduce_conveyor_belt_speed(conveyor_speed)

func is_invulnerable() -> bool:
	return character.is_invulnerable()

func get_character() -> Node2D:
	return character

func get_facing_direction() -> int:
	return character.get_facing_direction()
	
