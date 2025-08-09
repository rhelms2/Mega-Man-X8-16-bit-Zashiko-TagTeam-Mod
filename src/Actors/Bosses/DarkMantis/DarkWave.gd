extends SimpleProjectile

func initialize(_direction) -> void: #called from instantiator
	Log("Initializing")
	activate()
	reset_timer()
	#set_direction(direction)
	_Setup()
	
func explode() -> void:
	pass
	
func _OnHit(_target_remaining_HP) -> void: #override
	pass

func _OnScreenExit() -> void: #override
	Log("Exited Screen")
