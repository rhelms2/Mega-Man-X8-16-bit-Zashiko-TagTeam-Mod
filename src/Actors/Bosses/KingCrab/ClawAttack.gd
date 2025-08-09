extends GenericProjectile
class_name ClawAttack

func _Setup() -> void:
	creator.get_parent().listen("zero_health",self,"on_death")
	$area2D.scale.x = get_direction()

func on_death() -> void:
	attack_stage = -1
	set_horizontal_speed(0)
	set_vertical_speed(0)
	animatedSprite.material = creator.get_parent().animatedSprite.material

func _OnHit(_target_remaining_HP) -> void:
	pass
