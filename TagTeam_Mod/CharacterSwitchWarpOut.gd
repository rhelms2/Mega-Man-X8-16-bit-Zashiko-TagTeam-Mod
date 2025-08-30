extends EventAbility
class_name CharacterSwitchWarpOut

# Edited version of "Finish.gd"

export  var beam_speed: = 690.0
var ascending: = false
onready var animatedSprite = get_parent().get_node("animatedSprite")
onready var beam_sound = get_node("audioStreamPlayer")


func _ready() -> void :
	animatedSprite.connect("animation_finished", self, "on_animation_finished")
	Event.listen("character_switch_end", self, "on_character_switch_end")

func on_character_switch_end() -> void:
	EndAbility()
	
func _Setup():
	character.deactivate()
	character.play_animation_backwards("beam_in")

func _Update(_delta):
	if ascending:
		if animatedSprite.global_position.y <= character.global_position.y-224:
			character.hide()
			character.active = false
			ascending = false
			CharacterManager.try_character_switch_end()
		else:
			animatedSprite.global_position.y -= beam_speed * _delta
	
func on_animation_finished():
	if executing:
		if character.get_animation() == "beam_in":
			play_animation_once("beam")
			beam_sound.play()
			timer = 0
			ascending = true

func _EndCondition() -> bool:
	return false

func is_high_priority() -> bool:
	return true
