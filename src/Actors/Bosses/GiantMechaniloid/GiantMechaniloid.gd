extends Panda

const intro: AudioStream = preload("res://src/Sounds/OST - Metal Valley 1 - Intro.ogg")
const loop: AudioStream = preload("res://src/Sounds/OST - Metal Valley 1 - Loop.ogg")


func _ready() -> void :
	Event.listen("moved_player_to_checkpoint", self, "on_checkpoint")
	listen("zero_health", self, "_on_zero_health")

func on_checkpoint(checkpoint: CheckpointSettings) -> void :
	if checkpoint.id >= 4:
		destroy()

func _physics_process(_delta: float) -> void :
	var new_x = GameManager.camera.get_camera_screen_center().x - global_position.x
	animatedSprite.position.x = new_x / 3.4

func _on_rising_platform_at_max() -> void :
	Event.emit_signal("play_miniboss_music")
	Event.emit_signal("boss_start", self)
	emit_signal("intro_concluded")

func _on_zero_health() -> void :
	GameManager.music_player.start_fade_out()
	Tools.timer(2.0, "start_music", self)

func start_music() -> void :
	GameManager.music_player.play_song(loop, intro)

func _on_rising_platform_started() -> void :
	GameManager.music_player.start_fade_out()
