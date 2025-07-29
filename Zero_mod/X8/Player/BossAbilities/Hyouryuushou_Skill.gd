extends FallZero
class_name SaberHyouryuushouX8

export  var damage: float = 3
export  var damage_boss: float = 4
export  var damage_weakness: float = 24
export  var saber_hitbox: Resource = preload("res://Zero_mod/Player/Hitboxes/Hyouryuushou_Hitbox.tscn")

onready var animatedSprite: = character.get_node("animatedSprite")
onready var saber_sound: AudioStreamPlayer = $saber
onready var particles: = $particles2D

var current_hitbox = null
var hitbox_upleft: Vector2 = Vector2(0, 0)
var hitbox_downright: Vector2 = Vector2(0, 0)
var hitbox_damage: float = 0
var hitbox_damage_boss: float = 0
var hitbox_damage_weakness: float = 0
var hitbox_break_guard_value: float = 0.25
var hitbox_break_guards: bool = true
var hitbox_rehit_time: float = 0.075
var hitbox_upgraded: bool = true
var hitbox_extra_damage: float = 1
var hitbox_extra_damage_boss: float = 1
var hitbox_extra_damage_weakness: float = 1
var hitbox_extra_break_guard_value: float = 1
var deflectable: bool = false
var deflectable_type: int = 0
var only_deflect_weak: bool = false

var jumped: bool = false
var descend: bool = false

var ending_saber_state: bool = false
var start_speed: int = 90
var horizontal_speed: float = start_speed
var loop_frame: int = 10
var loop_start_frame: int = 4
var end_frame: int = 26


func _ready() -> void :
	animatedSprite.connect("animation_finished", self, "_on_animation_finished")

func _on_animation_finished() -> void :
	ending_saber_state = true

func reset_hitbox() -> void :
	hitbox_upleft = Vector2(0, 0)
	hitbox_downright = Vector2(0, 0)
	hitbox_damage = 0
	hitbox_damage_boss = 0
	hitbox_damage_weakness = 0
	hitbox_break_guard_value = 0.25

func set_hitbox_corners(upleft: Vector2, downright: Vector2) -> RectangleShape2D:
	var shape = RectangleShape2D.new()
	var size = downright - upleft
	shape.extents = size / 2
	return shape

func spawn_hitbox(_hitbox_upleft: Vector2, _hitbox_downright: Vector2):
	current_hitbox = saber_hitbox.instance()

	var collision_shape_node = current_hitbox.get_node("collisionShape2D")
	var deflection_shape_node = current_hitbox.get_node("area2D/collisionShape2D")
	if collision_shape_node == null:
		return
	else:
		current_hitbox.collision_shape = collision_shape_node
	if deflection_shape_node == null:
		return
	else:
		current_hitbox.deflection_shape = deflection_shape_node
	
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
	current_hitbox.deflection_shape.shape = hitbox_shape
	current_hitbox.position = hitbox_position
	
	add_child(current_hitbox)
		
	current_hitbox.damage = hitbox_damage * hitbox_extra_damage
	current_hitbox.damage_to_bosses = hitbox_damage_boss * hitbox_extra_damage_boss
	current_hitbox.damage_to_weakness = hitbox_damage_weakness * hitbox_extra_damage_weakness
	current_hitbox.break_guard_damage = hitbox_break_guard_value * hitbox_extra_break_guard_value
	current_hitbox.break_guards = hitbox_break_guards
	current_hitbox.saber_rehit = hitbox_rehit_time
	current_hitbox.upgraded = hitbox_upgraded
	current_hitbox.deflectable = deflectable
	current_hitbox.deflectable_type = deflectable_type
	current_hitbox.only_deflect_weak = only_deflect_weak

