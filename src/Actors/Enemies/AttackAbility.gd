class_name AttackAbility extends EnemyAbility

export var desperation_attack := false
var decaying_speed := 100.0
var tween_list = []

signal deactivated

func check_for_event_errors() -> void:
	if actions.size() == 0 and character is Panda and name != "Idle":
		#push_warning(get_parent().name + "." + name + ": no actions found. Adding Event.")
		actions.append("Event")

func _Setup():
	turn_and_face_player()
	reset_decay()

func Should_Execute() -> bool:
	if active:
		if conflicting_abilities():
			return false
		return true
	return false

func _StartCondition() -> bool:
	return true
	
func _EndCondition() -> bool:
	return false

func turn() -> void:
	set_direction(character.get_facing_direction() * -1)

func turn_towards_point(point_global_position) -> void:
	if point_global_position.x > character.global_position.x:
		set_direction(1)
	else:
		set_direction(-1)
	
func turn_away_from_point(point_global_position) -> void:
	if point_global_position.x > character.global_position.x:
		set_direction(-1)
	else:
		set_direction(1)

func turn_and_face_player():
	set_direction( get_player_direction_relative() )

func face_away_from_player() -> void:
	set_direction( -get_player_direction_relative() )

func is_facing_player() -> bool:
	return character.get_facing_direction() == get_player_direction_relative()

func get_player_direction_relative() -> int:
	if GameManager.get_player_position().x > character.global_position.x:
		return(1)
	else:
		return(-1)

func get_player_facing_direction() -> int:
	if GameManager.get_player_position().x > character.global_position.x:
		return(1)
	else:
		return(-1)

func is_player_in_front() -> bool:
	return get_player_direction_relative() == character.get_facing_direction()

func is_player_nearby_horizontally(distance := 24.0) -> bool:
	if GameManager.get_player_position().x > character.global_position.x - distance and \
	GameManager.get_player_position().x < character.global_position.x + distance:
		return true
	else:
		return false

func get_distance_from_player() -> float:
	return abs(GameManager.get_player_position().x - character.global_position.x)

func is_player_nearby(distance : Vector2) -> bool:
	return is_player_nearby_horizontally(distance.x) and is_player_nearby_vertically(distance.y)

func is_player_above(distance := 0.0) -> bool:
	return GameManager.get_player_position().y < character.global_position.y - distance 

func is_player_nearby_vertically(distance := 24.0) -> bool:
	if GameManager.get_player_position().y > character.global_position.y - distance and \
	GameManager.get_player_position().y < character.global_position.y + distance:
		return true
	else:
		return false

func get_distance_to_player() -> float:
	return GameManager.get_player_position().x - character.global_position.x

func is_colliding_with_wall() -> bool:
	return character.is_colliding_with_wall() == character.get_direction()

func is_colliding_with_wall_on_direction(dir : int) -> bool:
	return character.is_colliding_with_wall() == dir

func is_colliding_with_wall_on_either_direction() -> bool:
	return character.is_colliding_with_wall() != 0

func raycast_from(origin : Vector2, target : Vector2) -> Dictionary:
	var space_state = get_world_2d().direct_space_state
	return space_state.intersect_ray(origin, target, [self,get_parent()], 1)

func raycast(target_position : Vector2) -> Dictionary:
	var space_state = get_world_2d().direct_space_state
	return space_state.intersect_ray(global_position, target_position, [self], 1)

func raycast_upward(distance : float) -> Dictionary:
	return raycast(Vector2(global_position.x,global_position.y - distance))

func raycast_downward(distance : float) -> Dictionary:
	return raycast(Vector2(global_position.x,global_position.y + distance))

func raycast_forward(distance : float) -> Dictionary:
	return raycast(Vector2(global_position.x + distance * character.get_facing_direction(),global_position.y))

func raycast_in_direction(distance : float, direction : int) -> Dictionary:
	return raycast(Vector2(global_position.x + distance * direction,global_position.y))

func get_distance_from_ceiling() -> float:
	var ceiling = raycast_upward(1024)
	if not ceiling:
		Log("Ceiling not detected, returning 1024")
		return 1024.0
	Log("Ceiling pos y " + str(ceiling["position"].y))
	return global_position.y - ceiling["position"].y
	

func decay_speed(speed_multiplier := 1.0, duration := 0.25) -> void:
	var tween = get_tree().create_tween()
	tween.tween_method(self, "force_movement", get_actual_speed() * speed_multiplier,0.0,duration)
	tween_list.append(tween)
	
func decay_speed_regardless_of_direction(duration := 0.25) -> void:
	var tween = get_tree().create_tween()
	tween.tween_method(self, "set_horizontal_speed", get_absolute_speed(),0.0,duration)
	tween_list.append(tween)

func decay_vertical_speed_regardless_of_direction(duration := 0.25) -> void:
	var tween = get_tree().create_tween()
	tween.tween_method(self, "set_vertical_speed", get_absolute_vertical_speed(),0.0,duration)
	tween_list.append(tween)

func tween_speed(starting_speed := 20.0, final_speed := 0.0, duration := 0.25) -> void:
	var tween = get_tree().create_tween()
	tween.tween_method(self, "force_movement", starting_speed, final_speed, duration)
	tween_list.append(tween)

