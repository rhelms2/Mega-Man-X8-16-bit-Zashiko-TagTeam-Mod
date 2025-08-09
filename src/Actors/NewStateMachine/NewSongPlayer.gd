extends AudioStreamPlayer

onready var loop: AudioStreamPlayer = get_node_or_null("loop")
onready var tween: = TweenController.new(self, false)
onready var base_volume: = volume_db
onready var should_loop: = false
var queued: = false
var has_loop: = false

func _ready() -> void :
	has_loop = loop != null
	Event.connect("half_music_volume", self, "set_volume", [base_volume - 10])
	Event.connect("normal_music_volume", self, "set_volume", [base_volume])
	Event.connect("player_death", self, "fade_out", [6])
	if has_loop:
		loop.volume_db = base_volume

func set_volume(value: float):
	tween.reset()
	
	volume_db = value
	if has_loop:
		loop.volume_db = value

func fade_out(duration: = 1.0):
	tween.reset()
	tween.attribute("volume_db", - 50, duration)
	if has_loop:
		tween.attribute("volume_db", - 50, duration, loop)
	tween.add_callback("stop")
	
func fade_in(duration: = 1.0):
	tween.reset()
	play()
	tween.attribute("volume_db", base_volume, duration)
	if has_loop:
		tween.attribute("volume_db", base_volume, duration, loop)

func queue_loop():
	if not queued:
		queued = true
		var position: = get_playback_position()
		var length: = stream.get_length()
		Tools.timer(length - position, "start_loop", self)

func start_loop():
	loop.play()

func play(from_position: = 0.0):
	if has_loop:
		if loop.playing:
			return
	
	.play(from_position)
	if has_loop:
		queue_loop()

func stop():
	loop.stop()
	queued = false
	.stop()
