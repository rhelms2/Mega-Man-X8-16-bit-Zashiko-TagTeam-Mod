extends Node2D
onready var explosion: Particles2D = $explosion
onready var remains: Particles2D = $remains
onready var box: StaticBody2D = $".."

func activate() -> void :
	explosion.emitting = true
	remains.emitting = true
	spawn_item()

func spawn_item() -> void :
	var item = GameManager.get_next_spawn_item(0, 0, 0, 0, 0, 0)
	if CharacterManager.game_mode < 0:
		item = GameManager.get_next_spawn_item(100, 15, 40, 10, 30, 5)
	elif CharacterManager.game_mode == 0:
		item = GameManager.get_next_spawn_item(85, 50, 25, 5, 5, 1)
	elif CharacterManager.game_mode == 1:
		item = GameManager.get_next_spawn_item(65, 50, 25, 5, 5, 0.1)
	elif CharacterManager.game_mode == 2:
		item = GameManager.get_next_spawn_item(40, 40, 15, 30, 15, 0)
	else:
		item = GameManager.get_next_spawn_item(0, 0, 0, 0, 0, 0)
	
	if item:
		var spawned_item = item.instance()
		spawned_item.global_position = box.global_position
		spawned_item.velocity.y = - 100
		spawned_item.expirable = true
		box.get_parent().call_deferred("add_child", spawned_item)
