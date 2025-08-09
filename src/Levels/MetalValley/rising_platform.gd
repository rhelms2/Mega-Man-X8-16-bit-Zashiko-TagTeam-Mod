extends RisingPlatform

onready var limit_19: Area2D = $"../../Limits/19"
onready var limit_to_deactivate: Area2D = $"../../Limits/18"
onready var limit_to_deactivate2: Area2D = $"../../Limits/21"


func _on_ElevatorStarter_body_entered(body: Node) -> void :
	if not activated:
		activated = true
		emit_signal("started")
		rise()
		GameManager.player.cutscene_deactivate()

func _on_rising_platform_at_max() -> void :
	GameManager.camera.on_area_exit(limit_to_deactivate)
	Event.emit_signal("screenshake")
	limit_to_deactivate.disable()
	limit_to_deactivate2.disable()
	GameManager.camera.remove_disabled_areas()
	Tools.timer(0.25, "start_miniboss_fight", self)

func start_miniboss_fight() -> void :
	GameManager.player.start_listening_to_inputs()
