extends BossWeaponAxl

const bypass_shield: bool = true

onready var start_particle: = get_node("Start Particle")
onready var light: Light2D = $light
onready var tracker: Area2D = $tracker
onready var pause_script: Script = preload("res://Zero_mod/System/PauseInstance.gd")

var hit_time: float = 0.0
var emitted_start_particle: bool = false
var ending: = false
var timer: float = 0.0
var light_color: Color = Color.aqua
var target: Node2D
var energized: bool = false
var pause_duration = 1
var rand_timer: float = 0.0
var rand_time: float = 0.05
var rand_value: int = 10


func process_movement() -> void :
	pass

func _physics_process(delta: float) -> void :
	rand_time = 0.1
	rand_value = 5
	rand_timer += delta
	if rand_timer >= rand_time:
		rand_timer = 0.0
		var random = rand_range( - rand_value, rand_value)
		set_horizontal_speed(horizontal_velocity + random)
		set_vertical_speed(vertical_velocity + random)
		set_rotation(Vector2(get_horizontal_speed(), get_vertical_speed()).angle())
		set_horizontal_speed(0)
		set_vertical_speed(0)
	
	handle_collision(delta)
	timer += delta
	if timer > 0.3:
		disable_damage()
		light.dim(0.5, 0)
	else:
		light.light(0.3 * rand_range(0.9, 1.1), Vector2(3 * rand_range(0.9, 1.1), 2 * rand_range(0.9, 1.1)), light_color)
	if timer > 0.4:
		destroy()
	if not energized:
		target = tracker.get_closest_target()
		if target:
			if "Lamp" in target.name:
				if target.has_method("full_energy"):
					target.full_energy()
					energized = true
				else:
					if target.has_method("energize"):
						target.energize()

func on_wall_hit() -> void :
	pass

func deactivate() -> void :
	active = false
	disable_projectile_visual()
	call_deferred("disable_damage")
	remove_from_group("Player Projectile")

func references_setup(direction) -> void :
	set_direction(direction)
	animatedSprite.scale.x = direction
	update_facing_direction()
	$animatedSprite.set_frame(int(rand_range(0, 2)))
	original_pitch = audio.pitch_scale

func process_hittime(delta: float) -> void :
	if hit_time > 0:
		hit_time += delta

func hit(hit_target) -> void :
	if active:
		if hit_target is BossDamage:
			hit_target.damage(damage, self)
		else:
			var existing_pause_node = hit_target.get_parent().get_node_or_null("Pause Enemy")
			if existing_pause_node != null:
				hit_target.damage(damage, self)
			else:
				var pause_node = Node.new()
				pause_node.set_name("Pause Enemy")
				pause_node.set_script(pause_script)
				pause_node.pause_duration = pause_duration
				pause_node.stun = true
				hit_target.get_parent().add_child(pause_node)
				pause_node.start_pause(hit_target.get_parent(), 0, self)
				hit_target.damage(damage, self)
		call_deferred("disable_damage")
		remove_from_group("Player Projectile")
		active = false

func emit_hit_particle() -> void :
	pass

func leave(_target) -> void :
	pass

func deflect(_body) -> void :
	pass

func launch_setup(_direction, _launcher_velocity: float = 0.0) -> void :
	light.light(0.3, Vector2(3, 2), light_color)
	animatedSprite.playing = true
	if randf() * 100 < 50:
		animatedSprite.flip_v = true
	if get_facing_direction() > 0:
		get_node("animatedSprite").rotation = deg2rad(0)
	else:
		get_node("animatedSprite").rotation = deg2rad(180)
	animatedSprite.scale.x = get_facing_direction()
	animatedSprite.scale.y = get_facing_direction()
	set_horizontal_speed(horizontal_velocity)
	set_vertical_speed(vertical_velocity)
	set_rotation(Vector2(get_horizontal_speed(), get_vertical_speed()).angle())
	set_horizontal_speed(0)
	set_vertical_speed(0)

func disable_damage() -> void :
	$collisionShape2D.disabled = true
