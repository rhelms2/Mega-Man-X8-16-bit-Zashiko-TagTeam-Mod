extends Node2D

export  var movespeed: int = - 60
export  var active: bool = true

var speed: int = 0

signal activated
signal player_reached_bottom

func set_game_modes() -> void :
	if CharacterManager.game_mode == - 1:
		movespeed = - 12
	elif CharacterManager.game_mode == 0:
		movespeed = - 24
	elif CharacterManager.game_mode == 1:
		movespeed = - 60
	elif CharacterManager.game_mode == 2:
		movespeed = - 70
	elif CharacterManager.game_mode >= 3:
		movespeed = - 80

func _ready() -> void :
	set_game_modes()

func start(_b) -> void :
	active = true
	speed = movespeed
	emit_signal("activated")

func stop() -> void :
	active = false
	speed = 0

func emit_reached_signal(_b) -> void :
	emit_signal("player_reached_bottom")