func hitbox_and_position() -> void :
	hitbox_damage = damage
	hitbox_damage_boss = damage_boss
	hitbox_damage_weakness = damage_weakness
	hitbox_break_guards = true

	if animatedSprite.frame >= loop_start_frame and animatedSprite.frame < loop_frame:
		if character.saber_node.current_weapon.name == "Saber":
			hitbox_rehit_time = 0.075
			if animatedSprite.frame >= 4 and animatedSprite.frame < 5 or animatedSprite.frame >= 8 and animatedSprite.frame < 11:
				hitbox_upleft = Vector2(0, - 58)
				hitbox_downright = Vector2(40, 18)
			else:
				hitbox_upleft = Vector2(0, - 58)
				hitbox_downright = Vector2( - 40, 18)

		elif character.saber_node.current_weapon.name == "B-Fan":
			hitbox_rehit_time = 0.075
			if animatedSprite.frame >= 4 and animatedSprite.frame < 5 or animatedSprite.frame >= 8 and animatedSprite.frame < 11:
				hitbox_upleft = Vector2(0, - 58)
				hitbox_downright = Vector2(40, 18)
			else:
				hitbox_upleft = Vector2(0, - 58)
				hitbox_downright = Vector2( - 40, 18)

		elif character.saber_node.current_weapon.name == "D-Glaive":
			hitbox_rehit_time = 0.0375
			hitbox_upleft = Vector2( - 100, - 70)
			hitbox_downright = Vector2(105, 0)

		elif character.saber_node.current_weapon.name == "K-Knuckle":
			hitbox_upleft = Vector2( - 20, - 40)
			hitbox_downright = Vector2(20, 20)

		elif character.saber_node.current_weapon.name == "T-Breaker":
			hitbox_rehit_time = 0.0375
			hitbox_upleft = Vector2( - 70, - 65)
			hitbox_downright = Vector2(75, - 20)

		else:
			if animatedSprite.frame >= 4 and animatedSprite.frame < 5 or animatedSprite.frame >= 8 and animatedSprite.frame < 11:
				hitbox_upleft = Vector2(0, - 58)
				hitbox_downright = Vector2(40, 18)
			else:
				hitbox_upleft = Vector2(0, - 58)
				hitbox_downright = Vector2( - 40, 18)
		spawn_hitbox(hitbox_upleft, hitbox_downright)
			
	reset_hitbox()

func end_saber_state() -> bool:
	if character.get_vertical_speed() > 0:
		return true
	return ending_saber_state

func movement_speed_frames() -> bool:
	return animatedSprite.frame >= loop_start_frame and animatedSprite.frame < loop_frame

func ice_emitting_position() -> void :
	if character.saber_node.current_weapon.name == "Saber":
		if animatedSprite.frame >= 4 and animatedSprite.frame < 5:
			particles.position = Vector2(25 * get_facing_direction(), - 24)
		elif animatedSprite.frame >= 5 and animatedSprite.frame < 6:
			particles.position = Vector2(16 * get_facing_direction(), - 29)
		elif animatedSprite.frame >= 6 and animatedSprite.frame < 7:
			particles.position = Vector2( - 19 * get_facing_direction(), - 29)
		elif animatedSprite.frame >= 7 and animatedSprite.frame < 8:
			particles.position = Vector2( - 25 * get_facing_direction(), - 24)
		elif animatedSprite.frame >= 8 and animatedSprite.frame < 9:
			particles.position = Vector2(16 * get_facing_direction(), - 29)
		elif animatedSprite.frame >= 9 and animatedSprite.frame < 11:
			particles.position = Vector2(25 * get_facing_direction(), - 24)

	elif character.saber_node.current_weapon.name == "B-Fan":
		if animatedSprite.frame >= 4 and animatedSprite.frame < 5:
			particles.position = Vector2(25 * get_facing_direction(), - 24)
		elif animatedSprite.frame >= 5 and animatedSprite.frame < 6:
			particles.position = Vector2(16 * get_facing_direction(), - 29)
		elif animatedSprite.frame >= 6 and animatedSprite.frame < 7:
			particles.position = Vector2( - 19 * get_facing_direction(), - 29)
		elif animatedSprite.frame >= 7 and animatedSprite.frame < 8:
			particles.position = Vector2( - 25 * get_facing_direction(), - 24)
		elif animatedSprite.frame >= 8 and animatedSprite.frame < 9:
			particles.position = Vector2(16 * get_facing_direction(), - 29)
		elif animatedSprite.frame >= 9 and animatedSprite.frame < 11:
			particles.position = Vector2(25 * get_facing_direction(), - 24)

	elif character.saber_node.current_weapon.name == "D-Glaive":
		if animatedSprite.frame >= 4 and animatedSprite.frame < 5:
			particles.position = Vector2(85 * get_facing_direction(), - 24)
		elif animatedSprite.frame >= 5 and animatedSprite.frame < 6:
			particles.position = Vector2(46 * get_facing_direction(), - 29)
		elif animatedSprite.frame >= 6 and animatedSprite.frame < 7:
			particles.position = Vector2( - 36 * get_facing_direction(), - 29)
		elif animatedSprite.frame >= 7 and animatedSprite.frame < 8:
			particles.position = Vector2( - 85 * get_facing_direction(), - 24)
		elif animatedSprite.frame >= 8 and animatedSprite.frame < 9:
			particles.position = Vector2(36 * get_facing_direction(), - 29)
		elif animatedSprite.frame >= 9 and animatedSprite.frame < 11:
			particles.position = Vector2(85 * get_facing_direction(), - 24)

	elif character.saber_node.current_weapon.name == "K-Knuckle":
		if animatedSprite.frame >= 4 and animatedSprite.frame < 5:
			particles.position = Vector2(15 * get_facing_direction(), - 24)
		elif animatedSprite.frame >= 5 and animatedSprite.frame < 6:
			particles.position = Vector2(6 * get_facing_direction(), - 29)
		elif animatedSprite.frame >= 6 and animatedSprite.frame < 7:
			particles.position = Vector2( - 9 * get_facing_direction(), - 29)
		elif animatedSprite.frame >= 7 and animatedSprite.frame < 8:
			particles.position = Vector2( - 15 * get_facing_direction(), - 24)
		elif animatedSprite.frame >= 8 and animatedSprite.frame < 9:
			particles.position = Vector2(6 * get_facing_direction(), - 29)
		elif animatedSprite.frame >= 9 and animatedSprite.frame < 11:
			particles.position = Vector2(15 * get_facing_direction(), - 24)

	elif character.saber_node.current_weapon.name == "T-Breaker":
		if animatedSprite.frame >= 4 and animatedSprite.frame < 5:
			particles.position = Vector2(45 * get_facing_direction(), - 24)
		elif animatedSprite.frame >= 5 and animatedSprite.frame < 6:
			particles.position = Vector2(6 * get_facing_direction(), - 29)
		elif animatedSprite.frame >= 6 and animatedSprite.frame < 7:
			particles.position = Vector2(4 * get_facing_direction(), - 29)
		elif animatedSprite.frame >= 7 and animatedSprite.frame < 8:
			particles.position = Vector2( - 45 * get_facing_direction(), - 24)
		elif animatedSprite.frame >= 8 and animatedSprite.frame < 9:
			particles.position = Vector2( - 4 * get_facing_direction(), - 29)
		elif animatedSprite.frame >= 9 and animatedSprite.frame < 11:
			particles.position = Vector2(45 * get_facing_direction(), - 24)

