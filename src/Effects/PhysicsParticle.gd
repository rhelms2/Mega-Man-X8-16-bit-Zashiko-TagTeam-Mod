extends RigidBody2D

export var number_of_frames := 16
export var max_bounces := 2
var falling := false
var bounces := 0

func _ready() -> void:
	var sprite = get_node("sprite")
	sprite.frame = randi()  % number_of_frames
	max_bounces += randi()  % 2
	sprite.rotate (randf() * 3.2)

func _process(delta: float) -> void:
	if bounces >= max_bounces:
		queue_free()
	if not falling and linear_velocity.y > 0:
		falling = true
	if falling and linear_velocity.y < 0:
		falling = false
		bounces += 1

func _on_rigidBody2D_body_entered(body: Node) -> void:
	pass # Replace with function body.
