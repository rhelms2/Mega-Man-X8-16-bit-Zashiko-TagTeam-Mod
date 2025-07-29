extends AbilityUser
class_name EnemyTransformed

onready var _player = GameManager.player
var listening_to_inputs: = true
export  var abilities: Array

export  var x_offset = 0
export  var y_offset = 0
var direction_copy: bool = true

onready var damage: = get_node("Damage")
var shield
export  var things_to_hide_on_death: Array

onready var wallcheck_left: = $_raycasts.get_node("Wallcheck Left")
onready var wallcheck_left2: = $_raycasts.get_node("Wallcheck Left2")
onready var wallcheck_left3: = $_raycasts.get_node("Wallcheck Left3")
onready var wallcheck_right: = $_raycasts.get_node("Wallcheck Right")
onready var wallcheck_right2: = $_raycasts.get_node("Wallcheck Right2")
onready var wallcheck_right3: = $_raycasts.get_node("Wallcheck Right3")
onready var cast_left = [wallcheck_left, wallcheck_left2, wallcheck_left3]
onready var cast_right = [wallcheck_right, wallcheck_right2, wallcheck_right3]

onready var walljumpcast_left: = $_raycasts.get_node("WallJumpCast Left")
onready var walljumpcast_left2: = $_raycasts.get_node("WallJumpCast Left2")
onready var walljumpcast_left3: = $_raycasts.get_node("WallJumpCast Left3")
onready var walljumpcast_right: = $_raycasts.get_node("WallJumpCast Right")
onready var walljumpcast_right2: = $_raycasts.get_node("WallJumpCast Right2")
onready var walljumpcast_right3: = $_raycasts.get_node("WallJumpCast Right3")
onready var jumpcast_left = [walljumpcast_left, walljumpcast_left2, walljumpcast_left3]
onready var jumpcast_right = [walljumpcast_right, walljumpcast_right2, walljumpcast_right3]
onready var low_jumpcasts = [walljumpcast_left3, walljumpcast_right3]

	
signal shield_hit
	
signal guard_break
signal external_event
	
signal got_hit
signal combo_hit(weapon)
signal crushed
signal damage_target


func _physics_process(_delta: float) -> void :
	if get_pressed_axis() != 0:
		animatedSprite.scale.x = get_pressed_axis()
		direction.x = animatedSprite.scale.x
	update_facing_direction()
	if _player != null:
		if _player.global_position.x != self.global_position.x + x_offset:
			_player.global_position.x = self.global_position.x + x_offset
		if _player.global_position.y != self.global_position.y + y_offset:
			_player.global_position.y = self.global_position.y + y_offset
		if _player.direction.x != self.direction.x:
			_player.direction.x = self.direction.x

func _ready() -> void :
	listen("zero_health", self, "_on_zero_health_hide_things")

func update_facing_direction():
	if animatedSprite.visible:
		if direction.x < 0:
			facing_right = false;
		elif direction.x > 0:
			facing_right = true;
		direction.x = animatedSprite.scale.x

func get_pressed_axis() -> int:
	var axis = 0
	if get_action_pressed("move_left"):
		axis = axis - 1
	if get_action_pressed("move_right"):
		axis = axis + 1
	return axis

func get_action_pressed(action) -> bool:
	if listening_to_inputs:
		return Input.is_action_pressed(action)
	return false

func crush() -> void :
	current_health = 0
	emit_signal("crushed")

func process_zero_health():
	if not has_health():
		if not emitted_zero_health:
			emit_zero_health_signal()

func _on_zero_health_hide_things() -> void :
	for nodepath in things_to_hide_on_death:
		get_node(nodepath).visible = false
	

func is_colliding_with_wall(wallcheck_distance: = 8, vertical_correction: = 8) -> int:
	if raycast(Vector2(global_position.x + wallcheck_distance, global_position.y + vertical_correction)):
		return 1
	elif raycast(Vector2(global_position.x - wallcheck_distance, global_position.y + vertical_correction)):
		return - 1
	
	return 0
	
func raycast(target_position: Vector2) -> Dictionary:
	var space_state = get_world_2d().direct_space_state
	return space_state.intersect_ray(global_position, target_position, [self], collision_mask)

func interrupt_all_moves():
	for move in executing_moves:
		move.EndAbility()

func has_shield() -> bool:
	if shield != null:
		return shield.active
	else:
		return false

func get_shield() -> Node2D:
	return shield

func direct_hit(value) -> void :
	damage.direct_hit(value)

func on_external_event() -> void :
	
	emit_signal("external_event")

func got_combo_hit(inflicter) -> void :
	emit_signal("combo_hit", inflicter)


var area_collider: CollisionShape2D
func get_collider_area() -> CollisionShape2D:
	if not area_collider:
		area_collider = get_node_or_null("collisionShape2D")
	return area_collider
	
func _is_single_colliding_with_wall() -> int:
	if wallcheck_right:
		if _single_check_for_normal(wallcheck_right, Vector2( - 1, 0)):
			return 1
	if wallcheck_left:
		if _single_check_for_normal(wallcheck_left, Vector2(1, 0)):
			return - 1
	return 0
	
func _single_check_for_normal(raycast, expected_normal: Vector2) -> bool:
	if raycast != null:
		if raycast.is_colliding():
			var collision_normal = raycast.get_collision_normal()
			if collision_normal.dot(expected_normal) > 0.9:
				return true
	return false
	
func _is_colliding_with_wall() -> int:
	for cast in cast_right:
		if _check_for_normal(cast, - 1):
			return 1
	for cast in cast_left:
		if _check_for_normal(cast, 1):
			return - 1
	return 0

func _check_for_normal(raycast, normal: int, angle_range: = 0.25) -> bool:
	if raycast != null:
		if raycast.is_colliding():
			if raycast.get_collision_normal().x > normal - angle_range:
				if raycast.get_collision_normal().x < normal + angle_range:
					return true
	return false

func _on_GravityPassage_opened() -> void :
	current_health = 0
	pass

