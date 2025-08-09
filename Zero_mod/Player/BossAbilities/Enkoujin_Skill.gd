extends FallZero
class_name SaberEnkoujin

export  var saber_hitbox: Resource = preload("res://Zero_mod/Player/Hitboxes/Enkoujin_Hitbox.tscn")
var current_hitbox = null
var hitbox_upleft = Vector2(0, 0)
var hitbox_downright = Vector2(0, 0)
var hitbox_damage = 0
var hitbox_damage_boss = 0
var hitbox_damage_weakness = 0
var hitbox_break_guard_value = 0.4
var hitbox_break_guards: bool = false
var hitbox_rehit_time = 0.05

var hitbox_upgraded: bool = false
var hitbox_extra_damage = 1
var hitbox_extra_damage_boss = 1
var hitbox_extra_damage_weakness = 1
var hitbox_extra_break_guard_value = 1

var deflectable: bool = false

onready var animatedSprite = character.get_node("animatedSprite")
onready var saber_sound = get_node("saber")

var current_weapon_index: = 0
var weapons = []
var current_weapon
var _listening_to_inputs_start: bool = true
var interrupted_cutscene: bool = false
var slashing: bool = false
var slashes = 0
var landed: bool = false
var cancel_time = 0.3
var hitbox_timer = 0.0
var hitbox_time = 0.05

var landing_frame = 9
var loop_frame = 8
var loop_start_frame = 4

func reset_hitbox():
	hitbox_upleft = Vector2(0, 0)
	hitbox_downright = Vector2(0, 0)
	hitbox_damage = 0
	hitbox_damage_boss = 0
	hitbox_damage_weakness = 0
	hitbox_break_guard_value = 0.4
	hitbox_break_guards = false
	hitbox_rehit_time = 0.05
	current_hitbox = null
	
func spawn_hitbox(_hitbox_upleft: Vector2, _hitbox_downright: Vector2):
	current_hitbox = saber_hitbox.instance()
	get_tree().root.add_child(current_hitbox)
	
	var facing_direction = get_facing_direction()
	
	var position_x = global_position.x - 3 * facing_direction
	var position_y = global_position.y + 30
	var hitbox_position = Vector2(position_x, position_y)
	
	if facing_direction == - 1:
		var temp_upleft = Vector2( - _hitbox_downright.x, _hitbox_upleft.y)
		var temp_downright = Vector2( - _hitbox_upleft.x, _hitbox_downright.y)
		current_hitbox.set_hitbox(temp_upleft, temp_downright, hitbox_position)
	else:
		current_hitbox.set_hitbox(_hitbox_upleft, _hitbox_downright, hitbox_position)
	current_hitbox.z_index = character.z_index + 5
	current_hitbox.modulate = Color(1, 1, 1, 0.5)
	current_hitbox.animatedSprite.scale = Vector2(0.75, 0.75)

	current_hitbox.damage = hitbox_damage * hitbox_extra_damage
	current_hitbox.damage_to_bosses = hitbox_damage_boss * hitbox_extra_damage_boss
	current_hitbox.damage_to_weakness = hitbox_damage_weakness * hitbox_extra_damage_weakness
	current_hitbox.break_guard_damage = hitbox_break_guard_value * hitbox_extra_break_guard_value
	current_hitbox.break_guards = hitbox_break_guards
	current_hitbox.saber_rehit = hitbox_rehit_time
	current_hitbox.upgraded = hitbox_upgraded
	
	current_hitbox.deflectable = deflectable
	

func hitbox_and_position():
	hitbox_damage = 10
	hitbox_damage_boss = 4
	hitbox_damage_weakness = 30
	if animatedSprite.animation == "enkoujin":
		if animatedSprite.frame >= 4 and animatedSprite.frame < 14:
			hitbox_upleft = Vector2(1, - 33)
			hitbox_downright = Vector2(33, 20)
			
			spawn_hitbox(hitbox_upleft, hitbox_downright)
	reset_hitbox()

func should_go_down():
	if animatedSprite.animation == "enkoujin":
		return animatedSprite.frame >= loop_start_frame
	
func end_saber_state():
	if character.is_on_floor():
		if animatedSprite.animation == "enkoujin":
			return animatedSprite.frame >= 14

func repeat_animation():
	if animatedSprite.animation == "enkoujin":
		if animatedSprite.frame >= loop_frame:
			animatedSprite.frame = loop_start_frame

func set_saber_animations():
	if not character.is_on_floor():
		animatedSprite.animation = "enkoujin"
		animatedSprite.frame = 0
	saber_sound.play()
	
func _StartCondition() -> bool:
	if not character.Enkoujin:
		return false
	if not character.get_action_pressed("move_down"):
		return false
	var _animation = get_parent().get_animation()
	for _ani in character.saber_animations:
		if _animation == "saber_dash":
			return false
		if _animation == "tenshouha":
			return false
		if _animation == "juuhazan":
			return false
		if _animation == "rasetsusen":
			return false
		if _animation == "raikousen":
			return false
		if _animation == "saber_jump":
			return false
		if _animation == "youdantotsu":
			return false
		if _animation == "hyouryuushou":
			return false
	if not executing:
		if not character.is_on_floor():
			return true
	return false
	
func _ResetCondition() -> bool:
	return false

func _EndCondition() -> bool:
	if not character.is_on_floor():
		if not character.get_action_pressed("alt_fire") and timer >= cancel_time:
			return true
	var _animation = get_parent().get_animation()
	if _animation in character.saber_animations:
		if end_saber_state():
			return true
	else:
		return true
	return false

func _Setup() -> void :
	landed = false
	set_saber_animations()
	character.set_horizontal_speed(0)
	character.set_vertical_speed(0)
	character.dashjumps_since_jump = 0

func _Update(_delta: float) -> void :
	if timer < cancel_time:
		timer += _delta
	hitbox_time = 0.05
	if hitbox_timer < hitbox_time:
		hitbox_timer += _delta
	else:
		hitbox_timer = 0
		hitbox_and_position()
		
	
	if not landed:
		set_movement_no_direction(horizontal_velocity)
		repeat_animation()
		if should_go_down():
			character.set_vertical_speed(jump_velocity)
			
		var animation_frame = animatedSprite.frame
		if character.is_on_floor():
			animatedSprite.frame = landing_frame
			landed = true
	else:
		process_gravity(_delta)
		force_movement(0)
		update_bonus_horizontal_only_conveyor()

func change_animation_if_falling(_s) -> void :
	pass

func _Interrupt():
	if character.is_on_floor():
		animatedSprite.animation = "saber_recover"
	if is_instance_valid(current_hitbox):
		current_hitbox.queue_free()

func BeforeEveryFrame(_delta: float) -> void :
	pass

