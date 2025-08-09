extends Node2D
onready var collapsing_repeating: Node2D = $".."
onready var splashaudio: AudioStreamPlayer2D = $splashaudio
onready var splash: AnimatedSprite = $splash
onready var splash_2: AnimatedSprite = $splash2

func _physics_process(_delta: float) -> void:
	kill_player_if_he_falls()
	kill_enemy_if_it_falls()

func kill_player_if_he_falls() -> void:
	if collapsing_repeating.active and is_instance_valid(GameManager.player):
		if GameManager.get_player_position().y > global_position.y and GameManager.player.has_health():
			GameManager.player.void_touch()
	pass

func kill_enemy_if_it_falls() -> void:
	if collapsing_repeating.spawned_enemies.size() > 0:
		for enemy in collapsing_repeating.spawned_enemies:
			if is_instance_valid(enemy) and enemy.has_health():
				if enemy.global_position.y > global_position.y:
					enemy.destroy()
					print_debug("Destroying falling enemy: " + enemy.name)
	pass
