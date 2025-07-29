extends Node2D
onready var remains: Particles2D = $remains
var broken: = false
onready var tile_map: TileMap = $tileMap
onready var shatter_sfx: AudioStreamPlayer2D = $shatter

func _ready() -> void :
	pass

func break_glass() -> void :
	if not broken:
		if GameManager.is_on_screen(remains.global_position):
			broken = true
			tile_map.modulate = Color(5, 5, 5, 1)
			shatter_sfx.play_rp()
			Tools.timer(0.025, "shatter", self)

func shatter() -> void :
	tile_map.modulate = Color(10, 10, 10, 0)
	remains.emitting = true

func _on_area2D_body_entered(_body: Node) -> void :
	break_glass()
	pass


func _on_player_detector_body_entered(_body: Node) -> void :
	if GameManager.player:
		if GameManager.player.ride:
			if abs(GameManager.player.ride.get_horizontal_speed()) > 200:
				break_glass()
	pass


func _on_shot_detector_body_entered(body: Node) -> void :
	if "Charged" in body.name or "Buster" in body.name or "Pistol" in body.name:
		break_glass()
