extends Movement
class_name Attack

export  var start_signal: String = ""
export  var animations: Array

onready var ia: = get_parent().get_node("Artificial Intelligence")

var current_index: int = 0
var current_animation: String = ""


func _ready() -> void :
	if active:
		get_parent().get_node("animatedSprite").connect("animation_finished", self, "animation_change")
		if start_signal != "":
			ia.connect(start_signal, self, "start_by_signal")

func should_start() -> bool:
	return not executing and character.has_health()

func start_by_signal() -> void :
	if should_start():
		ExecuteOnce()
		executing = true

func _StartCondition() -> bool:
	return false

func _EndCondition() -> bool:
	return false

func _Setup() -> void :
	current_index = 0
	current_animation = ""
	play_or_fire(animations[current_index])

func _Update(_delta: float) -> void :
	if current_index < animations.size():
		play_or_fire(animations[current_index])
	else:
		EndAbility()

func play_or_fire(trigger: String) -> void :
	if trigger != current_animation:
		play_animation(trigger)
		current_animation = trigger
		if fire_condition(trigger):
			fire()

func fire_condition(trigger) -> bool:
	return "fire" in trigger

func fire() -> void :
	play_sound(sound)

func play_animation(anim: String, frame: int = 0):
	character.animatedSprite.play(anim)
	character.animatedSprite.set_frame(frame)

func animation_change() -> void :
	if executing:
		current_index += 1
