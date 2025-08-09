extends Area2D

export (NodePath) var lava_object

var timer: = 0.0
var stage = 0
onready var lava = get_node(lava_object)
var player: Character

func _physics_process(delta: float) -> void :
	if is_active():
		timer += delta
		if stage == 0:
			player.cutscene_deactivate()
			GameManager.music_player.start_fade_out()
			stage += 1
		elif stage == 1 and player.is_on_floor():
			Event.emit_signal("screenshake", 1)
			player.set_direction( - 1)
			GameManager.music_player.play_lava_song()
			lava.activate()
			stage += 1
		elif stage == 2 and timer > 2.2:
			Event.emit_signal("screenshake", 1)
			player.start_listening_to_inputs()
			stage = - 1
			
		


func _on_area2D_body_entered(body: Node) -> void :
	timer = 0.1
	lava.visible = true
	var light = lava.get_node("sublight")
	light.energy = 0
	create_tween().tween_property(light, "energy", 0.75, 0.9)
	player = GameManager.player

func is_active() -> bool:
	return timer > 0 and stage > - 1
