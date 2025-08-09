extends FallZero
class_name SaberEnkoukyakuX8

export  var saber_hitbox: Resource = preload("res://Zero_mod/X8/Player/Hitboxes/Enkoukyaku_Hitbox.tscn")
export  var fire_hitbox: Resource = preload("res://Zero_mod/Player/Hitboxes/Enkoujin_Hitbox.tscn")

onready var animatedSprite = character.get_node("animatedSprite")
onready var saber_sound = get_node("saber")
onready var double_jump: = get_parent().get_node("AirJump")

var current_hitbox = null
var hitbox_name: String = "Enkoujin_Charged_B"
var hitbox_upleft = Vector2(0, 0)
var hitbox_downright = Vector2(0, 0)
var hitbox_damage = 0
var hitbox_damage_boss = 0
var hitbox_damage_weakness = 0
var hitbox_break_guard_value = 0.4
var hitbox_break_guards: bool = true
var hitbox_rehit_time = 0.05
var hitbox_upgraded: bool = false
var hitbox_extra_damage = 1
var hitbox_extra_damage_boss = 1
var hitbox_extra_damage_weakness = 1
var hitbox_extra_break_guard_value = 1
var deflectable: bool = true
var deflectable_type: int = 0
var only_deflect_weak: bool = false

var ending_saber_state: bool = false
var landed: bool = false
var cancel_time: float = 0.3
var hitbox_timer: float = 0.0
var hitbox_time: float = 0.05
var emitted_effect: bool = false
var landing_frame: int = 15
var loop_frame: int = 6
var loop_start_frame: int = 3


func _ready() -> void :
	Event.connect("hit_enkoukyaku", self, "hit_enemy")
	animatedSprite.connect("animation_finished", self, "_on_animation_finished")

func _on_animation_finished() -> void :
	ending_saber_state = true

func hit_enemy() -> void :
	force_movement( - horizontal_velocity * 0.75)
	character.set_vertical_speed( - jump_velocity * 0.75)
	animatedSprite.frame = 8
	landed = true
	character.Rasetsusen_used = false
	character.Hyouryuushou_used = false
	character.add_invulnerability("Enkoukyaku")
	if double_jump.current_air_jumps < double_jump.max_air_jumps:
		double_jump.current_air_jumps += 1

func reset_hitbox() -> void :
	hitbox_upleft = Vector2(0, 0)
	hitbox_downright = Vector2(0, 0)

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

func spawn_fire(_hitbox_upleft: Vector2, _hitbox_downright: Vector2) -> void :
	current_hitbox = fire_hitbox.instance()
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
	current_hitbox.deflectable_type = deflectable_type
	current_hitbox.only_deflect_weak = only_deflect_weak

func hitbox_and_position() -> void :
	hitbox_damage = 15
	hitbox_damage_boss = 8
	hitbox_damage_weakness = 24
	if animatedSprite.animation == "enkoujin":
		if animatedSprite.frame >= loop_start_frame and animatedSprite.frame <= loop_frame:
			hitbox_upleft = Vector2( - 10, - 18)
			hitbox_downright = Vector2(33, 30)
			
			spawn_hitbox(hitbox_upleft, hitbox_downright)
	reset_hitbox()
	
func fire_position() -> void :
	hitbox_damage = 10
	hitbox_damage_boss = 4
	hitbox_damage_weakness = 24
	if animatedSprite.animation == "enkoujin":
		if animatedSprite.frame >= loop_start_frame and animatedSprite.frame <= loop_frame:
			hitbox_upleft = Vector2(1, - 60)
			hitbox_downright = Vector2(33, - 17)
			spawn_fire(hitbox_upleft, hitbox_downright)
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
	effect.modulate = Color(1, 1, 1, 0.65)
	
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
	return ending_saber_state or character.is_on_floor()

func repeat_animation() -> void :
	if animatedSprite.frame > loop_frame:
		animatedSprite.frame = loop_start_frame

func set_saber_animations() -> void :
	if not character.is_on_floor():
		animatedSprite.animation = "enkoujin"
		animatedSprite.frame = 0
	saber_sound.play()

func _StartCondition() -> bool:
	if not character.Enkoukyaku:
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
	if not landed:
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
	emitted_effect = false
	set_saber_animations()
	character.set_horizontal_speed(0)
	character.set_vertical_speed(0)
	character.dashjumps_since_jump = 0
	Event.connect("hit_shield", self, "hit_enemy")
	ending_saber_state = false

func _Update(delta: float) -> void :
	if animatedSprite.frame >= loop_start_frame and not emitted_effect:
		effect_emit("enkoukyaku")
		emitted_effect = true
		
	if timer < cancel_time:
		timer += delta
	hitbox_time = 0.05
	if hitbox_timer < hitbox_time:
		hitbox_timer += delta
	else:
		hitbox_timer = 0
		fire_position()
		
	if not landed:
		if is_instance_valid(effect):
			effect.global_position = global_position + Vector2(0, 5)
			effect.rotation_degrees = animatedSprite.rotation_degrees
			
		hitbox_and_position()
		force_movement(0)
		repeat_animation()
		if should_go_down():
			force_movement(horizontal_velocity)
			character.set_vertical_speed(jump_velocity)
			


	else:
		if is_instance_valid(effect):
			effect.queue_free()
			effect = null
		process_gravity(delta)
		force_movement( - horizontal_velocity * 0.75)
		update_bonus_horizontal_only_conveyor()

func change_animation_if_falling(_s) -> void :
	pass

func _Interrupt() -> void :
	animatedSprite.animation = "fall"
	if is_instance_valid(current_hitbox):
		current_hitbox.queue_free()
	if is_instance_valid(effect):
		effect.queue_free()
		effect = null
	Event.disconnect("hit_shield", self, "hit_enemy")
	character.remove_invulnerability("Enkoukyaku")

func BeforeEveryFrame(_delta: float) -> void :
	pass
