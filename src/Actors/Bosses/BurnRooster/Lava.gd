extends AttackAbility
onready var damage_on_touch: Node2D = $"../DamageOnTouch"
onready var fire_1: Particles2D = $fire1
onready var fire_2: Particles2D = $fire2
onready var fire_3: Particles2D = $fire3

func _Setup() -> void:
	fire_1.emitting = true
	fire_2.emitting = true
	fire_3.emitting = true

func _Update(_delta) -> void:
	if attack_stage == 0 and has_finished_last_animation():
		play_animation_once("start")
		next_attack_stage()
	elif attack_stage == 1 and timer > 0.1:
		damage_on_touch.activate()
		next_attack_stage()
	elif attack_stage == 2 and has_finished_last_animation():
		play_animation_once("loop")
		next_attack_stage()

func on_death() -> void:
	$"../animatedSprite".visible = false
	$"../fire_loop".playing = false
