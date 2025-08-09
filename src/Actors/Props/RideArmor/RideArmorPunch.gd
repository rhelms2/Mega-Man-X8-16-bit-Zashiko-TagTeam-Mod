extends SimplePlayerProjectile
var target_list : Array
var interval := 0.064
const continuous_damage := true
const destroyer := true

func _Setup() -> void:
	damage_targets_in_list()
	pass

func _DamageTarget(body) -> int:
	target_list.append(body)
	return 0

func _OnHit(_target_remaining_HP) -> void: #override
	pass

func _OnDeflect() -> void:
	pass

func _Update(_delta) -> void:
	if timer > interval:
		damage_targets_in_list()
		timer = 0.0

func damage_targets_in_list() -> void:
	if target_list.size() > 0:
		for body in target_list:
			if is_instance_valid(body):
				body.damage(damage, self)

func leave(_body) -> void:
	if _body in target_list:
		target_list.erase(_body)
