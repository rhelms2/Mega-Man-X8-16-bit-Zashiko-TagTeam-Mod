extends DoorClose


func _Interrupt() -> void :
	if character.close_after_freeway:
		collider.set_deferred("disabled", false)
	else:
		._Interrupt()
