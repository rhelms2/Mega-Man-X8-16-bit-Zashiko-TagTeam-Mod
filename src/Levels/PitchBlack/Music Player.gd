extends MusicPlayer

export  var alarm_intro: AudioStream
export  var alarm_song: AudioStream

var timer: Timer = Timer.new()
var played_alarm: bool = false


func _ready() -> void :
	Event.listen("alarm", self, "play_alarm_song")
	Event.listen("turn_off_alarm", self, "on_reset_lights")

func on_reset_lights() -> void :
	if played_alarm:
		start_fade_out()
		timer.connect("timeout", self, "play_stage_song")
		timer.one_shot = true
		add_child(timer)
		timer.start()
		played_alarm = false

func play_alarm_song() -> void :
	played_alarm = true
	play_song(alarm_song, alarm_intro)
