extends Reference
class_name DamageValue

var active: = true
var name: = ""
var damage: = 1.0
var damage_to_bosses: = 1.0
var damage_to_weakness: = 1.0
var break_guards: = false
var attack_direction: = 0
var global_position: = Vector2.ZERO
var groups = []
var creator: Node

func _init(_damage: float, _creator: Node, _name: = "", _direction: = 0, _guardbreak: = true, _position: = Vector2.ZERO, control_method: = "null") -> void :
	damage = _damage
	damage_to_bosses = _damage
	damage_to_weakness = _damage
	creator = _creator
	break_guards = _guardbreak
	attack_direction = _direction
	global_position = _position
	
	if _name != "":
		name = _name
	else:
		name = creator.name
	
	if control_method != "null":
		creator.connect(control_method, self, "disable")

func set_position(_position) -> void :
	global_position = _position

func set_damage_to_bosses(_damage) -> void :
	damage_to_bosses = _damage
	
func set_damage_to_weakness(_damage) -> void :
	damage_to_weakness = _damage

func get_damage() -> float:
	if active:
		return damage
	return 0.0

func get_damage_to_bosses() -> float:
	if active:
		return damage_to_bosses
	return 0.0

func get_damage_to_weakness() -> float:
	if active:
		return damage_to_weakness
	return 0.0

func disable() -> void :
	active = false

func deflect(_deflector) -> void :
	if break_guards:
		pass
	else:
		disable()

func add_group(group_name) -> void :
	group_name.append(group_name)

func is_in_group(group_name) -> bool:
	return group_name in groups

func get_facing_direction() -> int:
	return attack_direction
