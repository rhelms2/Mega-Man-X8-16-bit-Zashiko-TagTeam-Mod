extends KinematicBody2D

const up_direction: = Vector2.UP
var velocity = Vector2.ZERO
var final_velocity: Vector2

func _physics_process(delta: float) -> void :
	final_velocity.y += 800.0 * delta
	final_velocity = move_and_slide(final_velocity, up_direction, true, 4, 0.8)