func jump_frame() -> void :
	if not jumped:
		if animatedSprite.frame >= loop_start_frame:
			particles.emitting = true
			particles.z_index = animatedSprite.z_index + 1
			character.set_vertical_speed( - jump_velocity)
			jumped = true

func loop_animation() -> void :
	if jumped:
		if character.get_vertical_speed() < 0:
			if animatedSprite.frame >= loop_frame:
				animatedSprite.frame = loop_start_frame
		else:
			particles.emitting = false
			if not descend:
				descend = true
				animatedSprite.frame = loop_frame + 1

func set_saber_animations() -> void :
	if character.is_on_floor():
		animatedSprite.animation = "hyouryuushou"
		animatedSprite.frame = 0
	else:
		animatedSprite.animation = "hyouryuushou_air"
		animatedSprite.frame = 0
	saber_sound.play()

func _StartCondition() -> bool:
	if not character.Hyouryuushou:
		return false
	if character.Hyouryuushou_used:
		return false
	if not character.get_action_pressed("move_up"):
		return false
	if character.combo_connection_hyouryuushou():
		return true
	var _animation = get_parent().get_animation()
	if _animation in character.saber_animations:
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
		if not "hyouryuushou" in _animation:
			return true
		if end_saber_state():
			return true
	else:
		return true
	return false

func _Setup() -> void :
	horizontal_speed = start_speed
	if character.is_on_floor():
		update_bonus_horizontal_only_conveyor()
	set_saber_animations()
	jumped = false
	descend = false
	character.Hyouryuushou_used = true
	character.dashjumps_since_jump = 0
	ending_saber_state = false

func _Update(delta: float) -> void :
	if jumped:
		process_gravity(delta)
	jump_frame()
	ice_emitting_position()
	loop_animation()
	hitbox_and_position()
	if movement_speed_frames():
		force_movement(horizontal_speed)
	else:
		if character.is_on_floor():
			force_movement(0)

func change_animation_if_falling(_s) -> void :
	animatedSprite.animation = "fall"

func _Interrupt() -> void :

	jumped = false
	descend = false
	particles.emitting = false
	if character.is_on_floor():
		animatedSprite.animation = "recover"
	else:
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
