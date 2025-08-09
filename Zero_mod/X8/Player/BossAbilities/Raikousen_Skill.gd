extends Movement
class_name SaberRaikousenX8

export  var saber_hitbox: Resource = preload("res://Zero_mod/Player/Hitboxes/Raikousen_Hitbox.tscn")
export  var upgraded: bool = false
export  var damage: float = 4.0
export  var damage_boss: float = 4.0
export  var damage_weakness: float = 24.0

onready var animatedSprite: = character.get_node("animatedSprite")
onready var shadow_animation: Resource = preload("res://Zero_mod/Sprites/BossAbilities/Raikousen_Shadow.tres")
onready var _rotator_script: Script = preload("res://System/misc/rotatordelete.gd")

var hitbox_upleft_corner: Vector2 = Vector2( - 120, - 15)
var hitbox_downright_corner: Vector2 = Vector2(100, 5)
var instant_damage: bool = false
var current_hitbox = null
var hitbox_name: String = "Raikousen"
var hitbox_upleft: Vector2 = Vector2(0, 0)
var hitbox_downright: Vector2 = Vector2(0, 0)
var hitbox_damage: float = 0.0
var hitbox_damage_boss: float = 0.0
var hitbox_damage_weakness: float = 0.0
var hitbox_break_guard_value: float = 0.0
var hitbox_break_guards: bool = true
var hitbox_rehit_time: float = 0.4
var hitbox_upgraded: bool = false
var hitbox_extra_damage: float = 1.0
var hitbox_extra_damage_boss: float = 1.0
var hitbox_extra_damage_weakness: float = 1.0
var hitbox_extra_break_guard_value: float = 1.0
var deflectable: bool = false
var deflectable_type: int = 0
var only_deflect_weak: bool = false

var ending_saber_state: bool = false
var start_speed: float = 900.0
var h_speed: float = start_speed
var v_speed: float = start_speed
var horizontal_speed: float = start_speed
var vertical_speed: float = start_speed
var damping: float = 0.95

var vulnerable: bool = true
var movement_frame_start: int = 3
var movement_frame_end: int = 16
var hitbox_frame_start: int = 3
var hitbox_frame_end: int = 16
var shadow_frame: int = 3
var sound_1_frame: int = 0
var sound_2_frame: int = 8

var rotation_value: float = 0.0
var rotation_deg: float = 22.5
var go_upwards: bool = false
var facing_direction: int = 1

onready var sfx_sound: AudioStreamPlayer = $sfx
onready var sfx2_sound: AudioStreamPlayer = $sfx2
onready var sfx3_sound: AudioStreamPlayer = $sfx3
var sound_played: bool = false
var sound2_played: bool = false

onready var effect_scene: PackedScene = preload("res://System/misc/visual_effect.tscn")
var effect_spawn_position: Vector2 = Vector2(0, 0)
var effect_spawn_timer: float = 0.0
var effect_spawn_time: float = 0.02
var light_size: Vector2 = Vector2(3, 2)


func _ready() -> void :
	animatedSprite.connect("animation_finished", self, "_on_animation_finished")

func _on_animation_finished() -> void :
	ending_saber_state = true

func play_skill_sound() -> void :
	if not sound_played:
		if animatedSprite.frame >= sound_1_frame:
			sfx_sound.play()
			sound_played = true
	if not sound2_played:
		if animatedSprite.frame >= sound_2_frame:
			sfx2_sound.play()
			sound2_played = true

func reset_hitbox() -> void :
	hitbox_upleft = Vector2(0, 0)
	hitbox_downright = Vector2(0, 0)
	hitbox_damage = 0
	hitbox_damage_boss = 0
	hitbox_damage_weakness = 0
	hitbox_break_guard_value = 0
	hitbox_break_guards = true
	hitbox_rehit_time = 0.4
	
func set_hitbox_corners(upleft: Vector2, downright: Vector2) -> RectangleShape2D:
	var shape = RectangleShape2D.new()
	var size = downright - upleft
	shape.extents = size / 2
	return shape
	
