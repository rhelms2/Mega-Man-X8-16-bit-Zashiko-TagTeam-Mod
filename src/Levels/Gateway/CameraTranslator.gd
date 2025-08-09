extends DoorCameraTranslator

var next_limit_open: bool = false


func _ready() -> void :
	pass

func last_zone_entered() -> void :
	Log("last_zone_entered")
	if not next_limit_open:
		if not previous_limit.disabled and not next_limit.disabled:
			disable_limits(next_limit)

func _on_starting_freeway() -> void :
	pass

func _on_closing_freeway() -> void :
	disable_limits(next_limit)
	next_limit_open = false

func _on_Door_waiting_freeway() -> void :
	enable_limits(previous_limit)
	next_limit_open = true
	pass
