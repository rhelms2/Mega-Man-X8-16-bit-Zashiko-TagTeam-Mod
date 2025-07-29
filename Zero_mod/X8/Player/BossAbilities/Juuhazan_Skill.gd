extends Movement
class_name SaberJuuhazanX8

export  var upgraded: bool = true
export  var damage: float = 12
export  var damage_boss: float = 4
export  var damage_weakness: float = 20
export  var saber_hitbox: Resource = preload("res://Zero_mod/Player/Hitboxes/Juuhazan_Hitbox.tscn")

onready var animatedSprite: = character.get_node("animatedSprite")
onready var saber_sound: AudioStreamPlayer = $saber
onready var ganzanha_sound: AudioStreamPlayer = $ganzanha
onready var dairettsui_sound: AudioStreamPlayer = $dairettsui

var current_hitbox = null
var hitbox_name: String = "Juuhazan"
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
var start_speed: int = 320
var horizontal_speed: float = start_speed
var movement_frame_start: int = 5
var movement_frame_end: int = 13
var damping: float = 0.95
var gravity: bool = true

onready var effect_scene = preload("res://System/misc/visual_effect.tscn")
var effect_instance = null
var effect_spawn_position: Vector2 = Vector2(0, 0)
var effect_spawn_timer: float = 0.0
var effect_spawn_time: float = 0.02
var effect_emitted: bool = false
var effect_only_frame: int = 5


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
	hitbox_damage = damage
	hitbox_damage_boss = damage_boss
	hitbox_damage_weakness = damage_weakness
	hitbox_break_guards = true

	if character.saber_node.current_weapon.name == "Saber":
		if animatedSprite.frame >= 5 and animatedSprite.frame < 10:
			if animatedSprite.frame >= 5 and animatedSprite.frame < 6:
				hitbox_upleft = Vector2( - 65, - 59)
				hitbox_downright = Vector2(7, 15)
			if animatedSprite.frame >= 6 and animatedSprite.frame < 7:
				hitbox_upleft = Vector2( - 55, - 79)
				hitbox_downright = Vector2(67, - 20)
			if animatedSprite.frame >= 7 and animatedSprite.frame < 10:
				hitbox_upleft = Vector2( - 5, - 79)
				hitbox_downright = Vector2(87, 30)
			spawn_hitbox(hitbox_upleft, hitbox_downright)

	elif character.saber_node.current_weapon.name == "B-Fan":
		if animatedSprite.frame >= 5 and animatedSprite.frame < 10:
			if animatedSprite.frame >= 5 and animatedSprite.frame < 6:
				hitbox_upleft = Vector2( - 65, - 59)
				hitbox_downright = Vector2(7, 15)
			if animatedSprite.frame >= 6 and animatedSprite.frame < 7:
				hitbox_upleft = Vector2( - 55, - 79)
				hitbox_downright = Vector2(67, - 20)
			if animatedSprite.frame >= 7 and animatedSprite.frame < 10:
				hitbox_upleft = Vector2( - 5, - 79)
				hitbox_downright = Vector2(87, 30)
			spawn_hitbox(hitbox_upleft, hitbox_downright)

	elif character.saber_node.current_weapon.name == "D-Glaive":
		if animatedSprite.frame >= 5 and animatedSprite.frame < 10:
			if animatedSprite.frame >= 5 and animatedSprite.frame < 6:
				hitbox_upleft = Vector2( - 113, - 103)
				hitbox_downright = Vector2( - 53, 15)
			if animatedSprite.frame >= 6 and animatedSprite.frame < 7:
				hitbox_upleft = Vector2( - 55, - 125)
				hitbox_downright = Vector2(80, - 50)
			if animatedSprite.frame >= 7 and animatedSprite.frame < 10:
				hitbox_upleft = Vector2(65, - 79)
				hitbox_downright = Vector2(135, 45)
			spawn_hitbox(hitbox_upleft, hitbox_downright)

	elif character.saber_node.current_weapon.name == "K-Knuckle":
		if animatedSprite.frame >= effect_only_frame and animatedSprite.frame < 9:
			hitbox_upleft = Vector2(20, - 30)
			hitbox_downright = Vector2(70, 22)
			spawn_hitbox(hitbox_upleft, hitbox_downright)
			if animatedSprite.frame < 7:
				Event.emit_signal("screenshake", 0.2)

	elif character.saber_node.current_weapon.name == "T-Breaker":
		if animatedSprite.frame >= effect_only_frame and animatedSprite.frame < 12:
			hitbox_upleft = Vector2(15, - 50)
			hitbox_downright = Vector2(83, 42)
			spawn_hitbox(hitbox_upleft, hitbox_downright)
			if animatedSprite.frame < 9:
				Event.emit_signal("screenshake", 1.0)

	reset_hitbox()

