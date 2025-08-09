extends Node
const sequence := [[2],[1,3],[2],[1],[3]]
export var lumine_version := false
export var projectile : PackedScene
var center : Vector2
var current_position := 0
var spawn_positions : Array
var floor_position : float
onready var character: KinematicBody2D = $"../.."

func _on_start_desperation() -> void:
	#if lumine_version:
	var space = $"../../Space"
	center = space.center + Vector2(0,-32)
	floor_position = space.platform_height  - 28
	#else:
	#	center = $"../../GravitySummon".center - Vector2(0,80)
	#	floor_position = character.global_position.y - 28
	create_boxes()

func create_box (box_position : int) -> void:
	var p = projectile.instance()
	get_tree().current_scene.add_child(p,true)
	p.global_position = get_spawn_position(box_position)
	p.floor_position = floor_position

func create_boxes() -> void:
	if character.has_health():
		for box_position in sequence[current_position]:
			create_box(box_position)
		increase_current_position()
		Tools.timer(1.0,"create_boxes",self)

func get_spawn_position(index : int) -> Vector2:
	if index == 1:
		return center - Vector2(80,0)
	elif index == 3:
		return center + Vector2(80,0)
	return center

func increase_current_position() -> void:
	current_position += 1
	if current_position > sequence.size() -1:
		current_position = 0
	
