extends Movement
class_name SaberZeroBase

export  var saber_hitbox: Resource = preload("res://Zero_mod/Player/Hitboxes/Saber_Hitbox.tscn")
var current_hitbox = null
var hitbox_upleft = Vector2(0, 0)
var hitbox_downright = Vector2(0, 0)
var hitbox_damage = 0
var hitbox_damage_boss = 0
var hitbox_damage_weakness = 0
var hitbox_break_guard_value = 0.25
var hitbox_break_guards: bool = false
var hitbox_rehit_time = 0.2

var hitbox_upgraded: bool = false
var hitbox_extra_damage = 1
var hitbox_extra_damage_boss = 1
var hitbox_extra_damage_weakness = 1
var hitbox_extra_break_guard_value = 1

var deflectable: bool = false

export  var upgraded: = false
onready var animatedSprite = character.get_node("animatedSprite")
onready var saber_sound: AudioStreamPlayer = $saber

var current_weapon_index: = 0
var weapons = []
var current_weapon
var _listening_to_inputs_start: bool = true
var interrupted_cutscene: bool = false
var slashing: bool = false
var slashes = 0

func reset_hitbox():
	hitbox_upleft = Vector2(0, 0)
	hitbox_downright = Vector2(0, 0)
	hitbox_damage = 0
	hitbox_damage_boss = 0
	hitbox_damage_weakness = 0
	hitbox_break_guard_value = 0.25
	hitbox_break_guards = false
	hitbox_rehit_time = 0.2
	
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
	spawn_hitbox(hitbox_upleft, hitbox_downright)
	reset_hitbox()

func end_saber_state():
	pass

func should_add_saber_combo():
	return false

func set_saber_animations():
	if character.is_on_floor():
		if slashes == 0:
			pass

	slashes += 1
	saber_sound.play()
	
func _StartCondition() -> bool:
	return false
	
func _ResetCondition() -> bool:
	return false

func _EndCondition() -> bool:
	return true

func _Setup() -> void :
	update_bonus_horizontal_only_conveyor()
	changed_animation = false
	slashing = false
	set_saber_animations()

func _Update(_delta: float) -> void :
	hitbox_and_position()
	if should_add_saber_combo():
		if character.get_action_just_pressed("fire"):
			set_saber_animations()
	set_movement_and_direction(0)

	process_gravity(_delta)
	update_bonus_horizontal_only_conveyor()

func change_animation_if_falling(_s) -> void :
	pass

func _Interrupt():
	._Interrupt()
	slashes = 0
	character.play_animation("saber_recover")
	if is_instance_valid(current_hitbox):
		current_hitbox.queue_free()

