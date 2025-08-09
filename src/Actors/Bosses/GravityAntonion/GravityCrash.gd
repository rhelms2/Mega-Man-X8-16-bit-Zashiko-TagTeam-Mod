extends AttackAbility

export  var deactivate_hurl: bool = true

onready var roar: AudioStreamPlayer2D = $roar
onready var desperate: AudioStreamPlayer2D = $desperate

var desperation_damage_reduction: float = 0.5

signal start_desperation
signal ready_for_stun


func set_game_modes() -> void :
	desperation_damage_reduction = CharacterManager.boss_damage_reduction
	
func _Setup() -> void :
	set_game_modes()
	play_animation("rage")
	character.emit_signal("damage_reduction", desperation_damage_reduction)

func _Update(delta: float) -> void :
	process_gravity(delta)
	if attack_stage == 0 and timer > 1.0:
		play_animation("summon_start")
		roar.play()
		next_attack_stage()
	
	elif attack_stage == 1 and has_finished_last_animation():
		play_animation("summon_loop")
		start_desperation_attack()
		emit_signal("ready_for_stun")
		desperate.play()
		next_attack_stage()
		
	elif attack_stage == 2 and timer > 4:
		play_animation("summon_end")
		next_attack_stage()
		
	elif attack_stage == 3 and has_finished_last_animation():
		EndAbility()

func _Interrupt() -> void :
	character.emit_signal("damage_reduction", 1.0)

func start_desperation_attack() -> void :
	emit_signal("start_desperation")
	if deactivate_hurl:
		$"../GravityHurl".deactivate()
