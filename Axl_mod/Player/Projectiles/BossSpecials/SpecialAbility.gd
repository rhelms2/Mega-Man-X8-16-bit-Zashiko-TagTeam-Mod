extends Node2D
class_name SpecialAbilityAxl

export  var disable_base_ready: bool = false

onready var character: = get_parent()
onready var animatedSprite: AnimatedSprite = get_node("animatedSprite")

var animation_time: float = 1.0
var current_animation: String = ""
var finished_animation: String = "\'"
var attack_stage: int = 0
var timer: float = 0.0


func _ready() -> void :
	connect_animation_finished_event()
	character.connect("zero_health", self, "deactivate")
	Event.connect("enemy_kill", self, "destroy")
	if disable_base_ready:
		return
	Event.connect("boss_cutscene_start", self, "deactivate")

func connect_animation_finished_event():
	animatedSprite.connect("animation_finished", self, "on_finished_animation")

func initialize() -> void :
	pass

func deactivate() -> void :
	queue_free()

func destroy(enemy) -> void :
	if typeof(enemy) == TYPE_STRING:
		if enemy == "boss":
			deactivate()

func _physics_process(delta: float) -> void :
	timer += delta

func on_finished_animation() -> void :
	finished_animation = animatedSprite.animation

func has_finished_last_animation() -> bool:
	return has_finished_animation(current_animation)

func has_finished_animation(anim: String) -> bool:
	return anim == finished_animation

func has_finished_either(animations: Array) -> bool:
	for anim in animations:
		if anim == finished_animation:
			return true
	return false

func is_current_animation(anim: String) -> bool:
	return anim == current_animation

func is_current_animation_either(animations: Array) -> bool:
	for anim in animations:
		if anim == current_animation:
			return true
	return false

func get_animation() -> String:
	return animatedSprite.animation
	
func play_animation_once(anim: String) -> void :
	if not get_animation() == anim:
		animatedSprite.play(anim)
		animatedSprite.set_frame(0)
	current_animation = anim

func play_animation(anim: String) -> void :
	animatedSprite.play(anim)
	animatedSprite.set_frame(0)
	current_animation = anim

func play_animation_again(anim: String) -> void :
	animatedSprite.play(anim)
	animatedSprite.set_frame(0)
	current_animation = anim
	finished_animation = ""

func next_attack_stage_on_next_frame() -> void :
	call_deferred("next_attack_stage")

func next_attack_stage() -> void :
	attack_stage += 1
	timer = 0

func previous_attack_stage() -> void :
	attack_stage -= 1
	timer = 0

func go_to_attack_stage(new_attack_stage: int) -> void :
	attack_stage = new_attack_stage
	timer = 0

func go_to_attack_stage_on_next_frame(new_attack_stage: int) -> void :
	call_deferred("go_to_attack_stage", new_attack_stage)

func EndAbility() -> void :
	deactivate()

func screenshake(value: float = 2.0) -> void :
	Event.emit_signal("screenshake", value)

func get_all_particles() -> Array:
	var particle_list: Array = []
	for child in get_children():
		if child is Particles2D:
			particle_list.append(child)
	return particle_list

func toggle_emit(object, state: bool) -> void :
	if object is Array:
		for particle in object:
			particle.emitting = state
	else:
		object.emitting = state
