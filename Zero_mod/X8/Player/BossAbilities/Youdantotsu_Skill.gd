extends Movement
class_name SaberYoudantotsuX8

export  var upgraded: bool = true
export  var damage: float = 4
export  var damage_boss: float = 4
export  var damage_weakness: float = 24
export  var saber_hitbox: Resource = preload("res://Zero_mod/Player/Hitboxes/Youdantotsu_Hitbox.tscn")

onready var animatedSprite: = character.get_node("animatedSprite")
onready var saber_sound: AudioStreamPlayer = $saber

var current_hitbox = null
var hitbox_name: String = "Youdantotsu"
var hitbox_upleft_corner: Vector2 = Vector2( - 120, - 15)
var hitbox_downright_corner: Vector2 = Vector2(100, 5)
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

var ending_saber_state: bool = false
var movement_frame: int = 5
var start_speed: int = 500
var horizontal_speed: float = start_speed
var damping: float = 0.95
var previous_frame: float = - 1
var sound_counter: int = 0
var STRIKE_FRAMES: Array = [10, 16, 22, 28, 34, 40]
var MOVE_RANGES: Array = [
	Vector2(3, 9), 
	Vector2(10, 14), 
	Vector2(16, 20), 
	Vector2(22, 26), 
	Vector2(28, 32), 
	Vector2(34, 38), 
	Vector2(40, 44)
]


func _ready() -> void :
	Event.connect("saber_has_hit_boss", self, "reduce_speed")
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
	hitbox_break_guards = true
	
func set_hitbox_corners(upleft: Vector2, downright: Vector2) -> RectangleShape2D:
	var shape = RectangleShape2D.new()
	var size = downright - upleft
	shape.extents = size / 2
	return shape
	
func spawn_hitbox(_hitbox_upleft: Vector2, _hitbox_downright: Vector2) -> void :
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
	current_hitbox.name = hitbox_name
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
	if animatedSprite.animation == "youdantotsu":
		hitbox_damage = damage
		hitbox_damage_boss = damage_boss
		hitbox_damage_weakness = damage_weakness
		hitbox_break_guards = true
		
		if character.saber_node.current_weapon.name == "Saber":
			if animatedSprite.frame >= movement_frame and animatedSprite.frame < movement_frame + 7:
				hitbox_upleft = hitbox_upleft_corner
				hitbox_downright = hitbox_downright_corner
				spawn_hitbox(hitbox_upleft, hitbox_downright)

		elif character.saber_node.current_weapon.name == "B-Fan":
			if animatedSprite.frame >= movement_frame and animatedSprite.frame < movement_frame + 7:
				hitbox_upleft = hitbox_upleft_corner
				hitbox_downright = hitbox_downright_corner
				spawn_hitbox(hitbox_upleft, hitbox_downright)

		elif character.saber_node.current_weapon.name == "D-Glaive":
			var strike_1 = animatedSprite.frame >= 10 and animatedSprite.frame < 14
			var strike_2 = animatedSprite.frame >= 16 and animatedSprite.frame < 20
			var strike_3 = animatedSprite.frame >= 22 and animatedSprite.frame < 26
			var strike_4 = animatedSprite.frame >= 28 and animatedSprite.frame < 32
			var strike_5 = animatedSprite.frame >= 34 and animatedSprite.frame < 38
			var strike_6 = animatedSprite.frame >= 40 and animatedSprite.frame < 44
			if strike_1 or strike_4:
				hitbox_upleft = Vector2(55, - 30)
				hitbox_downright = Vector2(155, 12)
				spawn_hitbox(hitbox_upleft, hitbox_downright)
			elif strike_2 or strike_5:
				hitbox_upleft = Vector2(55, - 50)
				hitbox_downright = Vector2(155, - 8)
				spawn_hitbox(hitbox_upleft, hitbox_downright)
			elif strike_3 or strike_6:
				hitbox_upleft = Vector2(55, - 10)
				hitbox_downright = Vector2(155, 32)
				spawn_hitbox(hitbox_upleft, hitbox_downright)

		elif character.saber_node.current_weapon.name == "K-Knuckle":
			if animatedSprite.frame >= movement_frame and animatedSprite.frame < movement_frame + 7:
				hitbox_upleft = hitbox_upleft_corner
				hitbox_downright = hitbox_downright_corner
				spawn_hitbox(hitbox_upleft, hitbox_downright)

		elif character.saber_node.current_weapon.name == "T-Breaker":
			if animatedSprite.frame >= movement_frame and animatedSprite.frame < movement_frame + 7:
				hitbox_upleft = hitbox_upleft_corner
				hitbox_downright = hitbox_downright_corner
				spawn_hitbox(hitbox_upleft, hitbox_downright)
			
	reset_hitbox()

