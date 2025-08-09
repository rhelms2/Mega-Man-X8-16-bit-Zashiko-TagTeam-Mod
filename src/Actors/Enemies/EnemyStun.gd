extends AttackAbility
class_name EnemyStun

onready var shield = character.get_shield()
onready var break_effect := $break_vfx
onready var break_sound := $break_sound
onready var break_effect_pos = break_effect.position.x
export var gravity := false
export var reactivate_shield_on_end := true
export var stun_duration := 1.25
export var recover_animation := "recover"

func _Setup() -> void:
	._Setup()
	force_movement(0)
	shield.deactivate()
	break_effect.position.x = break_effect_pos * character.get_direction()
	break_effect.frame = 0
	break_effect.play()
	break_sound.play()

func _Update(_delta) -> void:
	if gravity:
		process_gravity(_delta)
	if attack_stage == 0 and timer > stun_duration:
		if recover_animation != "":
			play_animation(recover_animation)
		next_attack_stage()
	elif attack_stage == 1 and has_finished_last_animation():
		EndAbility()

func _Interrupt() -> void:
	if reactivate_shield_on_end and character.has_health():
		shield.activate()
	
