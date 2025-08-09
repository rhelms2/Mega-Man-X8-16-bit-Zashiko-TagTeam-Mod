extends Node2D


func _ready() -> void :
	Tools.timer(1, "prep", self)
	Tools.timer(2, "gotoget", self)

func prep():
	GameManager.prepare_weapon_get("manowar_weapon", [])
	

func gotoget() -> void :
	GameManager.finished_fade_out()
