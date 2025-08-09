extends AttackAbility
var tween : SceneTreeTween
onready var animated_sprite: AnimatedSprite = $"../animatedSprite"

func _Setup():
	attack_stage = 0
	animated_sprite.z_index = 20
	character.ignore_bike_melee = true
	#timer = 0

func _Update(_delta) -> void:
	if attack_stage == 0:
		start_tween()
		tween.tween_property(character,"position:y",-10,0.5).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)# warning-ignore:return_value_discarded
		tween.tween_property(character,"position",get_target(),1.35).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CUBIC)# warning-ignore:return_value_discarded
		next_attack_stage_on_tween_end()
	
	if attack_stage == 1 and has_finished_last_animation():
		play_animation_once("dive_loop")

	elif attack_stage == 2 and timer > 1:
		play_animation("idle_loop")
		character.ignore_bike_melee = false
		animated_sprite.z_index = 0
		character.position.y = -200
		start_tween()
		tween.tween_property(character,"position",Vector2(0,0),3).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE)# warning-ignore:return_value_discarded
		next_attack_stage_on_tween_end()

	elif attack_stage == 4:
		end_tween()
		set_vertical_speed(0)
		EndAbility()

func get_target() -> Vector2:
	return Vector2(clamp(get_distance_to_player()*2,-300,300),260)

func _Interrupt() -> void:
	animated_sprite.z_index = 0
	character.ignore_bike_melee = false
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

