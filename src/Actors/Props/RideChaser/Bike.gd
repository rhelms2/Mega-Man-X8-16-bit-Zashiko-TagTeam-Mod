extends Character
class_name Bike

var actual_speed : float
var timer := 0.0
var last_emitted_land := 0.0
var land_particle_duration := 0.16
var vertical_buildup := 0.0

onready var ground_check := $_raycasts.get_node("GroundCast")
onready var land_particles := $"animatedSprite/Smoke Particles"
onready var land_audio := $audioStreamPlayer2D
onready var riden: Node2D = $Riden


func _ready() -> void:
	GameManager.call_deferred("add_bike",self)
# warning-ignore:return_value_discarded
	stop_listening_to_inputs()
	set_safe_margin(1)

func connect_cutscene_events() -> void:
	Event.listen("cutscene_start",self,"deactivate")
	Event.listen("cutscene_over",self,"cutscene_activate")

func start_executing_moves() -> void:
	if onscreen or offscreen_timer < 3:
		for move in moveset:
			try_execution(move)

func cutscene_activate() -> void:
	if riden.executing:
		activate()

func _physics_process(delta: float) -> void:
	if onscreen:
		._physics_process(delta)
		timer += delta
	else:
		offscreen_timer += delta
		if offscreen_timer < 3:
			._physics_process(delta)
			timer += delta
		elif offscreen_timer > 6:
			destroy()
	
func check_for_land(delta: float):
	if is_on_floor():
		if not emitted_land:
			emitted_land = true
			time_since_on_floor = 0
			emit_signal("land")
			emit_land_particles()
			land_audio.play()
		else:
			if timer > last_emitted_land + land_particle_duration:
				land_particles.emitting = false
				
	else:
		time_since_on_floor += delta
		if emitted_land:
			emitted_land = false
			land_particles.emitting = false

func emit_land_particles(duration := 0.16):
	land_particles.emitting = true
	last_emitted_land = timer
	land_particle_duration = duration

func stop_land_particles():
	land_particles.emitting = false
	
#func _process(_delta: float) -> void:
#	if Configurations.get("ShowDebug"):
#		$label.text = str(get_ground_normal().x) + " " + str(snap_vector)

func process_final_velocity() -> Vector2:
	handle_slope_snap()
	handle_wall_collision()
	return move_and_slide_with_snap(final_velocity, snap_vector, up_direction,true,4,0.8)

func handle_wall_collision():
	if get_facing_direction() == is_colliding_with_wall():
		actual_speed = 0
		set_horizontal_speed(0)

func get_actual_speed() -> float:
	return actual_speed

func set_actual_speed(speed: float) -> void:
	actual_speed = speed

func add_actual_speed(speed: float) -> void:
	actual_speed += speed

func add_vertical_speed(yspeed: float, _s = "null") -> void:
	velocity.y += yspeed
	
func is_colliding_with_ground() -> bool:
	return ground_check.is_colliding() 

func get_ground_normal() -> Vector2:
	return ground_check.get_collision_normal()

func spike_touch() -> void:
		pass

func void_touch() -> void:
	if is_executing("Riden"):
		grab_eject()
		call_deferred("destroy")
	else:
		destroy()

func handle_slope_snap() -> void:
#	$label2.text = str(get_vertical_buildup())
	if is_not_jumping():
		if is_going_down_on_slope() or is_on_level_plane():
			enable_floor_snap()
		else:
			if is_at_proper_slope_jump_speed():
				disable_floor_snap()

func is_on_level_plane() -> bool:
	return get_ground_normal().x < 0.25 and get_ground_normal().x > -0.25

func is_not_jumping() -> bool:
	return is_on_floor() and snap_vector.y != 0

func is_at_proper_slope_jump_speed() -> bool:
	var slope_jump_speed = 120 
	return get_actual_speed() > slope_jump_speed or get_actual_speed() < -slope_jump_speed

func is_going_down_on_slope() -> bool:
	return is_facing_right_slope_down() or is_facing_left_slope_down()

func is_facing_right_slope_down() -> bool:
	return get_facing_direction() > 0 and get_ground_normal().x > 0.01
func is_facing_left_slope_down() -> bool:
	return get_facing_direction() < 0 and get_ground_normal().x < -0.01

func apply_damage_shader() -> void:
	animatedSprite.material.set_shader_param("Flash", 1)
	animatedSprite.material.set_shader_param("Should_Blink", 1)

func stop_damage_shader() -> void:
	animatedSprite.material.set_shader_param("Flash", 0)

func apply_invulnerability_shader():
	animatedSprite.material.set_shader_param("Alpha_Blink", 1)
	full_alpha = false

func remove_invulnerability_shader():
	animatedSprite.material.set_shader_param("Alpha_Blink", 0)
	full_alpha = true

func check_if_should_set_alpha_to_1():
	if invulnerability < 0 and not full_alpha and has_health():
		remove_invulnerability_shader()
		full_alpha = true

func damage(value, inflicter = null) -> float:
	if inflicter != self:
		value = value * 2
	emit_signal("damage",value,inflicter)
	return current_health

func hit(_body : Node) -> void:
	emit_signal("melee_hit", _body)

func grab_eject() -> void:
	if is_executing("Riden"):
		get_ability("Riden").enemy_eject()

func destroy() -> void:
	GameManager.bikes.erase(self)
	.destroy()

func set_vertical_speed(speed: float, floor_snap := true):
	if speed == 0 and floor_snap:
		enable_floor_snap()
	else:
		disable_floor_snap()
	velocity.y = speed
	
const damage_reduction := .75
func reduce_health(value : float):
	var health_to_reduce = value * (1 - damage_reduction)
	current_health -= health_to_reduce

var onscreen := false
var offscreen_timer := 0.0
func _on_visibilityNotifier2D_screen_entered() -> void:
	onscreen = true
	offscreen_timer = 0.01


func _on_visibilityNotifier2D_screen_exited() -> void:
	onscreen = false
