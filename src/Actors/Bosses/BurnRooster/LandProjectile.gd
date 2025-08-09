extends GenericProjectile


func _ready() -> void:
	pass

func _OnHit(_target_remaining_HP) -> void: #override
	pass

func _OnScreenExit() -> void: #override
	set_horizontal_speed(0)
	pass
