extends Node2D
class_name TeleportPortal

const duration: float = 0.85

export  var active: bool = true
export  var destination: NodePath
export  var camera_limit: NodePath
export  var check_for_upgrades: bool = false
export  var emit_gateway_signal: bool = false

onready var teleport_sfx: AudioStreamPlayer2D = $teleport
onready var teleport_end: AudioStreamPlayer2D = $teleport2

signal teleport_start
signal teleported


func _on_area2D_body_entered(_body: Node) -> void :
	if active:
		if check_for_upgrades and GameManager.player.using_upgrades and CharacterManager.game_mode >= 0:
			return
		elif _body.get_parent().is_in_group("Player"):
			if _body.get_parent() == GameManager.inactive_player:
				return
		emit_signal("teleport_start")
		teleport()

func teleport() -> void :
	teleport_sfx.play()
	Event.emit_signal("stage_teleport")
	if emit_gateway_signal:
		Event.emit_signal("gateway_capsule_teleport")
	Event.emit_signal("disable_unneeded_objects")
	GameManager.pause("Portal")
	set_camera_to_process()
	var tween = create_tween()
	tween.set_pause_mode(SceneTreeTween.TWEEN_PAUSE_PROCESS)
	tween.tween_property(GameManager.player, "modulate", Color(30, 30, 30, - 1.0), duration)
	tween.tween_callback(self, "move_player")
	tween.tween_property(GameManager.player, "modulate", Color.white, duration)
	tween.tween_callback(GameManager, "unpause", ["Portal"])
	tween.tween_callback(GameManager, "end_cutscene")
	tween.tween_callback(self, "set_camera_to_inherit")
	tween.tween_callback(self, "emit_signal", ["teleported"])

func move_player() -> void :
	var destination_pos = get_node(destination).global_position
	teleport_end.global_position = destination_pos
	Tools.timer(0.25, "play", teleport_end, null, true)
	GameManager.player.global_position = destination_pos
	GameManager.camera.clear_area_limits()
	GameManager.camera.ignore_translate = true
	if camera_limit:
		GameManager.camera.include_area_limit(get_node(camera_limit))
	GameManager.camera.call_deferred("go_to_position", GameManager.camera.get_nearest_position())

func set_camera_to_process() -> void :
	GameManager.camera.set_pause_mode(Node.PAUSE_MODE_PROCESS)

func set_camera_to_inherit() -> void :
	GameManager.camera.set_pause_mode(Node.PAUSE_MODE_INHERIT)
	Event.emit_signal("stage_teleport_end")
	GameManager.end_cutscene()

func activate() -> void :
	active = true
	pass
