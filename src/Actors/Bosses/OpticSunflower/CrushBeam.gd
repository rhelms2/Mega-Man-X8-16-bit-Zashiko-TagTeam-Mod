extends Node2D

onready var animatedSprite: AnimatedSprite = $animatedSprite
onready var animated_sprite_2: AnimatedSprite = $animatedSprite2

signal started
signal ended

func _ready() -> void :
	animatedSprite.playing = true
	animated_sprite_2.playing = true
	Tools.timer(0.12, "mid_animation", self)
	Tools.timer(1.45, "end_animation", self)
	Event.emit_signal("screenshake", 2.0)

func mid_animation() -> void :
	emit_signal("started")
	animatedSprite.play("loop")
	animated_sprite_2.play("loop")
	Event.emit_signal("screenshake", 2.0)

func end_animation() -> void :
	emit_signal("ended")
	animatedSprite.play("end")
	animated_sprite_2.play("end")
	Event.emit_signal("screenshake", 0.5)
	Tools.timer(0.5, "queue_free", self)
	
func set_floor_y() -> void :
	var space_state = get_world_2d().direct_space_state
	var target = global_position + Vector2(0, 1024)
	if is_instance_valid(space_state):
		global_position.y = space_state.intersect_ray(global_position, target, [self], 1)["position"].y
