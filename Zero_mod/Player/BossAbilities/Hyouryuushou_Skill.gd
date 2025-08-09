extends FallZero
class_name SaberHyouryuushou

export  var saber_hitbox: Resource = preload("res://Zero_mod/Player/Hitboxes/Hyouryuushou_Hitbox.tscn")
var current_hitbox = null
var hitbox_upleft = Vector2(0, 0)
var hitbox_downright = Vector2(0, 0)
var hitbox_damage = 0
var hitbox_damage_boss = 0
var hitbox_damage_weakness = 0
var hitbox_break_guard_value = 0.25
var hitbox_break_guards: bool = true
var hitbox_rehit_time = 0.075

var hitbox_upgraded: bool = true
var hitbox_extra_damage = 1
var hitbox_extra_damage_boss = 1
var hitbox_extra_damage_weakness = 1
var hitbox_extra_break_guard_value = 1

var deflectable: bool = false

onready var animatedSprite = character.get_node("animatedSprite")
onready var saber_sound: AudioStreamPlayer = $saber

var jumped: bool = false
var descend: bool = false

onready var particles = $particles2D
var start_speed = 90
var horizontal_speed = start_speed
var loop_frame = 21
var loop_start_frame = 10
var end_frame = 26

func _ready():
	Event.connect("saber_has_hit_boss", self, "reduce_speed")

func reset_hitbox():
	hitbox_upleft = Vector2(0, 0)
	hitbox_downright = Vector2(0, 0)
	hitbox_damage = 0
	hitbox_damage_boss = 0
	hitbox_damage_weakness = 0
	hitbox_break_guard_value = 0.25
	hitbox_break_guards = true
	hitbox_rehit_time = 0.075
	
func spawn_hitbox(_hitbox_upleft: Vector2, _hitbox_downright: Vector2):
	current_hitbox = saber_hitbox.instance()
	add_child(current_hitbox)
	var facing_direction = get_facing_direction()
	if facing_direction == - 1:
		var temp_upleft = Vector2( - _hitbox_downright.x, _hitbox_upleft.y)
		var temp_downright = Vector2( - _hitbox_upleft.x, _hitbox_downright.y)
		current_hitbox.set_hitbox_corners(temp_upleft, temp_downright)
	else:
		current_hitbox.set_hitbox_corners(_hitbox_upleft, _hitbox_downright)
		
	current_hitbox.damage = hitbox_damage * hitbox_extra_damage
	current_hitbox.damage_to_bosses = hitbox_damage_boss * hitbox_extra_damage_boss
	current_hitbox.damage_to_weakness = hitbox_damage_weakness * hitbox_extra_damage_weakness
	current_hitbox.break_guard_damage = hitbox_break_guard_value * hitbox_extra_break_guard_value
	current_hitbox.break_guards = hitbox_break_guards
	current_hitbox.saber_rehit = hitbox_rehit_time
	current_hitbox.upgraded = hitbox_upgraded
	
	current_hitbox.deflectable = deflectable

func hitbox_and_position():
	if animatedSprite.animation == "hyouryuushou":
		hitbox_damage = 3
		hitbox_damage_boss = 4
		hitbox_damage_weakness = 24
		hitbox_break_guards = true
		hitbox_rehit_time = 0.075
		if animatedSprite.frame >= loop_start_frame and animatedSprite.frame < loop_frame:
			hitbox_upleft = Vector2(3, - 58)
			hitbox_downright = Vector2(40, 18)
			
			spawn_hitbox(hitbox_upleft, hitbox_downright)
			
	reset_hitbox()

func end_saber_state():
	return animatedSprite.frame >= end_frame

func movement_speed_frames():
	return animatedSprite.frame >= loop_start_frame and animatedSprite.frame < loop_frame

func jump_frame():
	if not jumped:
		if animatedSprite.frame >= loop_start_frame:
			particles.emitting = true
			particles.position = Vector2(25 * get_facing_direction(), - 3)
			particles.z_index = animatedSprite.z_index + 1
			character.set_vertical_speed( - jump_velocity)
			jumped = true

func loop_animation():
	if jumped:
		if character.get_vertical_speed() < 0:
			if animatedSprite.frame >= loop_frame:
				animatedSprite.frame = loop_start_frame
		else:
			particles.emitting = false
			if not descend:
				descend = true
				animatedSprite.frame = 22

func set_saber_animations():
	animatedSprite.animation = "hyouryuushou"
	if character.is_on_floor():
		animatedSprite.frame = 0
	else:
		animatedSprite.frame = 6
	saber_sound.play()
	
func _StartCondition() -> bool:
	if not character.Hyouryuushou:
		return false
	if character.Hyouryuushou_used:
		return false
	if not character.get_action_pressed("move_up"):
		return false
	var _animation = get_parent().get_animation()
	if _animation in character.saber_animations:
		if _animation == "saber_dash":
			return false
		if _animation == "saber_jump":
			return false
		if _animation == "rasetsusen":
			return false
		if _animation == "youdantotsu":
			return false
		if _animation == "enkoujin":
			return false
		if _animation == "juuhazan":
			return false
		if _animation == "raikousen":
			return false
	if not executing:
		if character.is_on_floor():
			return true
		if not character.is_on_floor():
			return true
	return false
	
func _ResetCondition() -> bool:
	return false

func _EndCondition() -> bool:
	var _animation = get_parent().get_animation()
	if _animation in character.saber_animations:
		if not _animation == "hyouryuushou":
			return true
		if end_saber_state():
			return true
	else:
		return true
	return false

func _Setup() -> void :
	horizontal_speed = start_speed
	update_bonus_horizontal_only_conveyor()
	set_saber_animations()
	jumped = false
	descend = false
	character.Hyouryuushou_used = true
	character.dashjumps_since_jump = 0

func _Update(_delta: float) -> void :
	if jumped:
		process_gravity(_delta)
		
	jump_frame()
	loop_animation()
	hitbox_and_position()
	if movement_speed_frames():
		force_movement(horizontal_speed)
	else:
		force_movement(0)

func change_animation_if_falling(_s) -> void :
	animatedSprite.animation = "fall"




func _Interrupt():

	particles.emitting = false
	animatedSprite.animation = "fall"
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

