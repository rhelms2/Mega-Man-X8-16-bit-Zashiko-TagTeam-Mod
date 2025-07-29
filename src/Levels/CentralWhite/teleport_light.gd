extends Sprite

onready var manta_ray: KinematicBody2D = $"../../Scenery/CollapsingRepeating/Boss/MantaRay"


func _ready() -> void :
	manta_ray.connect("zero_health", self, "activate")

func activate() -> void :
	var tween = create_tween()
	tween.tween_property(get_material(), "shader_param/Alpha", 0.25, manta_ray.get_death_time() - 1)
	tween.tween_property(get_material(), "shader_param/Alpha", 1, 1)
	tween.tween_callback(self, "play_stage_song")
	tween.tween_callback(self, "teleport_player")
	tween.tween_interval(0.5)
	tween.tween_property(get_material(), "shader_param/Alpha", 0, 1.45)

func play_stage_song() -> void :
	GameManager.music_player.play_stage_song()

func teleport_player() -> void :
	if is_instance_valid(GameManager.player) and GameManager.player.has_health():
		if GameManager.player.is_executing("Ride"):
			GameManager.camera.set_ignore_translate(true)
			GameManager.camera.ignore_translate = true
			GameManager.player.get_node("Ride").ride.global_position = Vector2( - 4500, - 225)
			GameManager.camera.go_to_player()
		else:
			GameManager.camera.set_ignore_translate(true)
			GameManager.camera.ignore_translate = true
			GameManager.player.global_position = Vector2( - 4500, - 225)
			GameManager.camera.go_to_player()
