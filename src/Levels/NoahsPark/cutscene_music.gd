extends AudioStreamPlayer

onready var tween: = TweenController.new(self, false)
onready var base_db: = volume_db
var played_intro: = false
onready var loop: AudioStreamPlayer = $loop

func fade_in(duration: = 1.0):
	volume_db = - 80
	play()
	tween.reset()
	tween.attribute("volume_db", base_db, duration)

func play(from_position: = 0.0):
	if stream and not played_intro:
		prepare_loop()
		.play(from_position)
	else:
		loop.play(from_position)

func fade_out(duration: = 1.0):
	tween.reset()
	tween.attribute("volume_db", - 50, duration)
	tween.add_callback("stop")
	tween.attribute("volume_db", - 50, duration, loop)
	tween.add_callback("stop", loop)
	tween.add_callback("stop")

func stop():
	reset_timer()
	.stop()

func play_loop():
	loop.play()
	reset_timer()

func prepare_loop() -> void :
	connect("finished", self, "play_loop")

func reset_timer():
	if is_connected("finished", self, "play_loop"):
		disconnect("finished", self, "play_loop")
	played_intro = false
	
