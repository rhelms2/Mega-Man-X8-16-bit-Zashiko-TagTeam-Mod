extends Movement
class_name DodgeAxl

export  var dash_duration: float = 0.55
export  var upgraded: bool = true
export  var invulnerability_duration: float = 0.475
export  var leeway: float = 0.1

onready var animatedSprite = character.get_node("animatedSprite")
onready var during_image = get_node("duringImage")


func get_activation_leeway_time() -> float:
	return leeway

func _Setup() -> void :
	update_bonus_horizontal_only_conveyor()
	character.reduce_hitbox()
	changed_animation = false

func _process(_delta: float) -> void :
	pass

func _Update(_delta: float) -> void :
	process_invulnerability()
	if character.get_animation() == "dodge":
		if animatedSprite.frame <= 5:
			force_movement(horizontal_velocity)
		else:
			force_movement(0)
		if animatedSprite.frame >= 0 and animatedSprite.frame <= 5:
			invulnerable(true)
		else:
			invulnerable(false)
	else:
		force_movement(0)
		EndAbility()
	process_gravity(_delta)

func process_gravity(delta: float, gravity: = default_gravity, _s = "null") -> void :
	.process_gravity(delta, gravity)
	activate_low_jumpcasts_after_delay(delta)

func change_animation_if_falling(_s) -> void :
	
	character.start_dashfall()

func _Interrupt() -> void :
	character.call_deferred("increase_hitbox")
	invulnerable(false)
	._Interrupt()

func synchronize_during_image():
	if invulnerability_duration > 0:
		during_image.animation = animatedSprite.animation
		during_image.frames = character.animatedSprite.frames
		during_image.frame = character.animatedSprite.frame
		during_image.offset = character.animatedSprite.offset
		during_image.flip_h = character.animatedSprite.flip_h
		during_image.flip_v = character.animatedSprite.flip_v
		during_image.frame = character.animatedSprite.frame
		during_image.set_scale(Vector2(character.get_facing_direction(), 1))
		
func invulnerable(state: bool) -> void :
	if upgraded and invulnerability_duration > 0:
		if state:
			character.add_invulnerability(name)
		else:
			character.remove_invulnerability(name)
		

func process_invulnerability() -> void :
	if upgraded and invulnerability_duration > 0:
		
		if timer > invulnerability_duration:
			invulnerable(false)

func _StartCondition() -> bool:
	if character.is_on_floor():
		if character.get_animation() == "dash" and get_action_just_pressed(actions[0]):
			return true
		if character.holding_down and get_action_just_pressed(actions[1]):
			return true
	return false

func _ResetCondition() -> bool:
	return false

func _EndCondition() -> bool:
	if character.is_on_floor():
		if animatedSprite.frame >= 7:
			return true
	else:
		if animatedSprite.frame >= 5:
			return true
	return false
