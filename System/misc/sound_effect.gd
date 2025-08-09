extends Node2D

onready var audio_stream: AudioStreamPlayer2D = $AudioStreamPlayer2D


func _ready() -> void :
	audio_stream.connect("finished", self, "_on_sound_finished")

func _on_sound_finished() -> void :
	queue_free()

func play_sound(audio) -> void :
	if audio == null:
		queue_free()
		return
	audio_stream.stream = audio
	audio_stream.play()