var effect: AnimatedSprite
func effect_emit(_animation) -> void :
	effect = AnimatedSprite.new()
	add_child(effect)
	effect.frames = character.ability_animation
	effect.animation = _animation
	effect.frame = animatedSprite.frame
	effect.playing = true
	effect.global_position = global_position
	effect.modulate = Color(1, 1, 1, 1)
	effect.scale = animatedSprite.scale
	effect.z_index = animatedSprite.z_index + 1
	effect.centered = animatedSprite.centered
	effect.offset.y = animatedSprite.offset.y - 3
	effect.flip_h = animatedSprite.flip_h
	effect.flip_v = animatedSprite.flip_v
	effect.rotation_degrees = animatedSprite.rotation_degrees

func effect_only_emit(_delta: float, _animation: String) -> void :
	if animatedSprite.frame >= effect_only_frame and not effect_emitted:
		if gravity:
			character.set_vertical_speed( - jump_velocity)
		effect_emitted = true
		effect_position()
		effect_instance = effect_scene.instance()
		effect_instance.frames = load("res://Zero_mod/X8/Sprites/BossAbilities/ability_effects.tres")
		effect_instance.animation = _animation
		effect_instance.global_position = effect_spawn_position
		effect_instance.z_index = animatedSprite.z_index + 2
		if get_facing_direction() > 0:
			effect_instance.flip_h = false
		else:
			effect_instance.flip_h = true
		effect_instance.modulate = Color(1, 1, 1, 0.75)
		get_tree().current_scene.add_child(effect_instance)

func effect_position() -> void :
	if character.saber_node.current_weapon.name == "K-Knuckle":
		var offset_x = 40
		var offset_y = - 8
		effect_spawn_position = Vector2(global_position.x + offset_x * get_facing_direction(), global_position.y + offset_y)
	if character.saber_node.current_weapon.name == "T-Breaker":
		var offset_x = 40
		var offset_y = 12
		effect_spawn_position = Vector2(global_position.x + offset_x * get_facing_direction(), global_position.y + offset_y)

func end_saber_state() -> bool:
	return ending_saber_state

func movement_speed_frames() -> bool:
	return animatedSprite.frame >= movement_frame_start and animatedSprite.frame < movement_frame_end

func set_saber_animations() -> void :
	animatedSprite.animation = "juuhazan"

func _StartCondition() -> bool:
	if not character.Juuhazan:
		return false
	if character.get_action_pressed("move_left") or character.get_action_pressed("move_right") or character.get_action_pressed("move_up") or character.get_action_pressed("move_down"):
		return false
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
		if not _animation == "juuhazan":
			return true
		if end_saber_state():
			return true
	else:
		return true
	return false

func _Setup() -> void :
	if character.saber_node.current_weapon.name == "Saber":
		saber_sound.play()
		gravity = false
		effect_emit("juuhazan")

	elif character.saber_node.current_weapon.name == "B-Fan":
		saber_sound.play()
		gravity = false
		effect_emit("juuhazan")

	elif character.saber_node.current_weapon.name == "D-Glaive":
		saber_sound.play()
		gravity = false
		effect_emit("juuhazan_glaive")

	elif character.saber_node.current_weapon.name == "K-Knuckle":
		effect_emitted = false
		gravity = false
		ganzanha_sound.play()

	elif character.saber_node.current_weapon.name == "T-Breaker":
		effect_emitted = false
		gravity = true
		dairettsui_sound.play()

	animatedSprite.frame = 1
	horizontal_speed = start_speed
	update_bonus_horizontal_only_conveyor()
	set_saber_animations()
	ending_saber_state = false

func reduce_speed() -> void :
	horizontal_speed = 0

func damp_horizontal_speed(delta: float) -> void :
	var reference_delta = 1.0 / 120
	var damping_factor = pow(damping, delta / reference_delta)
	horizontal_speed *= damping_factor

func _Update(delta: float) -> void :
	if character.saber_node.current_weapon.name == "K-Knuckle":
		effect_only_emit(delta, "ganzanha")
	if character.saber_node.current_weapon.name == "T-Breaker":
		effect_only_emit(delta, "dairettsui")
	if is_instance_valid(effect_instance):
		effect_position()
		effect_instance.global_position = effect_spawn_position

	if is_instance_valid(effect):
		effect.frame = animatedSprite.frame
		effect.global_position = global_position
	hitbox_and_position()
	if movement_speed_frames():
		horizontal_velocity = horizontal_speed
		force_movement(horizontal_speed)
		damp_horizontal_speed(delta)
	else:
		force_movement(0)
	

	if gravity:
		process_gravity(delta)
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