var effect: AnimatedSprite
var effect_transparency: float = 0.75
func effect_emit(_animation) -> void :
	effect = AnimatedSprite.new()
	add_child(effect)
	effect.frames = character.ability_animation
	effect.animation = _animation
	effect.frame = animatedSprite.frame
	effect.playing = true
	effect.global_position = global_position
	effect.modulate = Color(1, 1, 1, effect_transparency)
	effect.scale = animatedSprite.scale
	effect.z_index = animatedSprite.z_index + 1
	effect.centered = animatedSprite.centered
	effect.offset.y = animatedSprite.offset.y - 3
	effect.flip_h = animatedSprite.flip_h
	effect.flip_v = animatedSprite.flip_v
	effect.rotation_degrees = animatedSprite.rotation_degrees

func end_saber_state() -> bool:
	return ending_saber_state

func movement_speed_frames() -> bool:
	if character.saber_node.current_weapon.name == "D-Glaive":
		var current_frame = animatedSprite.frame
		if current_frame != previous_frame:
			play_strike_sound(current_frame)
		previous_frame = current_frame
		return is_in_move_range(animatedSprite.frame)
	return animatedSprite.frame >= movement_frame and animatedSprite.frame < movement_frame + 7

func is_in_move_range(frame: int) -> bool:
	for movement in MOVE_RANGES:
		if frame >= movement.x and frame < movement.y:
			return true
	return false

func play_strike_sound(frame: int) -> void :
	if sound_counter < STRIKE_FRAMES.size():
		if frame >= STRIKE_FRAMES[sound_counter]:
			saber_sound.play()
			sound_counter += 1

func set_saber_animations() -> void :
	animatedSprite.animation = "youdantotsu"
	if character.saber_node.current_weapon.name != "D-Glaive":
		saber_sound.play()

func _StartCondition() -> bool:
	if not character.Youdantotsu:
		return false
	if character.get_action_pressed("move_up") or character.get_action_pressed("move_down"):
		return false
	if not character.get_action_pressed("move_left") and not character.get_action_pressed("move_right"):
		return false
	if get_action_pressed("dash"):
		return false
	if character.combo_connection_youdantotsu():
		return true
	var _animation = get_parent().get_animation()
	if _animation in character.saber_animations:
		return false
	if not executing:
		if character.is_on_floor():
			return true
	return false
	
func _ResetCondition() -> bool:
	return false

func _EndCondition() -> bool:
	var _animation = get_parent().get_animation()
	if _animation in character.saber_animations:
		if not _animation == "youdantotsu":
			return true
		if end_saber_state():
			return true
	else:
		return true
	return false

func _Setup() -> void :
	if character.saber_node.current_weapon.name == "Saber":
		effect_emit("youdantotsu")

	elif character.saber_node.current_weapon.name == "B-Fan":
		effect_emit("youdantotsu_fan")

	elif character.saber_node.current_weapon.name == "D-Glaive":
		sound_counter = 0
		effect_emit("renyoudan")

	elif character.saber_node.current_weapon.name == "K-Knuckle":
		effect_emit("youdantotsu_knuckle")

	elif character.saber_node.current_weapon.name == "T-Breaker":
		effect_emit("youdantotsu_breaker")

	horizontal_speed = start_speed
	update_bonus_horizontal_only_conveyor()
	set_saber_animations()
	ending_saber_state = false

func reduce_speed() -> void :
	horizontal_speed = 0

func damp_horizontal_speed(_delta: float) -> void :
	var reference_delta = 1.0 / 120
	var damping_factor = pow(damping, _delta / reference_delta)
	horizontal_speed *= damping_factor

func _Update(_delta: float) -> void :
	if is_instance_valid(effect):
		effect.frame = animatedSprite.frame
		effect.global_position = global_position
		effect.rotation_degrees = animatedSprite.rotation_degrees

	hitbox_and_position()
	if movement_speed_frames():
		horizontal_velocity = horizontal_speed
		force_movement(horizontal_speed)
		damp_horizontal_speed(_delta)
	else:
		force_movement(0)
	character.set_vertical_speed(0)
	update_bonus_horizontal_only_conveyor()

func change_animation_if_falling(_s) -> void :
	pass

func _Interrupt() -> void :
	._Interrupt()
	if character.is_on_floor():
		animatedSprite.animation = "recover"
	else:
		animatedSprite.animation = "fall"
	if is_instance_valid(current_hitbox):
		current_hitbox.queue_free()
	if is_instance_valid(effect):
		effect.queue_free()
		effect = null
