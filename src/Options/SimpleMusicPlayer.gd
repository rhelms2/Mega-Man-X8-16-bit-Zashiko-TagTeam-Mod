extends AudioStreamPlayer
class_name SimpleMusicPlayer

export  var loop: AudioStream
export  var play_on_start: bool = true

var started_loop: bool = false

func _ready() -> void :
	if play_on_start:
		play()
	if loop:
		connect("finished", self, "play_loop")

func play_loop() -> void :
	if loop and not started_loop:
		started_loop = true
		stream = loop
		play()

func fade_out() -> void :
	var t = create_tween()
	t.tween_property(self, "volume_db", - 80, 1.5)

func play(_from_position: float = 0.0) -> void :
	.play()
