extends Node2D


onready var room_red = $room_red
onready var room_white = $room_white

var fade_in: bool = false

func _ready() -> void :
	pass


func _process(delta: float) -> void :
	if fade_in:
		room_white.modulate.a += delta * 5
		if room_white.modulate.a >= 1.25:
			fade_in = false
	else:
		room_white.modulate.a -= delta * 2.5
		if room_white.modulate.a <= 0.1:
			fade_in = true

