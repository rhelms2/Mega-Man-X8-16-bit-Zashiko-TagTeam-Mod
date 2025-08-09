extends BossDeath

var player_final_position : Vector2

func _ready() -> void:
	player_final_position = global_position
	player_final_position.x -= 100

func _Setup():
	character.play_animation(death_animation)
	character.set_horizontal_speed(0)
	character.set_vertical_speed(0)
	Event.emit_signal("enemy_kill","boss")
	GameManager.start_end_cutscene()
	#sprite.playing = false
	touch_damage.active = false
	elapsed_explosion_time = 0.0
	background.scale.x = 100
	background.scale.y = 40 
	GameManager.pause(character.name + name)
	freeze_moment = OS.get_ticks_msec()

func _Interrupt():
	elapsed_explosion_time = 0.0
	elapsed_alpha_time = 0.0
	elapsed_color_time = 0.0
	tempo = 0
	darken = 1
	sprite_alpha = 1
	freeze_over = false
	explosion_over = false
	character.emit_signal("death")
	Event.emit_signal("boss_health_hide")
	get_parent().queue_free()
