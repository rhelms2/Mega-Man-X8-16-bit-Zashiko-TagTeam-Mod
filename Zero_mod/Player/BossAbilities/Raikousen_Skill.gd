extends Movement
class_name SaberRaikousen

export  var saber_hitbox: Resource = preload("res://Zero_mod/Player/Hitboxes/Raikousen_Hitbox.tscn")
var current_hitbox = null
var hitbox_upleft = Vector2(0, 0)
var hitbox_downright = Vector2(0, 0)
var hitbox_damage = 0
var hitbox_damage_boss = 0
var hitbox_damage_weakness = 0
var hitbox_break_guard_value = 0
var hitbox_break_guards: bool = true
var hitbox_rehit_time = 0.4

var hitbox_upgraded: bool = false
var hitbox_extra_damage = 1
var hitbox_extra_damage_boss = 1
var hitbox_extra_damage_weakness = 1
var hitbox_extra_break_guard_value = 1

var deflectable: bool = false

export  var upgraded: = false
onready var animatedSprite = character.get_node("animatedSprite")
onready var shadow_animation = preload("res://Zero_mod/Sprites/BossAbilities/Raikousen_Shadow.tres")
var _rotator_script = preload("res://System/misc/rotatordelete.gd")

var start_speed = 900
var h_speed = start_speed
var v_speed = start_speed
var horizontal_speed = start_speed
var vertical_speed = start_speed
var damping = 0.95

var rotation_value = 0
var rotation_deg = 22.5
var go_upwards: bool = false

onready var sfx_sound: AudioStreamPlayer = $sfx
onready var sfx2_sound: AudioStreamPlayer = $sfx2
var sound_played: bool = false
var sound2_played: bool = false

func play_skill_sound():
	if not sound_played:
		if animatedSprite.frame >= 0:
			sfx_sound.play()
			sound_played = true
	if not sound2_played:
		if animatedSprite.frame >= 8:
			sfx2_sound.play()
			sound2_played = true

func _ready():
	
	pass

func reset_hitbox():
	hitbox_upleft = Vector2(0, 0)
	hitbox_downright = Vector2(0, 0)
	hitbox_damage = 0
	hitbox_damage_boss = 0
	hitbox_damage_weakness = 0
	hitbox_break_guard_value = 0
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
		
	current_hitbox.rotation_degrees = animatedSprite.rotation_degrees
	current_hitbox.damage = hitbox_damage * hitbox_extra_damage
	current_hitbox.damage_to_bosses = hitbox_damage_boss * hitbox_extra_damage_boss
	current_hitbox.damage_to_weakness = hitbox_damage_weakness * hitbox_extra_damage_weakness
	current_hitbox.break_guard_damage = hitbox_break_guard_value * hitbox_extra_break_guard_value
	current_hitbox.break_guards = hitbox_break_guards
	current_hitbox.saber_rehit = hitbox_rehit_time
	current_hitbox.upgraded = hitbox_upgraded
	
	current_hitbox.deflectable = deflectable

func hitbox_and_position():
	if animatedSprite.animation == "raikousen":
		hitbox_damage = 4
		hitbox_damage_boss = 2
		hitbox_damage_weakness = 24
		hitbox_rehit_time = 0.075
		if animatedSprite.frame >= 10 and animatedSprite.frame < 16:
			hitbox_upleft = Vector2( - 120, - 15)
			hitbox_downright = Vector2(100, 5)
			
			spawn_hitbox(hitbox_upleft, hitbox_downright)
			
	reset_hitbox()

func end_saber_state():
	return animatedSprite.frame >= 20

var shadow: AnimatedSprite
var shadow_emitted: bool = false
func shadow_emit():
	if animatedSprite.frame >= 3:
		if not shadow_emitted:
			shadow = AnimatedSprite.new()
			get_tree().root.add_child(shadow)
			shadow.frames = shadow_animation
			shadow.playing = true
			shadow.global_position = global_position
			shadow.modulate = Color(1, 1, 1, 0.5)
			
			shadow.scale = animatedSprite.scale
			shadow.z_index = 1
			shadow.centered = animatedSprite.centered
			shadow.offset.y = animatedSprite.offset.y - 3
			shadow.flip_h = animatedSprite.flip_h
			shadow.flip_v = animatedSprite.flip_v
			shadow.rotation_degrees = animatedSprite.rotation_degrees
			
			shadow.connect("animation_finished", self, "_on_shadow_animation_finished")
			shadow_emitted = true
			
			var rotator = Node.new()
			rotator.set_name("rotator")
			rotator.set_script(_rotator_script)
			shadow.add_child(rotator)

func _on_shadow_animation_finished():
	if shadow:
		shadow.queue_free()
		shadow = null

func movement_speed_frames():
	return animatedSprite.frame >= 3 and animatedSprite.frame < 16

func set_saber_animations():
	animatedSprite.animation = "raikousen"
	
func _StartCondition() -> bool:
	if not character.Raikousen:
		return false
	var _animation = get_parent().get_animation()
	if _animation in character.saber_animations:
		return false
	if not executing:
		if _animation == "dash":
			return true
	return false
	
func _ResetCondition() -> bool:
	return false

func _EndCondition() -> bool:
	var _animation = get_parent().get_animation()
	if _animation in character.saber_animations:
		if not _animation == "raikousen":
			return true
		if end_saber_state():
			return true
	else:
		return true
	return false

func _Setup() -> void :
	horizontal_speed = start_speed
	shadow_emitted = false
	go_upwards = false
	set_saber_animations()
	sound_played = false
	sound2_played = false

func reduce_speed():
	horizontal_speed = 0

func process_invulnerability():
	if animatedSprite.frame >= 3 and animatedSprite.frame < 14:
		character.add_invulnerability(name)
	else:
		character.remove_invulnerability(name)

func damp_horizontal_speed(_delta: float) -> void :
	var reference_delta = 1.0 / 120
	var damping_factor = pow(damping, _delta / reference_delta)
	horizontal_speed *= damping_factor

func _Update(_delta: float) -> void :
	play_skill_sound()
	shadow_emit()
	hitbox_and_position()
	if animatedSprite.frame >= 2:
		animatedSprite.rotation_degrees = rotation_value
	if movement_speed_frames():
		force_movement(horizontal_speed)
		character.set_vertical_speed(0)
		damp_horizontal_speed(_delta)
	else:
		force_movement(0)
		character.set_vertical_speed(0)
	
	process_invulnerability()

func change_animation_if_falling(_s) -> void :
	pass

func _Interrupt():
	._Interrupt()
	character.remove_invulnerability(name)
	character.play_animation("saber_recover")
	animatedSprite.rotation_degrees = 0
	rotation_value = 0
	if is_instance_valid(current_hitbox):
		current_hitbox.queue_free()

