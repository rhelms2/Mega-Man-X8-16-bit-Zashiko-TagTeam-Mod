extends Area2D

onready var collapsing_repeating: Node2D = $".."
onready var manta_ray: KinematicBody2D = $"../Boss/MantaRay"

var timer := 0.0
var stage = 0
var player : Character

func _physics_process(delta: float) -> void:
	if is_active():
		timer += delta
		if stage == 0:
			#player.stop_listening_to_inputs()
			GameManager.music_player.start_fade_out()
			stage += 1
			timer = 0.1
		elif stage == 1 and timer > 1:
			Event.emit_signal("screenshake", 1)
			#player.set_direction(-1)
			GameManager.music_player.play_miniboss_song()
			collapsing_repeating.start()
			stage += 1
		elif stage == 2:
			Event.emit_signal("screenshake", 1)
			#player.start_listening_to_inputs()
			stage = -1
		elif stage == -1:
			set_physics_process(false)

func _on_SinkStarter_body_entered(body: Node) -> void:
	if not body.is_in_group("Props"):
		if timer == 0:
			timer = 0.1
			manta_ray.execute_intro()
			player = GameManager.player

func is_active() -> bool:
	return timer > 0 and stage > -1
