extends Movement
class_name NovaStrike

export  var hitbox: Resource = preload("res://X_mod/UltimateX/Player/NovaStrike/NovaStrike_Hitbox.tscn")
export  var upgraded: bool = true

onready var animatedSprite: = character.get_node("animatedSprite")
onready var sfx: = $sfx

var current_hitbox: Object = null
var hitbox_upleft: Vector2 = Vector2(0, 0)
var hitbox_downright: Vector2 = Vector2(0, 0)
var hitbox_damage = 0
var hitbox_damage_boss = 0
var hitbox_damage_weakness = 0
var hitbox_break_guard_value: float = 0.25
var hitbox_break_guards: bool = true
var hitbox_rehit_time: float = 0.4

var hitbox_upgraded: bool = true
var hitbox_extra_damage = 1
var hitbox_extra_damage_boss = 1
var hitbox_extra_damage_weakness = 1
var hitbox_extra_break_guard_value = 1

var sfx_played: bool = false

var start_speed: int = 500
var horizontal_speed: int = start_speed
var damping: float = 0.93
var vertical_start_speed: int = 250
var vertical_speed: int = vertical_start_speed


func reset_hitbox() -> void :
	hitbox_upleft = Vector2(0, 0)
	hitbox_downright = Vector2(0, 0)
	hitbox_damage = 0
	hitbox_damage_boss = 0
	hitbox_damage_weakness = 0
	hitbox_break_guard_value = 0.25
	hitbox_break_guards = true
	hitbox_rehit_time = 0.4

func set_hitbox_corners(upleft: Vector2, downright: Vector2) -> RectangleShape2D:
	var shape = RectangleShape2D.new()
	var size = downright - upleft
	shape.extents = size / 2
	return shape

func spawn_hitbox(_hitbox_upleft: Vector2, _hitbox_downright: Vector2) -> void :
	current_hitbox = hitbox.instance()
	var collision_shape_node = current_hitbox.get_node("collisionShape2D")
	if collision_shape_node == null:
		return
	else:
		current_hitbox.collision_shape = collision_shape_node
	
	var hitbox_shape = set_hitbox_corners(_hitbox_upleft, _hitbox_downright)
	var hitbox_position = Vector2(0, 0)
	
	var facing_direction = get_facing_direction()
	if facing_direction == - 1:
		var temp_upleft = Vector2( - _hitbox_downright.x, _hitbox_upleft.y)
		var temp_downright = Vector2( - _hitbox_upleft.x, _hitbox_downright.y)
		hitbox_shape = set_hitbox_corners(temp_upleft, temp_downright)
		hitbox_position = (temp_upleft + temp_downright) / 2
	else:
		hitbox_shape = set_hitbox_corners(_hitbox_upleft, _hitbox_downright)
		hitbox_position = (_hitbox_upleft + _hitbox_downright) / 2
	
	current_hitbox.collision_shape.shape = hitbox_shape
	current_hitbox.position = hitbox_position
	
	add_child(current_hitbox)
		
	current_hitbox.damage = hitbox_damage * hitbox_extra_damage
	current_hitbox.damage_to_bosses = hitbox_damage_boss * hitbox_extra_damage_boss
	current_hitbox.damage_to_weakness = hitbox_damage_weakness * hitbox_extra_damage_weakness
	current_hitbox.break_guards = hitbox_break_guards
	current_hitbox.upgraded = hitbox_upgraded
	current_hitbox.rehit = hitbox_rehit_time

func hitbox_and_position() -> void :
	hitbox_damage = 30
	hitbox_damage_boss = 30
	hitbox_damage_weakness = 50
	hitbox_break_guards = true
	hitbox_rehit_time = 0.075
	if animatedSprite.frame >= 10 and animatedSprite.frame < 19:
		hitbox_upleft = Vector2( - 57, - 33)
		hitbox_downright = Vector2(28, 17)
		spawn_hitbox(hitbox_upleft, hitbox_downright)
	reset_hitbox()

func play_sfx() -> void :
	if animatedSprite.frame >= 7:
		if not sfx_played:
			sfx.play()
			sfx_played = true

func end_state() -> bool:
	return animatedSprite.frame >= 21

func invicible_frames() -> bool:
	return animatedSprite.frame >= 9 and animatedSprite.frame < 19

func movement_frames() -> bool:
	return animatedSprite.frame >= 9 and animatedSprite.frame < 21

func _StartCondition() -> bool:
	if not executing:
		if character.execute_nova_strike:
			return true
	return false

func _ResetCondition() -> bool:
	return false

func _EndCondition() -> bool:
	if end_state():
		return true
	if not animatedSprite.animation == "nova_strike":
		return true
	return false

func _Setup() -> void :
	sfx_played = false
	horizontal_speed = start_speed
	vertical_speed = vertical_start_speed
	update_bonus_horizontal_only_conveyor()
	animatedSprite.animation = "nova_strike"

func reduce_speed() -> void :
	horizontal_speed = 0

func damp_horizontal_speed(_delta: float) -> void :
	var reference_delta = 1.0 / 120
	var damping_factor = pow(damping, _delta / reference_delta)
	horizontal_speed *= damping_factor

func damp_vertical_speed(_delta: float) -> void :
	var reference_delta = 1.0 / 120
	var damping_factor = pow(damping, _delta / reference_delta)
	vertical_speed *= damping_factor

func _Update(_delta: float) -> void :
	hitbox_and_position()
	play_sfx()
	if movement_frames():
		force_movement(horizontal_speed)
		
		character.set_vertical_speed(0)
	else:
		
		force_movement(150)
		damp_vertical_speed(_delta)
		character.set_vertical_speed( - vertical_speed)
		
	if invicible_frames():
		character.add_invulnerability("NovaStrike")
	else:
		character.remove_invulnerability("NovaStrike")
	update_bonus_horizontal_only_conveyor()

func change_animation_if_falling(_s) -> void :
	pass

func _Interrupt() -> void :
	._Interrupt()
	character.execute_nova_strike = false
	character.remove_invulnerability("NovaStrike")
	if is_instance_valid(current_hitbox):
		current_hitbox.queue_free()
