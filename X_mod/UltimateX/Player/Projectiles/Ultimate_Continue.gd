extends SimplePlayerProjectile

var target_list: Array
var interval: float = 0.164
var damage_timer: float = 0.0

const continuous_damage: bool = true


func _DamageTarget(body) -> int:
	target_list.append(body)
	return 0

func _OnHit(_target_remaining_HP) -> void :
	pass

func _OnDeflect() -> void :
	pass

func _Setup() -> void :
	Tools.timer(2.0, "end_animation", self)

func _Update(_delta: float) -> void :
	damage_timer += _delta
	if damage_timer > interval:
		damage_targets_in_list()
		damage_timer = 0.0

func end_animation() -> void :
	destroy()

func damage_targets_in_list() -> void :
	if target_list.size() > 0:
		for body in target_list:
			if is_instance_valid(body):
				body.damage(damage, self)

func leave(_body) -> void :
	if _body in target_list:
		target_list.erase(_body)
