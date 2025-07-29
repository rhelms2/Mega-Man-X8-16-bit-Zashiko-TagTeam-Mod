extends EventAbility
class_name FinishAxl

export  var beam_speed: float = 420.0

onready var animatedSprite: = get_parent().get_node("animatedSprite")
onready var victory_sound: = get_node("audioStreamPlayer")
onready var beam_out_sound: = get_node("audioStreamPlayer2")

var stage_clear_song_duration: float = 3.8
var ascending: bool = false
var victoring: bool = false
var ascend_value: int = 2
var victory_pose_and_music: bool = true


func _ready() -> void :
	animatedSprite.connect("animation_finished", self, "on_animation_finished")
	Event.connect("disable_victory_ending", self, "disable_victory")

func disable_victory():
	victory_pose_and_music = false

func _Setup():
	character.deactivate()
	character.stop_all_movement()
	if victory_pose_and_music:
		Event.emit_signal("play_stage_clear_music")

func _Update(_delta):
	process_gravity(_delta)
	if not victoring:
		if character.is_on_floor():
			play_animation_once("idle")
			if not victory_pose_and_music and timer > 1.5:
				character.play_animation("beam_out")
				victoring = true
		handle_victory_music()
	else:
		if character.get_animation() == "victory":
			adjust_position_by_frame_victory()
		if character.get_animation() == "beam_out":
			animatedSprite.position.y -= ascend_value
			ascend_value *= 0.9

	if ascending:
		animatedSprite.global_position.y -= beam_speed * _delta
		if timer > 1:
			GameManager.end_level()

func handle_victory_music():
	if victory_pose_and_music and timer > stage_clear_song_duration:
		play_animation_once("victory")
		victoring = true

func adjust_position_by_frame_victory():
	var _up_frames = [2, 3, 4]
	var _down_frames = [5, 6]
	var current_frame = animatedSprite.frame
	if current_frame in _up_frames:
		animatedSprite.position.y -= 2
	elif current_frame in _down_frames:
		animatedSprite.position.y += 3
	if current_frame == 9:
		victory_sound.play()

func on_animation_finished():
	if executing:
		if character.get_animation() == "victory":
			character.play_animation("beam_out")

		elif character.get_animation() == "beam_out":
			play_animation_once("beam")
			beam_out_sound.play()
			timer = 0
			ascending = true

func _EndCondition() -> bool:
	return false

func is_high_priority() -> bool:
	return true
