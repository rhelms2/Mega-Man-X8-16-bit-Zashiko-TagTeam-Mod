extends Actor
class_name BossWeaponAxl

export  var weapon: Resource
export  var damage: float = 1.0
export  var damage_to_bosses: float = 1.0
export  var damage_to_weakness: float = 1.0
export  var horizontal_velocity: float = 360.0
export  var vertical_velocity: float = 360.0
export  var vertical_position_range: = 1
export  var time_outside_screen: float = 0.6
export  var fire_sound: AudioStream
export  var hit_sound: AudioStream
export  var hit: PackedScene
export  var break_guards: bool = false
export  var break_guard_damage: float = 1.0

onready var audio: AudioStreamPlayer2D = $audioStreamPlayer2D
onready var visibilityNotifier: VisibilityNotifier2D = $visibilityNotifier2D
onready var hit_particle: Sprite = get_node_or_null("Hit Particle")
onready var particle_visual: Particles2D = get_node_or_null("particles2D")

var countdown_to_destruction: float = 0.0
var facing_direction: int = 1
var original_pitch: float = 1.0
var timer_since_spawn: float = 0.0
var continuous_damage: bool = false
var destroyed: bool = false
var damageOnTouch
var emitted_hit_particle: bool = false

signal hit
signal projectile_started
signal projectile_end(this)


func should_unlock(collectible: String) -> bool:
	return collectible == weapon.collectible

func _ready() -> void :
	if not visibilityNotifier.is_connected("screen_entered",self,"_on_visibilityNotifier2D_screen_entered"):
		visibilityNotifier.connect("screen_entered", self, "_on_visibilityNotifier2D_screen_entered")
	if not visibilityNotifier.is_connected("screen_exited", self, "_on_visibilityNotifier2D_screen_exited"):
		visibilityNotifier.connect("screen_exited", self, "_on_visibilityNotifier2D_screen_exited")
	if not is_in_group("Player Projectile") and not is_in_group("Enemy Projectile"):
		
		pass

func emit_hit_particle() -> void :
	if not emitted_hit_particle and hit_particle:
		hit_particle.emit(facing_direction)
		emitted_hit_particle = true

func is_colliding(new_position: Vector2) -> bool:
	var space_state = get_world_2d().direct_space_state
	var result = space_state.intersect_ray(position, new_position)
	if result and result.has("collider"):
		return result.collider != null
	return false

func handle_collision(delta: float) -> void :
	var velocity = Vector2(get_horizontal_speed(), get_vertical_speed())





	position += velocity * delta

func process_gravity(delta: float, gravity: = 900.0, max_fall_speed: = 400.0) -> void :
	add_vertical_speed(gravity * delta)
	if get_vertical_speed() > max_fall_speed:
		set_vertical_speed(max_fall_speed)

func _physics_process(delta: float) -> void :
	timer_since_spawn += delta
	if not has_health():
		disable_visual_and_mechanics()
		emit_hit_particle()
	if countdown_to_destruction > 0:
		countdown_to_destruction += delta
		if countdown_to_destruction > time_outside_screen:
			destroy()
	elif timer_since_spawn > 2:
		if not visibilityNotifier.is_on_screen():
			destroy()

func hit(_body) -> void :
	if hit_sound:
		audio.stream = hit_sound
		audio.play()
	_body.damage(damage, self)
	emit_hit_particle()
	disable_visual_and_mechanics()
	emit_signal("hit")

func deflect(_body) -> void :
	disable_visual_and_mechanics()

func disable_visual_and_mechanics() -> void :
	disable_projectile_visual()
	disable_particle_visual()
	call_deferred("disable_damage")
	countdown_to_destruction = 0.01

func leave(_body) -> void :
	pass

func projectile_setup(direction: int, spawn_point: Vector2, launcher_velocity: float = 0.0) -> void :
	references_setup(direction)
	position_setup(spawn_point, direction)
	launch_setup(direction, launcher_velocity)
	play_fire_sound()
	call_deferred("emit_signal", "projectile_started")

func references_setup(direction) -> void :
	set_direction(direction)
	update_facing_direction()
	animatedSprite.scale.x = direction
	original_pitch = audio.pitch_scale

func position_setup(spawn_point: Vector2, direction: int) -> void :
	var x = spawn_point.x
	var y = spawn_point.y
	position.x = position.x + x * direction
	position.y = position.y + y + int(rand_range( - vertical_position_range, vertical_position_range))
	facing_direction = direction

func play_fire_sound(volume: float = 0.0, pitch: bool = true) -> void :
	if fire_sound != null:
		if pitch:
			audio.pitch_scale = original_pitch + rand_range( - 0.05, 0.0)
		if volume != 0.0:
			audio.stream.volume_db = volume
		audio.stream = fire_sound
		audio.play()

func play_hit_sound(volume: float = 0.0, pitch: bool = true) -> void :
	if hit_sound != null:
		if pitch:
			audio.pitch_scale = original_pitch + rand_range( - 0.05, 0.0)
		if volume != 0.0:
			audio.stream.volume_db = volume
		audio.stream = hit_sound
		audio.play()

func play_sound(sfx: AudioStream = null, volume: float = 0.0, pitch: bool = true, loop: bool = false) -> void :
	if sfx != null:
		if pitch:
			audio.pitch_scale = original_pitch + rand_range( - 0.05, 0.0)
		if volume != 0.0:
			audio.volume_db = volume
		audio.stream.loop = loop
		audio.stream = sfx
		audio.play()

func launch_setup(direction, launcher_velocity: float = 0.0) -> void :
	set_horizontal_speed((horizontal_velocity + launcher_velocity) * direction)

func stop() -> void :
	set_vertical_speed(0)
	set_horizontal_speed(0)

func disable_projectile_visual() -> void :
	animatedSprite.visible = false

func disable_particle_visual() -> void :
	if particle_visual:
		particle_visual.visible = false

func disable_visuals() -> void :
	Log("Disabling Visuals")
	animatedSprite.visible = false
	destroy()

func enable_visuals() -> void :
	Log("Enabling Visuals")
	animatedSprite.visible = true

func destroy_after_sound() -> void :
	yield(audio, "finished")
	destroy()

func destroy() -> void :
	queue_free()
	if destroyed:
		return
	destroyed = true
	emit_signal("projectile_end", self)

func _on_visibilityNotifier2D_screen_entered() -> void :
	countdown_to_destruction = 0.0

func _on_visibilityNotifier2D_screen_exited() -> void :
	countdown_to_destruction = 0.01

func is_collided_moving() -> bool:
	return get_last_slide_collision().collider_velocity != Vector2.ZERO

func has_hit_scenery() -> bool:
	return is_on_floor() or is_on_wall() or is_on_ceiling()

func disable_damage() -> void :
	if damageOnTouch != null:
		damageOnTouch.deactivate()

func can_be_hit() -> bool:
	return animatedSprite.visible
