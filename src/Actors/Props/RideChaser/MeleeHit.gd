extends EventAbility
class_name Melee
var enemy : Node
var damage := 0.0

func _Setup():
	enemy = start_parameter
	damage = 0.0
	modify_damage_based_on_speed()
	modify_damage_based_on_control()
	modify_damage_based_on_health()
	modify_damage_based_on_jump()
	inflict_damage()
	half_actual_speed()

func inflict_damage():
	damage = round(damage)
	Log("Dealing " + str (damage) + " damage")
	if damage > 0:
		enemy.damage(damage, character)
	

func half_actual_speed():
	if not character.is_executing("HyperDash"):
		character.set_actual_speed(character.get_actual_speed()/2)
	#character.force_end("Dash")

func modify_damage_based_on_speed():
	if abs(character.get_actual_speed()) > 100:
		damage = abs(character.get_actual_speed()/40)

func modify_damage_based_on_control():
	if not character.listening_to_inputs:
		damage = damage * 1.5

func modify_damage_based_on_health():
	if not character.has_health():
		damage = damage * 1.5

func modify_damage_based_on_jump():
	if not character.is_on_floor():
		damage = damage * 1.4

func _Interrupt() -> void:
	pass