func spawn_hitbox(_hitbox_upleft: Vector2, _hitbox_downright: Vector2) -> void :
	current_hitbox = saber_hitbox.instance()

	var collision_shape_node = current_hitbox.get_node("collisionShape2D")
	var deflection_shape_node = current_hitbox.get_node("area2D/collisionShape2D")
	var tracker_shape_node = current_hitbox.get_node("tracker/collisionShape2D")
	if collision_shape_node == null:
		return
	else:
		current_hitbox.collision_shape = collision_shape_node
	if deflection_shape_node == null:
		return
	else:
		current_hitbox.deflection_shape = deflection_shape_node
	if tracker_shape_node == null:
		return
	else:
		current_hitbox.tracker_collision = tracker_shape_node
	
	var hitbox_shape = set_hitbox_corners(_hitbox_upleft, _hitbox_downright)
	var hitbox_position = Vector2(0, 0)
	
	var _facing_direction = get_facing_direction()
	if _facing_direction == - 1:
		var temp_upleft = Vector2( - _hitbox_downright.x, _hitbox_upleft.y)
		var temp_downright = Vector2( - _hitbox_upleft.x, _hitbox_downright.y)
		hitbox_shape = set_hitbox_corners(temp_upleft, temp_downright)
		hitbox_position = (temp_upleft + temp_downright) / 2
	else:
		hitbox_shape = set_hitbox_corners(_hitbox_upleft, _hitbox_downright)
		hitbox_position = (_hitbox_upleft + _hitbox_downright) / 2
	
	current_hitbox.collision_shape.shape = hitbox_shape
	current_hitbox.deflection_shape.shape = hitbox_shape
	current_hitbox.tracker_collision.shape = hitbox_shape
	current_hitbox.position = hitbox_position
	current_hitbox.rotation_degrees = animatedSprite.rotation_degrees
	current_hitbox.light_size = light_size
	current_hitbox.name = hitbox_name
	add_child(current_hitbox)
		
	current_hitbox.damage = hitbox_damage * hitbox_extra_damage
	current_hitbox.damage_to_bosses = hitbox_damage_boss * hitbox_extra_damage_boss
	current_hitbox.damage_to_weakness = hitbox_damage_weakness * hitbox_extra_damage_weakness
	current_hitbox.break_guard_damage = hitbox_break_guard_value * hitbox_extra_break_guard_value
	current_hitbox.break_guards = hitbox_break_guards
	current_hitbox.saber_rehit = hitbox_rehit_time
	current_hitbox.upgraded = hitbox_upgraded
	current_hitbox.instant_damage = instant_damage
	current_hitbox.deflectable = deflectable
	current_hitbox.deflectable_type = deflectable_type
	current_hitbox.only_deflect_weak = only_deflect_weak

func hitbox_and_position() -> void :
	if animatedSprite.animation == "raikousen":
		hitbox_damage = damage
		hitbox_damage_boss = damage_boss
		hitbox_damage_weakness = damage_weakness
		hitbox_rehit_time = 0.075
		if animatedSprite.frame >= hitbox_frame_start and animatedSprite.frame < hitbox_frame_end:
			hitbox_upleft = hitbox_upleft_corner
			hitbox_downright = hitbox_downright_corner
			spawn_hitbox(hitbox_upleft, hitbox_downright)
	reset_hitbox()

var effect: AnimatedSprite
var effect_transparency: float = 0.65
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

var shadow: AnimatedSprite
var shadow_emitted: bool = false
func shadow_emit() -> void :
	if animatedSprite.frame >= shadow_frame:
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

func effect_only_emit(delta) -> void :
	effect_position()
	effect_spawn_timer += delta
	if effect_spawn_timer >= effect_spawn_time:
		sfx3_sound.play()
		effect_spawn_timer = 0
		var effect_instance = effect_scene.instance()
		effect_instance.frames = load("res://Zero_mod/X8/Sprites/BossAbilities/ability_effects.tres")
		effect_instance.animation = "raijinken_sparks"
		effect_instance.global_position = effect_spawn_position
		effect_instance.z_index = animatedSprite.z_index + 3
		if get_facing_direction() > 0:
			effect_instance.flip_h = false
		else:
			effect_instance.flip_h = true
		effect_instance.rotation_degrees = randi() %90 - 90
		effect_instance.modulate = Color(1, 1, 1, 0.65)
		effect_instance.light_enabled = true
		effect_instance.light_strength = 0.5
		effect_instance.light_color = Color("#63C6EF")
		effect_instance.light_size = Vector2(0.75, 0.75)
		effect_instance.light_randomize = true
		effect_instance.light_random_light = Vector2(0.9, 1.3)
		effect_instance.light_random_width = Vector2(0.9, 1.3)
		effect_instance.light_random_height = Vector2(0.9, 1.3)
		get_tree().current_scene.add_child(effect_instance)

func effect_position() -> void :
	var offsets_x = [ - 17, - 17, - 17, - 17, - 17, - 13, - 15, - 8, 0, 0, 15, 15, 15, 15, 15, 15, 15, 15]
	var offsets_y = [ - 5, - 5, - 5, - 5, - 5, - 18, - 7, 4, 15, 15, - 7, - 20, - 25, - 25, - 25, - 25, - 25, - 25]
	var frame = animatedSprite.frame
	var offset_x = 0
	if frame < offsets_x.size():
		offset_x = offsets_x[frame]
	var offset_y = 0
	if frame < offsets_y.size():
		offset_y = offsets_y[frame]
	var rand_x = randi() %5 - 2
	var rand_y = randi() %5 - 2
	effect_spawn_position = Vector2(global_position.x + (rand_x + offset_x) * get_facing_direction(), global_position.y + rand_y + offset_y)

