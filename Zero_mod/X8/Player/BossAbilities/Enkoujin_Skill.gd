extends FallZero
class_name SaberEnkoujinX8

export  var saber_hitbox: Resource = preload("res://Zero_mod/Player/Hitboxes/Enkoujin_Hitbox.tscn")

onready var animatedSprite: = character.get_node("animatedSprite")
onready var saber_sound: = get_node("saber")

var current_hitbox = null
var hitbox_name: String = "Enkoujin"
var hitbox_upward_movement: int = 100
var hitbox_upleft = Vector2(0, 0)
var hitbox_downright = Vector2(0, 0)
var hitbox_damage: float = 0
var hitbox_damage_boss: float = 0
var hitbox_damage_weakness: float = 0
var hitbox_break_guard_value: float = 0.4
var hitbox_break_guards: bool = false
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
var landed: bool = false
var cancel_time: float = 0.3
var hitbox_timer: float = 0.0
var hitbox_time: float = 0.05
var landing_frame: int = 9
var loop_frame: int = 8
var loop_start_frame: int = 4


func _ready() -> void :
	animatedSprite.connect("animation_finished", self, "_on_animation_finished")

func _on_animation_finished() -> void :
	ending_saber_state = true

func reset_hitbox() -> void :
	hitbox_upleft = Vector2(0, 0)
	hitbox_downright = Vector2(0, 0)

func spawn_hitbox(_hitbox_upleft: Vector2, _hitbox_downright: Vector2) -> void :
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
	current_hitbox.z_index = character.z_index + 6
	current_hitbox.modulate = Color(1, 1, 1, 0.5)
	current_hitbox.animatedSprite.scale = Vector2(0.75, 0.75)
	current_hitbox.upward_movement = hitbox_upward_movement

	current_hitbox.name = hitbox_name
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
	hitbox_damage = 10
	hitbox_damage_boss = 4
	hitbox_damage_weakness = 30
	if animatedSprite.animation == "enkoujin":
		if character.saber_node.current_weapon.name == "Saber":
			if animatedSprite.frame >= 4 and animatedSprite.frame < 14:
				hitbox_upleft = Vector2( - 2, - 33)
				hitbox_downright = Vector2(30, 20)
				spawn_hitbox(hitbox_upleft, hitbox_downright)

		elif character.saber_node.current_weapon.name == "B-Fan":
			if animatedSprite.frame >= 4 and animatedSprite.frame < 14:
				hitbox_upleft = Vector2( - 2, - 23)
				hitbox_downright = Vector2(30, 30)
				spawn_hitbox(hitbox_upleft, hitbox_downright)

		elif character.saber_node.current_weapon.name == "D-Glaive":
			if animatedSprite.frame >= 4 and animatedSprite.frame < 14:
				hitbox_upleft = Vector2( - 2, 37)
				hitbox_downright = Vector2(30, 90)
				spawn_hitbox(hitbox_upleft, hitbox_downright)

		elif character.saber_node.current_weapon.name == "K-Knuckle":
			if animatedSprite.frame >= 4 and animatedSprite.frame < 14:
				hitbox_upleft = Vector2(1, - 33)
				hitbox_downright = Vector2(33, 20)
				spawn_hitbox(hitbox_upleft, hitbox_downright)

		elif character.saber_node.current_weapon.name == "T-Breaker":
			if animatedSprite.frame >= 4 and animatedSprite.frame < 14:
				hitbox_upleft = Vector2( - 2, - 13)
				hitbox_downright = Vector2(30, 40)
				spawn_hitbox(hitbox_upleft, hitbox_downright)
	reset_hitbox()

var effect: AnimatedSprite
var effect_transparency: float = 0.5
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

func should_go_down() -> bool:
	return animatedSprite.frame >= loop_start_frame

func end_saber_state() -> bool:
	if character.is_on_floor():
		return ending_saber_state
	return false

func repeat_animation() -> void :
	if animatedSprite.frame >= loop_frame:
		animatedSprite.frame = loop_start_frame

func set_saber_animations() -> void :
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
		if _animation == "saber_jump":
			return false
		if _animation == "saber_jump_1":
			return false
		if _animation == "saber_jump_2":
			return false
		if _animation == "tenshouha":
			return false
		if _animation == "juuhazan":
			return false
		if _animation == "rasetsusen":
			return false
		if _animation == "raikousen":
			return false
		if _animation == "youdantotsu":
			return false
		if _animation == "hyouryuushou":
			return false
		if _animation == "hyouryuushou_air":
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
	if character.saber_node.current_weapon.name == "D-Glaive":
		effect_emit("enkoujin_glaive")

	landed = false
	set_saber_animations()
	character.set_horizontal_speed(0)
	character.set_vertical_speed(0)
	character.dashjumps_since_jump = 0
	ending_saber_state = false

func _Update(delta: float) -> void :
	if is_instance_valid(effect):
		effect.frame = animatedSprite.frame
		effect.global_position = global_position
		effect.rotation_degrees = animatedSprite.rotation_degrees

	if timer < cancel_time:
		timer += delta
	hitbox_time = 0.05
	if hitbox_timer < hitbox_time:
		hitbox_timer += delta
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
		process_gravity(delta)
		force_movement(0)
		update_bonus_horizontal_only_conveyor()

func change_animation_if_falling(_s) -> void :
	pass

func _Interrupt() -> void :
	if not character.is_on_floor():
		animatedSprite.animation = "fall"
	if is_instance_valid(current_hitbox):
		current_hitbox.queue_free()
	if is_instance_valid(effect):
		effect.queue_free()
		effect = null

func BeforeEveryFrame(_delta: float) -> void :
	pass
