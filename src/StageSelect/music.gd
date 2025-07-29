extends AudioStreamPlayer

export  var intro: AudioStream

var music: AudioStream
var playing_intro: bool = false


func _ready() -> void :
	music = stream
	Event.emit_signal("gateway_reset_segment_cleared")

func play_with_intro(intro_song: AudioStream = intro, loop: AudioStream = music) -> void :
	playing_intro = true
	music = loop
	stream = intro_song
	play()

func _on_music_finished() -> void :
	if playing_intro:
		stream = music
		play()
		playing_intro = false

func fade_out(duration: float = 1.0) -> void :
	var tween = create_tween()
	tween.tween_property(self, "volume_db", - 80, duration)
