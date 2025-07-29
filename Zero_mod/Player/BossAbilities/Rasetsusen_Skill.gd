extends FallZero
class_name SaberRasetsusen

export  var saber_hitbox: Resource = preload("res://Zero_mod/Player/Hitboxes/Rasetsusen_Hitbox.tscn")
var current_hitbox = null
var hitbox_upleft = Vector2(0, 0)
var hitbox_downright = Vector2(0, 0)
var hitbox_damage = 0
var hitbox_damage_boss = 0
var hitbox_damage_weakness = 0
var hitbox_break_guard_value = 0.5
var hitbox_break_guards: bool = false
var hitbox_rehit_time = 0.15

var hitbox_upgraded: bool = false
var hitbox_extra_damage = 0
var hitbox_extra_damage_boss = 0
var hitbox_extra_damage_weakness = 0
var hitbox_extra_break_guard_value = 0

var deflectable: bool = false

onready var animatedSprite = character.get_node("animatedSprite")

var current_weapon_index: = 0
var weapons = []
var current_weapon
var _listening_to_inputs_start: bool = true
var interrupted_cutscene: bool = false
var slashing: bool = false
var slashes = 0
var landed: bool = false

var max_time = 2.0
var fly_up: bool = false
var falling_down: bool = false
var horizontal_speed = horizontal_velocity
var cast_time_max = 0.35
var cast_time = 0.0

var vertical_last = 0

onready var saber_sound = get_node("saber")

func _ready():
	saber_sound.stream.loop = true

func reset_hitbox():
	hitbox_upleft = Vector2(0, 0)
	hitbox_downright = Vector2(0, 0)
	hitbox_damage = 0
	hitbox_damage_boss = 0
	hitbox_damage_weakness = 0
	hitbox_break_guard_value = 0.5
	hitbox_break_guards = false
	hitbox_rehit_time = 0.15
	
func spawn_hitbox(position: Vector2, _hitbox_upleft: Vector2, _hitbox_downright: Vector2):
	current_hitbox = saber_hitbox.instance()
	add_child(current_hitbox)

	
	var size = _hitbox_downright - _hitbox_upleft
	var radius = min(size.x, size.y) / 2

	
	current_hitbox.set_hitbox(position, radius)
		
	current_hitbox.damage = hitbox_damage * hitbox_extra_damage
	current_hitbox.damage_to_bosses = hitbox_damage_boss * hitbox_extra_damage_boss
	current_hitbox.damage_to_weakness = hitbox_damage_weakness * hitbox_extra_damage_weakness
	current_hitbox.break_guard_damage = hitbox_break_guard_value * hitbox_extra_break_guard_value
	current_hitbox.break_guards = hitbox_break_guards
	current_hitbox.saber_rehit = hitbox_rehit_time
	current_hitbox.upgraded = hitbox_upgraded
	
	current_hitbox.deflectable = deflectable

func hitbox_and_position():
	hitbox_damage = 2
	hitbox_damage_boss = 2
	hitbox_damage_weakness = 24
	if animatedSprite.animation == "rasetsusen":
		if animatedSprite.frame >= 1 and animatedSprite.frame < 9:
			hitbox_upleft = Vector2( - 48, - 48)
			hitbox_downright = Vector2(48, 48)
			
	spawn_hitbox(Vector2(0, - 8), hitbox_upleft, hitbox_downright)
	reset_hitbox()

func end_saber_state():
	return animatedSprite.frame >= 9

func should_add_saber_combo():
	return animatedSprite.frame >= 9

func reset_saber_animation():
	if not character.is_on_floor():
		animatedSprite.animation = "rasetsusen"
		animatedSprite.frame = 1
	
func _StartCondition() -> bool:
	if not character.Rasetsusen:
		return false
	if character.Rasetsusen_used:
		return false
	if character.get_action_pressed("move_up"):
		return false
	if character.get_action_pressed("move_down"):
		return false
	var _animation = get_parent().get_animation()
	for _ani in character.saber_animations:
		if _animation == "saber_dash":
			return false
		if _animation == "saber_jump":
			return false
		if _animation == "youdantotsu":
			return false
		if _animation == "enkoujin":
			return false
		if _animation == "juuhazan":
			return false
		if _animation == "raikousen":
			return false
		if _animation == "hyouryuushou":
			return false
	if not executing:
		if not character.is_on_floor():
			vertical_last = character.velocity.y
			return true
	return false
	
func _ResetCondition() -> bool:
	return false

func _EndCondition() -> bool:
	if cast_time >= cast_time_max:
		return true
	if end_saber_state():
		if not character.get_action_pressed(actions[0]):
			return true
	if character.is_on_floor():
		return true
	return false

func _Setup() -> void :
	saber_sound.play()
	horizontal_velocity = 0
	horizontal_speed = 0
	character.set_horizontal_speed(0)
	character.set_vertical_speed(0)
	character.dashfall = false
	character.Rasetsusen_used = true
	fly_up = false
	falling_down = false
	timer = 0.0
	character.dashjumps_since_jump = 0
	cast_time = 0.0
	
	
func _Update(_delta: float) -> void :
	timer += _delta
	if fly_up:
		cast_time += _delta


		
	if not falling_down:
		if (character.get_action_pressed("move_down") and timer >= 0.2 or timer >= max_time) and not fly_up:
			falling_down = true
			timer = max_time
			character.set_vertical_speed(jump_velocity)
			if character.get_action_pressed("move_left") or character.get_action_pressed("move_right"):
				horizontal_speed = dashjump_speed
				character.dashjumps_since_jump = 1
		set_movement_and_direction(0, _delta)
	else:
		horizontal_velocity = horizontal_speed
		force_movement(horizontal_speed)
		if fly_up:
			character.set_vertical_speed( - jump_velocity)
		
	hitbox_and_position()
	if should_add_saber_combo():
		if character.get_action_pressed(actions[0]):
			reset_saber_animation()

	

func change_animation_if_falling(_s) -> void :
	animatedSprite.animation = "fall"

func _Interrupt():
	slashes = 0
	saber_sound.stop()
	if is_instance_valid(current_hitbox):
		current_hitbox.queue_free()

func Initialize() -> void :
	executing = true
	timer = 0
	last_time_used = get_time()
	character.executing_moves.append(self)
	emit_signal("executed")
	play_sound_on_initialize()
	play_animation_on_initialize()

func BeforeEveryFrame(_delta: float) -> void :
	pass

