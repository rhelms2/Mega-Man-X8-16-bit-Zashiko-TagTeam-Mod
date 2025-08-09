extends Node

export var smoke : PackedScene
var active := false

func _ready() -> void:
	Event.connect("first_secret2_death",self,"deactivate")

func activate():
	active = true
	create_smoke()

func deactivate():
	active = false

func create_smoke():
	if active:
		var instance = smoke.instance()
		get_tree().current_scene.call_deferred("add_child",instance)
		instance.global_position = GameManager.get_player_position()
		Tools.timer(0.25,"create_smoke",self)
