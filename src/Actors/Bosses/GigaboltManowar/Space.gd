extends Node

export var define_at_start := true
export(int, "UnclimbableWalls", "RegularWalls", "BaseOnCamera") var wall_check
export var border_distance := 32
export var low_height_segments := 1
var arena_pos := Vector2.ZERO
var arena_size := Vector2.ZERO
var platform_height := 0.0
var positions := [Vector2.ZERO,Vector2.ZERO,Vector2.ZERO,Vector2.ZERO]
var center : = Vector2.ZERO
var collision_layer := 256
export var center_offset := 0.0
onready var character = get_parent()

func _ready() -> void:
	if define_at_start:
		call_deferred("define_arena")
	if wall_check == 1:
		collision_layer = 1

func define_arena() -> void:
	define_platform_height()
	if wall_check == 2:
		define_boundaries_based_on_camera()
	else:
		define_horizontal_bondaries()
		define_vertical_bondaries()
	define_positions()

func define_platform_height() -> void:
	platform_height = Tools.raycast(character, Vector2(0,1024),null,1)["position"].y

func get_closest_position() -> Vector2:
	var closest_position = positions[0]
	
	for pos in positions:
		if character.global_position.distance_squared_to(pos) < character.global_position.distance_squared_to(closest_position):
			closest_position = pos
	return closest_position

func get_farthest_position() -> Vector2:
	var closest_position = positions[0]
	
	for pos in positions:
		if character.global_position.distance_squared_to(pos) > character.global_position.distance_squared_to(closest_position):
			closest_position = pos
	return closest_position

func get_position(index) -> Vector2:
	var correct_index = clamp(index,0,positions.size() -1)
	return positions[correct_index]

func get_random_position(current_position := Vector2.ZERO) -> Vector2:
	var rng = round(randf() * positions.size() -1)
	if positions[rng].x == current_position.x:
		rng += 1
	if rng > positions.size() -1:
		rng = 0
	return positions[rng]

func time_to_position(pos : Vector2, speed:= 100.0) -> float:
	return character.global_position.distance_to(pos)/speed

func get_platform() -> float:
	return platform_height

func get_bottom() -> float:
	return arena_pos.y + arena_size.y

func get_center() -> Vector2: #returns center with offset
	return center + Vector2(0,center_offset)

func define_positions() -> void:
	var segment := Vector2(round(arena_size.x/6),round(arena_size.y/4))
	positions[0] = Vector2(arena_pos.x, arena_pos.y)
	positions[1] = Vector2(arena_pos.x + segment.x, arena_pos.y + segment.y * low_height_segments)
	positions[2] = Vector2(arena_pos.x + 5*segment.x, arena_pos.y + segment.y * low_height_segments)
	positions[3] = Vector2(arena_pos.x + 6*segment.x, arena_pos.y)
	center = Vector2(arena_pos.x + arena_size.x/2, arena_pos.y)

func define_boundaries_based_on_camera() -> void:
	var camera_center = GameManager.camera.get_camera_screen_center()
	var screen_size = Vector2((398/2),(224/2))
	arena_pos.x = camera_center.x - screen_size.x + border_distance
	arena_size.x = (camera_center.x + screen_size.x - border_distance) - arena_pos.x
	
	arena_pos.y = camera_center.y - screen_size.y + border_distance
	arena_size.y = (camera_center.y + screen_size.y - border_distance) - arena_pos.y
	
	
func define_horizontal_bondaries() -> void:
	var boundaries := Vector2.ZERO
	var ray_left = Tools.raycast(character, Vector2(-1024,0),null,collision_layer)
	var ray_right = Tools.raycast(character, Vector2(1024,0),null,collision_layer)
	if ray_left:
		boundaries.x = ray_left["position"].x
	else:
		push_error("Raycast didn't find nothing")
	if ray_right:
		boundaries.y = ray_right["position"].x
	else:
		push_error("Raycast didn't find nothing")
	arena_pos.x = boundaries.x + border_distance
	arena_size.x = (boundaries.y - border_distance) - arena_pos.x
	
func define_vertical_bondaries() -> void:
	var boundaries := Vector2.ZERO
	boundaries.x = Tools.raycast(character, Vector2(0,-1024),null,collision_layer)["position"].y
	boundaries.y = Tools.raycast(character, Vector2(0,1024),null,collision_layer)["position"].y
	arena_pos.y = boundaries.x + border_distance
	arena_size.y = (boundaries.y - border_distance) - arena_pos.y
	
