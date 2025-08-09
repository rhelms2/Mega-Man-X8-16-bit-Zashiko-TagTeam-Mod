extends RisingPlatform

export var _limit_to_deactivate: NodePath
export var extra_limits_to_deactivate: Array
onready var limit_to_deactivate := get_node(_limit_to_deactivate)

func _on_ElevatorStarter_body_entered(body: Node) -> void:
	if not activated:
		activated = true
		emit_signal("started")
		rise()
		GameManager.player.cutscene_deactivate()

func _on_rising_platform_at_max() -> void:
	GameManager.camera.on_area_exit(limit_to_deactivate)
	Event.emit_signal("screenshake",0.7)
	limit_to_deactivate.disable()
	disable_other_limits()
	GameManager.camera.remove_disabled_areas()
	Tools.timer(0.25,"on_finish",self)

func disable_other_limits() ->void:
	for limit in extra_limits_to_deactivate:
		limit.disable()

func on_finish() -> void:
	pass
	
