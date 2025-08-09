extends Movement
class_name EnemyAbility

onready var animatedSprite : AnimatedSprite = get_parent().get_node("animatedSprite")
var current_animation := ""
var finished_animation := "'"
var attack_stage = 0

func _ready() -> void:
	check_for_event_errors() 
	if active:
		connect_animation_finished_event()

func connect_animation_finished_event():
	animatedSprite.connect("animation_finished",self,"on_finished_animation")
	

func Initialize() -> void:
	.Initialize()
	attack_stage = 0
	
func on_finished_animation():
	finished_animation = animatedSprite.animation
	
func has_finished_last_animation() -> bool:
	return has_finished_animation(current_animation)

func has_finished_animation(anim : String) -> bool:
	return anim == finished_animation

func has_finished_either(animations : Array) -> bool:
	for anim in animations:
		if anim == finished_animation:
			return true
	return false

func is_current_animation(anim : String) -> bool:
	return anim == current_animation

func is_current_animation_either(animations : Array) -> bool:
	for anim in animations:
		if anim == current_animation:
			return true
	return false
	
func play_animation_once(anim : String):
	.play_animation_once(anim)
	current_animation = anim

func play_animation(anim : String):
	.play_animation(anim)
	current_animation = anim

func play_animation_again(anim : String):
	.play_animation(anim)
	current_animation = anim
	finished_animation = ""

func next_attack_stage_on_next_frame():
	call_deferred("next_attack_stage")

func next_attack_stage():
	attack_stage += 1
	timer = 0
	Log("proceeding to stage " + str(attack_stage))

func previous_attack_stage() -> void:
	attack_stage -= 1
	timer = 0
	Log("proceeding to stage " + str(attack_stage))
	
func go_to_attack_stage(new_attack_stage : int) -> void:
	attack_stage = new_attack_stage
	timer = 0
	Log("proceeding to stage " + str(attack_stage))

func go_to_attack_stage_on_next_frame(new_attack_stage : int) -> void:
	call_deferred("go_to_attack_stage",new_attack_stage)
