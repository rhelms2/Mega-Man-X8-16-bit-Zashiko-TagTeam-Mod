extends Node
onready var character: KinematicBody2D = $".."


func _ready() -> void:
	#activate()
	pass

func activate():
	GameManager.player.connect("received_damage",self,"on_damage_player")
	pass

func on_damage_player():
	if character.has_health() and character.current_health < character.max_health:
		character.recover_health(10)
	pass

func _on_Intro_executed() -> void:
	activate()
	pass # Replace with function body.