func tween_attribute(attribute : String, final_value=1.0, duration:=0.25, object = self) -> void:
	var tween = get_tree().create_tween()
	tween.tween_property(object, attribute, final_value, duration)
	tween_list.append(tween)

func get_last_tween():
	return tween_list.back()
	
func add_next_state(tween : SceneTreeTween):
	tween.set_parallel(false)
	tween.tween_callback(self,"next_attack_stage")

func get_actual_speed() -> float:
	return character.get_actual_horizontal_speed() * character.get_facing_direction()

func get_absolute_speed() -> float:
	return character.get_actual_horizontal_speed()
func get_absolute_vertical_speed() -> float:
	return character.get_actual_vertical_speed()

func get_distance_from_wall() -> float:
	var wall = raycast_forward(1024)
	if not wall:
		Log("Wall not detected, returning 1024")
		return 1024.0
	Log("Wall pos x " + str(wall["position"].x))
	return (global_position.x + 20 * character.get_facing_direction()) - wall["position"].x

func get_forward_wall_position() -> float:
	var wall = raycast_forward(1024)
	if not wall:
		Log("Wall not detected, returning 1024")
		return 1024.0
	Log("Wall pos x " + str(wall["position"].x))
	return wall["position"].x
	
func get_wall_position(direction : int) -> float:
	var wall = raycast_in_direction(1024, direction)
	if not wall:
		Log("Wall not detected, returning 1024")
		return 1024.0
	Log("Wall pos x " + str(wall["position"].x))
	return wall["position"].x

func get_x_relative_to_camera_center() -> float:
	return GameManager.camera.get_camera_screen_center().x - global_position.x 

func get_y_relative_to_camera_center() -> float:
	return GameManager.camera.get_camera_screen_center().y - global_position.y

func set_direction_relative_to_camera() -> void:
	var camera_center = GameManager.camera.get_camera_screen_center()
	if camera_center.x > global_position.x:
		set_direction(1)
	else:
		set_direction(-1)
	
func screenshake(value := 2.0):
	Event.emit_signal("screenshake", value)

func reset_decay(new_velocity := 0.0):
	if new_velocity == 0:
		decaying_speed = get_horizontal_velocity()
	else:
		decaying_speed = new_velocity
		

func decay_horizontal_speed(time := 10.0, delta := 0.016): #force_and_decay_horizontal_speed era pra ser o nome coreto
	decaying_speed = reduce_value_over_time(decaying_speed,delta,time)
	force_movement(decaying_speed)

func decay_vertical_speed(duration : float = 0.15) -> void:
	var tween = get_tree().create_tween()
	tween.tween_method(self,"set_vertical_speed",character.get_vertical_speed(),0.0,duration)

func reduce_value_over_time(value :float, delta := 0.016, inverse_duration_of_decay := 10.0, threshold := 5) -> float:
	if value > threshold:
		value -= value * delta * inverse_duration_of_decay
	elif value < -threshold:
													#Modifiquei para subtrair o valor, antes tava somando mesmo quando os dois eram negativos
		value -= value * delta * inverse_duration_of_decay #TODO: checar se as desacelerações do Yeti estão funcionando direito
	else:
		value = 0
	return value
	
func adjust_position_to_wall(adjustement := 20.0) -> void:
	character.global_position.x = get_forward_wall_position() - adjustement * character.get_facing_direction()

func shoot_towards_player(projectile) -> void:
	var shot = instantiate_projectile(projectile)
	var target_dir = Tools.get_player_angle(global_position)
	shot.set_horizontal_speed( 100 * target_dir.x)
	shot.set_vertical_speed( 100 * target_dir.y)

func fire(projectile, shot_position, _dir := 0, velocity_override := Vector2 (0,0)):
	#print_debug(name + ": Using deprecated method 'fire', use new system instead")
	var shot = projectile.instance()
	var direction
	if _dir != 0:
		direction = _dir
	else:
		direction = character.get_facing_direction()
	get_tree().current_scene.add_child(shot)
	shot.transform = global_transform
	shot.projectile_setup(direction, Vector2 (shot_position.x * direction, shot_position.y))
	if velocity_override.x != 0:
		shot.set_horizontal_speed(velocity_override.x)
	if velocity_override.y != 0:
		shot.set_vertical_speed(velocity_override.y)

func instantiate(scene : PackedScene) -> Node2D:
	var instance = scene.instance()
	get_tree().current_scene.add_child(instance,true)
	instance.set_global_position(global_position) 
	return instance
	
func instantiate_projectile(scene : PackedScene) -> Node2D:
	var projectile = instantiate(scene) 
	projectile.set_creator(self)
	projectile.initialize(-character.get_facing_direction())
	
	return projectile

func _Interrupt() -> void:
	kill_tweens(tween_list)
	._Interrupt()

func new_tween() -> SceneTreeTween:
	var tween = get_tree().create_tween()
	tween_list.append(tween)
	return tween

func kill_tweens(list) -> void:
	for tween in list:
		if tween.is_valid():
			tween.kill()

func deactivate(_d = null) -> void:
	.deactivate()
	emit_signal("deactivated")

func turn_player_towards_boss() -> void:
	var player = GameManager.player
	if player.get_direction() != -get_player_direction_relative():
		if player.get_direction() != 0:
			GameManager.player.animatedSprite.play("recover")
		GameManager.player.set_direction(-get_player_direction_relative(),true)
