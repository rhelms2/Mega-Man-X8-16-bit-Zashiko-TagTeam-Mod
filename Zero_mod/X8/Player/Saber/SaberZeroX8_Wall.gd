extends WallSlideZero
class_name SaberZeroX8Wall

export  var saber_hitbox: PackedScene = preload("res://Zero_mod/Player/Hitboxes/Saber_Hitbox.tscn")
export  var upgraded: = false
export  var damage: float = 4.0
export  var damage_boss: float = 4.0
export  var damage_weakness: float = 24.0
export  var hitbox_break_guards: bool = false

onready var animatedSprite = character.get_node("animatedSprite")
onready var saber_sound: AudioStreamPlayer = $saber
onready var breaker_sound: AudioStreamPlayer = $breaker

var current_hitbox = null
var hitbox_upleft: Vector2 = Vector2(0, 0)
var hitbox_downright: Vector2 = Vector2(0, 0)
var hitbox_damage: float = 0
var hitbox_damage_boss: float = 0
var hitbox_damage_weakness: float = 0
var hitbox_break_guard_value: float = 0.25
var hitbox_rehit_time: float = 0.05
var hitbox_upgraded: bool = false
var hitbox_extra_damage: float = 1
var hitbox_extra_damage_boss: float = 1
var hitbox_extra_damage_weakness: float = 1
var hitbox_extra_break_guard_value: float = 1
var deflectable: bool = false
var deflectable_type: int = 0
var only_deflect_weak: bool = false

var ending_saber_state: bool = false
var slashing: bool = false
var slashes = 0
var vertical_last = 0


func _ready() -> void :
	animatedSprite.connect("animation_finished", self, "_on_animation_finished")

func _on_animation_finished() -> void :
	ending_saber_state = true

func reset_hitbox():
	hitbox_upleft = Vector2(0, 0)
	hitbox_downright = Vector2(0, 0)

func set_hitbox_corners(upleft: Vector2, downright: Vector2):
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

func hitbox_and_position():
	if character.saber_node.current_weapon.name == "Saber":
		hitbox_damage = damage
		hitbox_damage_boss = damage_boss
		hitbox_damage_weakness = damage_weakness
		hitbox_break_guard_value = 0.25
		hitbox_break_guards = false
		if animatedSprite.frame >= 2 and animatedSprite.frame < 4:
			hitbox_upleft = Vector2(0, - 40)
			hitbox_downright = Vector2(61, 17)
			spawn_hitbox(hitbox_upleft, hitbox_downright)

	if character.saber_node.current_weapon.name == "B-Fan":
		hitbox_damage = damage
		hitbox_damage_boss = damage_boss
		hitbox_damage_weakness = damage_weakness
		hitbox_break_guard_value = 0.25
		hitbox_break_guards = false
		if animatedSprite.frame >= 2 and animatedSprite.frame < 4:
			hitbox_upleft = Vector2(0, - 40)
			hitbox_downright = Vector2(71, 40)
			spawn_hitbox(hitbox_upleft, hitbox_downright)

	elif character.saber_node.current_weapon.name == "D-Glaive":
		hitbox_damage = damage
		hitbox_damage_boss = damage_boss
		hitbox_damage_weakness = damage_weakness
		hitbox_rehit_time = 0.025
		hitbox_break_guards = false
		if animatedSprite.frame >= 2 and animatedSprite.frame < 3:
			hitbox_upleft = Vector2( - 62, - 80)
			hitbox_downright = Vector2(100, - 60)
			spawn_hitbox(hitbox_upleft, hitbox_downright)
			hitbox_upleft = Vector2(29, - 60)
			hitbox_downright = Vector2(115, - 30)
			spawn_hitbox(hitbox_upleft, hitbox_downright)
		elif animatedSprite.frame >= 3 and animatedSprite.frame < 4:
			hitbox_upleft = Vector2(59, - 30)
			hitbox_downright = Vector2(112, 20)
			spawn_hitbox(hitbox_upleft, hitbox_downright)
			hitbox_upleft = Vector2(59, 20)
			hitbox_downright = Vector2(112, 40)
			spawn_hitbox(hitbox_upleft, hitbox_downright)

	elif character.saber_node.current_weapon.name == "T-Breaker":
		hitbox_damage = damage
		hitbox_damage_boss = damage_boss
		hitbox_damage_weakness = damage_weakness
		hitbox_break_guard_value = 0.25
		hitbox_break_guards = true
		if animatedSprite.frame >= 2 and animatedSprite.frame < 3:
			hitbox_upleft = Vector2( - 5, - 68)
			hitbox_downright = Vector2(75, 0)
			spawn_hitbox(hitbox_upleft, hitbox_downright)
		elif animatedSprite.frame >= 3 and animatedSprite.frame < 4:
			hitbox_upleft = Vector2(18, - 48)
			hitbox_downright = Vector2(70, 50)
			spawn_hitbox(hitbox_upleft, hitbox_downright)

	reset_hitbox()

func end_saber_state():
	return ending_saber_state

func should_add_saber_combo():
	return animatedSprite.frame >= animatedSprite.frames.get_frame_count("saber_slide") - 3

func set_saber_animations():
	animatedSprite.animation = "saber_slide"
	animatedSprite.frame = 0
	if character.saber_node.current_weapon.name == "T-Breaker":
		breaker_sound.play()
	else:
		saber_sound.play()

func _StartCondition() -> bool:
	var _animation = get_parent().get_animation()
	for _ani in character.saber_animations:
		if "saber_jump" in _animation or _animation == "saber_dash":
			return false
	if _animation == "walljump":
		return false
	if get_action_just_pressed(actions[0]) and character.is_executing("WallSlide"):
		return true
	return false

func _ResetCondition() -> bool:
	return false

func _EndCondition() -> bool:
	var _animation = get_parent().get_animation()
	if _animation in character.saber_animations:
		if end_saber_state():
			return true
		if character.is_on_floor():
			return true
		if not character.is_in_reach_for_walljump():
			return true
		if get_pressed_direction() != character.is_in_reach_for_walljump():
			return true
		if get_pressed_direction() == 0:
			return true
	else:
		return true
	return false

func _Setup() -> void :
	character.velocity.y = vertical_last
	set_saber_animations()
	ending_saber_state = false

func _Update(_delta: float) -> void :
	hitbox_and_position()
	if should_add_saber_combo():
		if character.get_action_just_pressed("fire"):
			set_saber_animations()

	character.set_horizontal_speed(horizontal_speed * wallgrab_direction)
	if delay_has_expired():
		emit_particles(particles, true)
		character.set_vertical_speed(jump_velocity)

func change_animation_if_falling(_s) -> void :
	animatedSprite.animation = "fall"

func _Interrupt() -> void :
	slashes = 0
	if is_instance_valid(current_hitbox):
		current_hitbox.queue_free()
	if character.get_vertical_speed() > 0:
		character.set_vertical_speed(40)
	character.set_horizontal_speed(0)
	emit_particles(particles, false)
	animatedSprite.animation = "slide"
	animatedSprite.frame = 3

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
