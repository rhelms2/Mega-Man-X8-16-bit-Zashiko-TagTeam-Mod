extends EventAbility
class_name FinishZero

export  var beam_speed: = 420.0
var stage_clear_song_duration: = 3.8
var ascending: = false
var victoring: = false
onready var animatedSprite = get_parent().get_node("animatedSprite")
onready var victory_sound = get_node("audioStreamPlayer")
onready var beam_out_sound = get_node("audioStreamPlayer2")
var ascend_value = 2

var victory_pose_and_music: = true

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
	Event.emit_signal("weapon_select_buster")

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
			if animatedSprite.frame == 7:
				victory_sound.play()

	if ascending:
		animatedSprite.global_position.y -= beam_speed * _delta
		if timer > 1:
			GameManager.end_level()

func handle_victory_music():
	if victory_pose_and_music and timer > stage_clear_song_duration:
		play_animation_once("victory")
		victoring = true

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

		
