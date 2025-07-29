extends AudioStreamPlayer

onready var end: AudioStreamPlayer = $end
onready var tween: = TweenController.new(self, false)
var queued: = false

func fade_out(duration: = 1.0):
	tween.reset()
	tween.attribute("volume_db", - 50, duration)
	tween.attribute("volume_db", - 50, duration, end)
	tween.add_callback("stop")

func queue_ending():
	if not queued:
		queued = true
		var position: = get_playback_position()
		var length: = stream.get_length()
		Tools.timer(length - position, "start_end", self)

func start_end():
	if playing:
		stop()
		end.play()

func stop():
	end.stop()
	.stop()