func _on_shadow_animation_finished() -> void :
	if shadow:
		shadow.queue_free()
		shadow = null

func end_saber_state() -> bool:
	return ending_saber_state

func movement_speed_frames() -> bool:
	return animatedSprite.frame >= movement_frame_start and animatedSprite.frame < movement_frame_end

func set_saber_animations() -> void :
	animatedSprite.animation = "raikousen"

func _StartCondition() -> bool:
	if not character.Raikousen:
		return false
	if character.combo_connection_raikousen():
		return true
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
	effect_spawn_timer = 0.0
	if character.saber_node.current_weapon.name == "Saber":
		effect_emit("raikousen")

	elif character.saber_node.current_weapon.name == "B-Fan":
		effect_emit("raikousen_fan")

	elif character.saber_node.current_weapon.name == "D-Glaive":
		effect_emit("raikousen_glaive")

	elif character.saber_node.current_weapon.name == "K-Knuckle":
		effect_emit("raijinken")

	elif character.saber_node.current_weapon.name == "T-Breaker":
		effect_emit("raikousen_breaker")

	horizontal_speed = start_speed
	shadow_emitted = false
	go_upwards = false
	set_saber_animations()
	sound_played = false
	sound2_played = false
	if character.facing_right:
		facing_direction = 1
	else:
		facing_direction = - 1
	if character.saber_node.current_weapon.name == "Saber":
		if character.get_action_pressed("move_up"):
			rotation_value = - rotation_deg * facing_direction
			go_upwards = true
		elif character.get_action_pressed("move_down"):
			if not character.is_on_floor():
				rotation_value = rotation_deg * facing_direction
		else:
			if character.is_on_floor():
				var floor_normal = character.get_floor_normal()
				var angle_degrees = rad2deg(atan2(floor_normal.y, floor_normal.x))
				rotation_value = angle_degrees + 90
	ending_saber_state = false

func reduce_speed() -> void :
	horizontal_speed = 0

func process_invulnerability() -> void :
	if vulnerable:
		if animatedSprite.frame >= movement_frame_start and animatedSprite.frame < movement_frame_end - 2:
			character.add_invulnerability(name)
		else:
			character.remove_invulnerability(name)

func damp_horizontal_speed(_delta: float) -> void :
	var reference_delta = 1.0 / 120
	var damping_factor = pow(damping, _delta / reference_delta)
	horizontal_speed *= damping_factor

func _Update(delta: float) -> void :
	if character.saber_node.current_weapon.name == "K-Knuckle":
		if animatedSprite.frame < 15:
			effect_only_emit(delta)
		if animatedSprite.frame >= 12 and animatedSprite.frame < 14:
			Event.emit_signal("screenshake", 0.2)
	if is_instance_valid(effect):
		effect.frame = animatedSprite.frame
		effect.global_position = global_position
		effect.rotation_degrees = animatedSprite.rotation_degrees
		if character.saber_node.current_weapon.name == "K-Knuckle":
			effect.global_position = global_position - Vector2(0, 40)
	play_skill_sound()
	shadow_emit()
	hitbox_and_position()
	if animatedSprite.frame >= 2:
		animatedSprite.rotation_degrees = rotation_value
	if movement_speed_frames():
		if character.is_on_floor() and not go_upwards:
			if character.saber_node.current_weapon.name == "Saber":
				var floor_normal = character.get_floor_normal()
				var angle_degrees = rad2deg(atan2(floor_normal.y, floor_normal.x))
				rotation_value = angle_degrees + 90
		
		var angle_rad = deg2rad(animatedSprite.rotation_degrees)
		var _h_speed = horizontal_speed * cos(angle_rad)
		var _v_speed = horizontal_speed * facing_direction * sin(angle_rad)
		
		if character.is_on_floor() and go_upwards:
			var floor_normal = character.get_floor_normal()
			var angle_degrees = rad2deg(atan2(floor_normal.y, floor_normal.x))
			rotation_value = angle_degrees + 90 - rotation_deg * facing_direction
			
		if character.is_on_ceiling() and go_upwards:
			rotation_value = 0 * facing_direction
			
		force_movement(_h_speed)
		character.set_vertical_speed(_v_speed)
		damp_horizontal_speed(delta)
	else:
		force_movement(0)
		character.set_vertical_speed(0)
	process_invulnerability()

func change_animation_if_falling(_s) -> void :
	pass

func _Interrupt() -> void :
	._Interrupt()
	character.dashjumps_since_jump = 0
	character.dashfall = false
	character.remove_invulnerability(name)
	animatedSprite.rotation_degrees = 0
	rotation_value = 0
	if character.is_on_floor():
		animatedSprite.animation = "recover"
	else:
		animatedSprite.animation = "fall"
	if is_instance_valid(current_hitbox):
		current_hitbox.queue_free()
	if is_instance_valid(effect):
		effect.queue_free()
		effect = null
