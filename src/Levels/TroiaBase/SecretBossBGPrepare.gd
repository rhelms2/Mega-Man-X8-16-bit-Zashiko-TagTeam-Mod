extends Node

onready var lines: Node2D = $"../lines"
onready var lines_2: Node2D = $"../lines2"
onready var bg_cover: Sprite = $"../BGCover"
onready var secret_rooms: TileMap = $"../../Scenery/secret_rooms"
onready var foreground: ParallaxLayer = $"../../Scenery/parallaxBackground2/foreground"

export  var cut_color1: Color
export  var cut_color2: Color
export  var cut_color3: Color
export  var r_color1: Color
export  var r_color2: Color
export  var r_color3: Color

var queued_signal: = "none"

func activate() -> void :
	foreground.visible = false
	bg_cover.modulate.a = 0.0
	bg_cover.visible = true
	var t: = create_tween()
	t.tween_property(bg_cover, "modulate:a", 1.0, 2.0)
	t.tween_callback(lines, "start_loop")
	t.tween_interval(2.0)
	t.tween_callback(lines_2, "start_loop")
	Event.emit_signal(queued_signal)

func deactivate() -> void :
	lines.disappear()
	lines_2.disappear()
	create_tween().tween_property(bg_cover, "modulate:a", 0.0, 1.0)


func _on_Portal2_teleport_start() -> void :
	GameManager.player.cutscene_deactivate()
	Event.emit_signal("teleport_to_secret2")
	queued_signal = "end_teleport_to_secret2"


func _on_Portal1_teleport_start() -> void :
	GameManager.player.cutscene_deactivate()
	Event.emit_signal("teleport_to_secret1")
	lines.initial_color = cut_color1
	lines.middle_color = cut_color2
	lines.middle_color2 = cut_color3
	queued_signal = "end_teleport_to_secret1"


func _on_Portal3_teleport_start() -> void :
	GameManager.player.cutscene_deactivate()
	Event.emit_signal("teleport_to_red")
	lines.initial_color = r_color1
	lines.middle_color = r_color2
	lines.middle_color2 = r_color3
	queued_signal = "end_teleport_to_red"
	pass
	
func _on_SecretPortal_teleport_start() -> void :
	GameManager.player.cutscene_deactivate()
	Event.emit_signal("teleport_to_secretboss")
	
func _on_SecretPortal_teleport_end() -> void :
	Event.emit_signal("end_teleport_to_secretboss")
