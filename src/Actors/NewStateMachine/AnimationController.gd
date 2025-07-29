extends Reference
class_name AnimationController

var animatedSprite: AnimatedSprite
var finished_animation: String
var current_animation: String

signal animation_finished


func _init(_animatedSprite, ability = false) -> void :
	animatedSprite = _animatedSprite
	animatedSprite.connect("animation_finished", self, "on_finished_animation")
	if ability:
		ability.connect("stop", self, "reset")

func reset(_d = null) -> void :
	finished_animation = ""
	current_animation = ""

func on_finished_animation():
	finished_animation = animatedSprite.animation
	emit_signal("animation_finished")

func on_finish(method, object) -> void :
	connect("animation_finished", object, method)

func has_finished_last() -> bool:
	return has_finished(current_animation)

func has_finished(anim: String) -> bool:
	return anim == finished_animation

func is_currently(anim: String) -> bool:
	return get_name() == anim

func is_playing(anim: String) -> bool:
	return anim == get_name() and not has_finished(anim)

func is_between(initial_frame: int, last_frame: int) -> bool:
	return animatedSprite.frame >= initial_frame and animatedSprite.frame <= last_frame

func get_frame() -> int:
	return animatedSprite.frame

func get_name() -> String:
	return animatedSprite.animation

func play(anim: String, frame: = 0) -> void :
	animatedSprite.play(anim)
	animatedSprite.set_frame(frame)
	current_animation = anim

func set_position(new_position: Vector2) -> void :
	animatedSprite.position = new_position
	
func set_scale_x(new_scale: float) -> void :
	animatedSprite.scale.x = new_scale

func play_once(anim: String) -> void :
	if not get_name() == anim:
		animatedSprite.play(anim)
		animatedSprite.set_frame(0)
	current_animation = anim

func play_again(anim: String):
	play(anim)
	current_animation = anim
	finished_animation = ""

func set_visible(value: bool) -> void :
	animatedSprite.visible = value

func change_spriteframes(newframes) -> void :
	animatedSprite.frames = newframes
