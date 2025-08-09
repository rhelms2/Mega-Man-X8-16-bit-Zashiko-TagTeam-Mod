extends KinematicBody2D

var velocity: = Vector2(20.2, 0)
const tile_size: = 16.0
export  var amplitude: = 2.0
export  var speed: = 30.0
export  var vertical: = false
var duration: = 1.0
onready var tween: = TweenController.new(self, false)
onready var original_pos: = position
export  var initial_direction: = 1

func _ready() -> void :
	if vertical:
		vertical_cycle()
	else:
		cycle()
	initial_direction = 0

func vertical_cycle() -> void :
	tween.end()
	if initial_direction > 0 or position.y < original_pos.y:
		tween.attribute("position:y", get_v_target(true), get_v_duration(true))
	else:
		tween.attribute("position:y", get_v_target(), get_v_duration())
	Tools.timer(duration, "vertical_cycle", self)
	

func cycle() -> void :
	tween.end()
	if initial_direction > 0 or position.x < original_pos.x:
		tween.attribute("position:x", get_target(true), get_duration(true))
	else:
		tween.attribute("position:x", get_target(), get_duration())
	Tools.timer(duration, "cycle", self)

func get_target(right: = false) -> float:
	if right:
		return original_pos.x + tile_size * amplitude
	return original_pos.x - tile_size * amplitude
	
func get_duration(right: = false) -> float:
	duration = abs(position.x - get_target(right)) / speed
	return duration
	
func get_v_target(right: = false) -> float:
	if right:
		return original_pos.y + tile_size * amplitude
	return original_pos.y - tile_size * amplitude
	
func get_v_duration(right: = false) -> float:
	duration = abs(position.y - get_v_target(right)) / speed
	return duration
