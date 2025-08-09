extends DoorCameraTranslator


func _ready() -> void :
	pass

func last_zone_entered() -> void :
	if not exploded:
		if previous_limit and not previous_limit.disabled and not next_limit.disabled:
			Log("last_zone_entered")
			disable_limits(next_limit)
