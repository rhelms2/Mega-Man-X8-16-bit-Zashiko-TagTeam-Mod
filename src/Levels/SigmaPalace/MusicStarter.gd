extends Area2D

onready var music: AudioStreamPlayer = $"../../Music Player"

export  var intro: AudioStream
export  var loop: AudioStream

var started: bool = false

func _on_body_entered(body: Node) -> void :
	if not started:
		started = true
		music.play_song_wo_fadein(loop, intro)

