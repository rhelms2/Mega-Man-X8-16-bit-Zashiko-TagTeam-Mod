extends Movement
class_name SaberJuuhazan

export  var saber_hitbox: Resource = preload("res://Zero_mod/Player/Hitboxes/Juuhazan_Hitbox.tscn")
var current_hitbox = null
var hitbox_upleft = Vector2(0, 0)
var hitbox_downright = Vector2(0, 0)
var hitbox_damage = 0
var hitbox_damage_boss = 0
var hitbox_damage_weakness = 0
var hitbox_break_guard_value = 0.25
var hitbox_break_guards: bool = true
var hitbox_rehit_time = 0.4

var hitbox_upgraded: bool = true
var hitbox_extra_damage = 1
var hitbox_extra_damage_boss = 1
var hitbox_extra_damage_weakness = 1
var hitbox_extra_break_guard_value = 1

var deflectable: bool = false

export  var upgraded: = true
onready var animatedSprite = character.get_node("animatedSprite")
onready var effect_animation = preload("res://Zero_mod/Sprites/BossAbilities/Juuhazan_effect.tres")
onready var saber_sound: AudioStreamPlayer = $saber


var start_speed = 320
var horizontal_speed = start_speed
var damping = 0.95

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
	hitbox_rehit_time = 0.4
	
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
	if animatedSprite.animation == "juuhazan":
		hitbox_damage = 12
		hitbox_damage_boss = 4
		hitbox_damage_weakness = 20
		hitbox_break_guards = true
		hitbox_rehit_time = 0.075
		if animatedSprite.frame >= 5 and animatedSprite.frame < 6:
			hitbox_upleft = Vector2( - 65, - 59)
			hitbox_downright = Vector2(7, 15)
		if animatedSprite.frame >= 6 and animatedSprite.frame < 7:
			hitbox_upleft = Vector2( - 55, - 79)
			hitbox_downright = Vector2(67, - 20)
		if animatedSprite.frame >= 7 and animatedSprite.frame < 10:
			hitbox_upleft = Vector2( - 5, - 79)
			hitbox_downright = Vector2(87, 30)
			
		if animatedSprite.frame >= 5 and animatedSprite.frame < 10:
			spawn_hitbox(hitbox_upleft, hitbox_downright)
			
	reset_hitbox()

var effect: AnimatedSprite
func effect_emit():
	effect = AnimatedSprite.new()
	add_child(effect)
	effect.frames = effect_animation
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
		

func end_saber_state():
	return animatedSprite.frame >= 24

func movement_speed_frames():
	return animatedSprite.frame >= 5 and animatedSprite.frame < 13

func set_saber_animations():
	animatedSprite.animation = "juuhazan"
	saber_sound.play()
	
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
	horizontal_speed = start_speed
	update_bonus_horizontal_only_conveyor()
	set_saber_animations()
	effect_emit()

func reduce_speed():
	horizontal_speed = 0

func damp_horizontal_speed(_delta: float) -> void :
	var reference_delta = 1.0 / 120
	var damping_factor = pow(damping, _delta / reference_delta)
	horizontal_speed *= damping_factor

func _Update(_delta: float) -> void :
	if is_instance_valid(effect):
		effect.frame = animatedSprite.frame
		effect.global_position = global_position
	hitbox_and_position()
	if movement_speed_frames():
		horizontal_velocity = horizontal_speed
		force_movement(horizontal_speed)
		damp_horizontal_speed(_delta)
	else:
		force_movement(0)
	

	process_gravity(_delta)
	update_bonus_horizontal_only_conveyor()

func change_animation_if_falling(_s) -> void :
	pass

func _Interrupt():
	._Interrupt()
	character.play_animation("saber_recover")
	if is_instance_valid(current_hitbox):
		current_hitbox.queue_free()
	if is_instance_valid(effect):
		effect.queue_free()
		effect = null

