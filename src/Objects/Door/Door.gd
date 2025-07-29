extends Node2D


export  var _debug_no_limits: = false
export  var unlocked: = true
export  var boss_door: = false
export  var should_lock_camera: = true
export  var emit_warning_signal: = false
export  var reopenable: = false
export  var position_correction: = 0
export  var initial_height_camera_correction: = 22
export (NodePath) var last_limits
export (NodePath) var explosion_extra_limits
export (NodePath) var next_limits

var state: = "able to open"
var player
var position_at_movestart: Vector2
var moving: = false
onready var animatedSprite: = $animatedSprite

var start_position: Vector2
var door_direction: = 1
var travel_distance: = 42
var explosion_timer: = 0.0
var timer: = 0.0
var move_timer: = 0.0

var player_at_door

export  var explosion_duration: = 2.0
var times_sound_played: = 0.0

signal door_open
signal door_close

func _ready() -> void :
	if not unlocked:
		state = "closed"
	if not _debug_no_limits:
		if not last_limits or not next_limits:
			push_error(name + ": Imminent error, no limits set")
		get_node(last_limits).connect("accessed", self, "last_zone_entered")
		disable_explosion_limits()

func disable_explosion_limits() -> void :
	var extra_limits = get_node_or_null(explosion_extra_limits)
	if extra_limits:
		extra_limits.disable()

func enable_explosion_limits() -> void :
	var extra_limits = get_node_or_null(explosion_extra_limits)
	if extra_limits:
		extra_limits.enable()
		GameManager.camera.include_area_limit(extra_limits)
	else:
		push_error("Door does not have an extra limit for explosion state.")

func reached_checkpoint() -> void :
	if state != "exploding":
		
		get_node(last_limits).disable()
		get_node(next_limits).enable()
		
		

func last_zone_entered() -> void :
	if state == "able to open":
		if not get_node(last_limits).disabled:
			
			
			
			get_node(next_limits).disable()

func _on_area2D_body_entered(body: Node) -> void :
	if is_player(body) and state == "able to open":
		player_at_door = body

func _on_area2D_body_exited(body: Node) -> void :
	if player_at_door == body:
		player_at_door = null

func _physics_process(delta: float) -> void :
	timer += delta
	if state == "able to open":
		if player_at_door:
			if is_able_to_open_door(player_at_door):
				start_open(player_at_door)
	elif state == "exploding":
		if timer > times_sound_played / 5 and timer < explosion_duration:
			play_explosion_sounds()
		explosion_timer += delta
		$animatedSprite.set_self_modulate(Color(1, 1, 1, abs(round(cos(explosion_timer * 300)))))
		if explosion_timer > 2:
			$animatedSprite.set_self_modulate(Color(1, 1, 1, 0))
			$"Explosion Particles".emitting = false
	else:
		move(delta)

func start_open(body) -> void :
	$open.play()
	player = body.get_parent()
	player_at_door = null
	player.cutscene_deactivate()
	animatedSprite.play("opening")
	state = "opening"
	define_direction()
	Event.emit_signal("disable_unneeded_objects")
	GameManager.pause("Door")
	Event.emit_signal("door_transition_start")
	
	if boss_door:
		Event.emit_signal("boss_door_open")

func is_player(body) -> bool:
	return body.is_in_group("Player") and not body.is_in_group("Props")

func is_able_to_open_door(body) -> bool:
	return not body.get_character().is_executing("Ride") and not body.get_character().is_executing("WeaponStasis") and abs(body.global_position.x - global_position.x) <= 26 and state == "able to open"

func explode(body):
	destroy_bike(body)
	player_at_door = null
	destroy_self()
	
	
	get_node(next_limits).enable()
	get_node(last_limits).enable()
	enable_explosion_limits()

func destroy_self():
	$staticBody2D.get_node("collisionShape2D").disabled = true
	$"Explosion Particles".emitting = true
	$"explosion_sound".play()
	state = "exploding"
	Event.emit_signal("screenshake", 2)

func destroy_bike(body):
	body.get_character().set_actual_speed(body.get_character().get_actual_speed() / 2)
	body.get_character().current_health = 0
	body.get_character().get_node("Death").emit_remains_particles()
	if body.get_character().is_executing("Riden"):
		body.get_character().get_node("Riden").force_eject()
	body.get_character().force_end("Dash")
	body.get_character().force_end("HyperDash")
	body.get_character().set_direction( - body.get_character().get_direction())
	

func define_direction():
	if player.global_position.x > global_position.x:
		door_direction = - 1
	else:
		door_direction = 1


func start_moving():
	if not moving:
		var old_limits = get_node(last_limits)
		var new_limits = get_node(next_limits)
		moving = true
		start_position = player.global_position
		if not _debug_no_limits:
			new_limits.enable()
		player.force_movement()
		if not _debug_no_limits:
			old_limits.disable()
		if boss_door:
			GameManager.camera.start_door_translate(global_position, new_limits, should_lock_camera)
		else:
			GameManager.camera.start_door_translate(global_position, new_limits)
			
		position_at_movestart = player.global_position

func move(delta):
	if moving:
		move_timer += delta
		if door_direction > 0:
			if player.global_position.x < start_position.x + travel_distance * door_direction:
				move_character(delta)
			else:
				stop_moving()
		elif door_direction < 0:
			if start_position.x + travel_distance * door_direction < player.global_position.x:
				move_character(delta)
			else:
				stop_moving()
		if move_timer > 0.2 and is_stuck():
			player.move_x(20 * delta)
			
			

func is_stuck() -> bool:
	return Tools.is_between(player.global_position.x, position_at_movestart.x - 5, position_at_movestart.x + 5)

func move_character(delta):
	player.move_x(20 * delta * door_direction)
	

func stop_moving():
	moving = false
	position.x += position_correction * door_direction
	animatedSprite.play("closing")
	if boss_door:
		$boss_close.play()
	else:
		$open.play()
	player.stop_forced_movement()
	player.cutscene_deactivate()

func _on_animatedSprite_animation_finished() -> void :
	if animatedSprite.animation == "opening":
		call_deferred("on_finished_opening")
	if animatedSprite.animation == "closing":
		on_finished_closing()

func on_finished_opening():
	emit_signal("door_open")
	$staticBody2D.get_node("collisionShape2D").disabled = true
	start_moving()
	GameManager.unpause("Door")
	state = "open"
	
func on_finished_closing():
	$staticBody2D.get_node("collisionShape2D").disabled = false
	emit_signal("door_close")
	GameManager.unpause("Door")
	Event.emit_signal("camera_follow_target")
	if boss_door:
		Event.emit_signal("boss_door_closed")
		if emit_warning_signal:
			Event.emit_signal("show_warning")
		else:
			Event.emit_signal("warning_done")
	else:
		if not player.is_executing("Ride"):
			player.start_listening_to_inputs()
	Event.emit_signal("door_transition_end")
	
	
	if reopenable:
		state = "able to open"
	else:
		state = "closed"

func play_explosion_sounds():
		times_sound_played += 1
		var audio = $audioStreamPlayer2D.duplicate()
		add_child(audio)
		audio.pitch_scale = rand_range(0.95, 1.05)
		audio.play()

func _on_bike_check_body_entered(body: Node) -> void :
	if not boss_door and state == "able to open":
		if body.is_in_group("Props"):
			if abs(body.get_character().get_actual_horizontal_speed()) > 325:
				call_deferred("explode", body)

func unlock() -> void :
	state = "able to open"
