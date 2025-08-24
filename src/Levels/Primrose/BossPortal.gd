extends TeleportPortal

onready var boss_spawner: Node2D = $"../BossSpawner"


func _on_area2D_body_entered(_body: Node) -> void :
	if active and _body.character == GameManager.player:
		before_teleport()

func before_teleport() -> void :
	boss_spawner.spawn()
	emit_signal("teleport_start")
	Event.call_deferred("emit_signal", "boss_door_open")
	Tools.timer(0.02, "teleport", self)

func teleport() -> void :
	teleport_sfx.play()
	Event.emit_signal("stage_teleport")
	Event.emit_signal("disable_unneeded_objects")
	GameManager.pause("BossPortal")
	GameManager.player.listening_to_inputs = false
	set_camera_to_process()
	var tween = create_tween()
	tween.set_pause_mode(SceneTreeTween.TWEEN_PAUSE_PROCESS)
	tween.tween_property(GameManager.player, "modulate", Color(30, 30, 30, - 1.0), duration)
	tween.tween_callback(self, "move_player")
	tween.tween_property(GameManager.player, "modulate", Color.white, duration)
	tween.tween_callback(GameManager, "unpause", ["BossPortal"])
	tween.tween_callback(GameManager, "start_cutscene")
	tween.tween_callback(self, "set_camera_to_inherit")

func move_player() -> void :
	var destination_pos = get_node(destination).global_position
	teleport_end.global_position = destination_pos
	Tools.timer(0.25, "play", teleport_end, null, true)
	GameManager.player.global_position = destination_pos
	GameManager.camera.clear_area_limits()
	GameManager.camera.ignore_translate = true
	if camera_limit:
		GameManager.camera.include_area_limit(get_node(camera_limit))
	GameManager.player.set_direction(1)

func set_camera_to_inherit() -> void :
	GameManager.camera.set_pause_mode(Node.PAUSE_MODE_INHERIT)
	Event.emit_signal("stage_teleport_end")
	Event.emit_signal("boss_door_closed")
	Event.emit_signal("show_warning")
