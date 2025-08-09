extends AttackAbility

export var drop_enemy : PackedScene
var tween : SceneTreeTween

func _Setup():
	attack_stage = 0
	start_tween()
	tween.tween_property(character,"position",Vector2(400,50),3).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)# warning-ignore:return_value_discarded
	tween.tween_property(character,"position",Vector2(500,-200),2).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)# warning-ignore:return_value_discarded

func _Update(_delta) -> void:
	if attack_stage == 0 and timer > 0.35:
		spawn_enemy()
		next_attack_stage()
	elif attack_stage == 1 and has_finished_last_animation():
		play_animation_once("open_loop")
		if timer > 0.5:
			spawn_enemy()
			timer = 0
		if character.position.x > 400-1:
			next_attack_stage()
			
	elif attack_stage == 2:
		play_animation_once("close")
		if has_finished_last_animation():
			play_animation("idle_loop")
			next_attack_stage()

	elif attack_stage == 3 and character.position.y <= -200+1:
		play_animation("idle_loop")
		start_tween()
		tween.tween_property(character,"position",Vector2(0,0),3).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE)# warning-ignore:return_value_discarded
		next_attack_stage_on_tween_end()
	
	elif attack_stage == 5:
		EndAbility()

func spawn_enemy() -> void:
	var enemy = instantiate(drop_enemy)
	enemy.set_direction(1)
	character.call_deferred("emit_signal_spawn",enemy)

func _Interrupt() -> void:
	end_tween()

func next_attack_stage_on_tween_end() -> void:
	next_attack_stage()
	tween.set_parallel(false)# warning-ignore:return_value_discarded
	tween.tween_callback(self,"next_attack_stage_on_next_frame")# warning-ignore:return_value_discarded
	
func start_tween() -> void:
	if tween:
		tween.kill()
	tween = create_tween()
	
func end_tween() -> void:
	if tween:
		tween.kill()
