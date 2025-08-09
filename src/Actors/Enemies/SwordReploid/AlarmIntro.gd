extends AttackAbility

var already_executed: = false
onready var damage_on_touch: Node2D = $"../DamageOnTouch"
onready var damage: Node2D = $"../Damage"
var enemy_shield: Node2D

func _StartCondition() -> bool:
	return not already_executed

func _ready() -> void :
	if "ShieldReploid" in character.name:
		enemy_shield = $"../EnemyShield"
		

func _Setup() -> void :
	force_movement_regardless_of_direction(horizontal_velocity * character.get_direction())
	set_vertical_speed( - jump_velocity)
	already_executed = true
	damage_on_touch.active = false
	damage.active = false
	if "ShieldReploid" in character.name:
		enemy_shield.active = false

func _Update(delta: float) -> void :
	process_gravity(delta)
	if attack_stage == 0 and timer > 0.35:
		activate_receive_damage()
		next_attack_stage()
	
	if attack_stage == 1 and character.is_on_floor():
		play_animation_once("land")
		activate_damage()
		decay_speed()
		next_attack_stage()
	elif attack_stage == 2 and has_finished_last_animation():
		EndAbility()

func activate_damage() -> void :
	damage_on_touch.active = true

func activate_receive_damage() -> void :
	damage.active = true

func activate_shield() -> void :
	if "ShieldReploid" in character.name:
		enemy_shield.active = true

func _Interrupt() -> void :
	activate_damage()
	activate_receive_damage()
	activate_shield()
