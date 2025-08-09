extends SimplePlayerProjectile
var target_list : Array
var interval := 0.064
const continuous_damage := true
onready var thunder: AudioStreamPlayer2D = $thunder

func _DamageTarget(body) -> int:
	target_list.append(body)
	return 0

func _OnHit(_target_remaining_HP) -> void: #override
	pass

func _OnDeflect() -> void:
	pass

func _Setup() -> void:
	global_position.x += 36 * get_facing_direction()
	Tools.timer(0.75,"end_animation",self)
	thunder.play_rp(0.07,0.85)
	move_slowly_foward()
	next_attack_stage()

func move_slowly_foward() -> void:
	var tween = create_tween()
	var initial_speed = 100 * get_facing_direction()
	tween.tween_method(self,"set_horizontal_speed",initial_speed,0,0.5)
	tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)

func end_animation() -> void:
	animatedSprite.play("end")
	next_attack_stage()

func _Update(_delta) -> void:
	if attack_stage == 1:
		if timer > interval:
			damage_targets_in_list()
			timer = 0.0
	
	elif attack_stage == 2:
		disable_damage()
		if timer > 0.5:
			disable_visuals()
			next_attack_stage()
	
	if ending and timer > 0.4:
		destroy()

func damage_targets_in_list() -> void:
	if target_list.size() > 0:
		for body in target_list:
			if is_instance_valid(body):
				body.damage(damage, self)

func leave(_body) -> void:
	if _body in target_list:
		target_list.erase(_body)
