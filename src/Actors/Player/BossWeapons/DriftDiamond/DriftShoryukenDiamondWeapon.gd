extends MultiShotWeapon

func _ready() -> void :
	Event.listen("damage", self, "finish")
	Event.listen("player_death", self, "finish")
	character.listen("cutscene_deactivate", self, "finish")
	weapon_stasis.connect("interrupted", self, "finish")
	
func fire_charged() -> void :
	play(weapon.charged_sound)
	var pos = character.global_position
	var ss = instantiate_projectile(weapon.charged_shot)
	ss.global_position = pos
	driftshoryuken = ss
	var dir = define_direction(driftshoryuken)
	executing = true
	character.add_invulnerability("DriftShoryuken")
	character.animatedSprite.modulate = Color(1, 1, 1, 0.01)
	weapon_stasis.ExecuteOnce()
	weapon_stasis.play_animation_once("jump")
	tween.create(Tween.EASE_OUT, Tween.TRANS_CUBIC)
	tween.add_method("set_horizontal_speed", 280.0 * dir, 0.0, 0.4, character)
	tween.create(Tween.EASE_IN, Tween.TRANS_CUBIC)
	tween.add_method("set_vertical_speed", - 340.0, 0.0, 0.4, character)
	tween.add_callback("finish")

func define_direction(_driftshoryuken) -> int:
	var dir = 0
	if Input.is_action_pressed("move_left"):
		dir = - 1
	elif Input.is_action_pressed("move_right"):
		dir = 1
	if dir != 0:
		character.set_direction(dir)
	else:
		dir = character.get_facing_direction()
	return dir

func finish() -> void :
	if executing:
		executing = false
		if is_instance_valid(driftshoryuken):
			driftshoryuken.finish()
		weapon_stasis.EndAbility()
		character.set_horizontal_speed(0)
		character.set_vertical_speed(0)
		tween.reset()
		Tools.timer_p(0.25, "remove_invulnerability", character, "DriftShoryuken")
		character.animatedSprite.modulate = Color(1, 1, 1, 1)

func _on_Forced_ability_start(_ability) -> void :
	if executing:
		finish()
