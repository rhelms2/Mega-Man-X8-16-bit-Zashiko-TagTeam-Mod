extends EnemyDeath


func _Setup():
	if explosion_duration == 0:
		audioplayer.play()
	Event.emit_signal("enemy_kill",character)
	explosions.emitting = true
	sprite.play("defeat_fall")
	force_move
	#sprite.playing = false
	#sprite.material.set_shader_param("Alpha_Blink", 1)
	#extra_actions_at_death_start()

func _StartCondition() -> bool:
	return false

func _Update(_delta):
	if timer > times_sound_played/5 and timer < explosion_duration:
		times_sound_played += 1
		var audio = audioplayer.duplicate()
		add_child(audio)
		audio.pitch_scale = rand_range(0.95,1.05)
		audio.play()
	if timer > explosion_duration:
		if explosions.emitting:
			spawn_item()
			emit_remains_particles()
			character.emit_signal("death")
			extra_actions_after_death()
			explosions.emitting = false
		sprite.visible = false
