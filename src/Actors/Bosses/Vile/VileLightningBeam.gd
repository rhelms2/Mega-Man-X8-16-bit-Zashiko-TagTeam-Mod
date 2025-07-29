class_name VileLightning extends Node2D

export  var frames: Array

export  var flicker_pattern: Array = [0.1, 0.1, 0.3, 0.1, 0.1]
export  var flicker_actions: Array = ["flick", "offlick", "flick", "offlick", "unflick"]

onready var line: Line2D = $line
onready var collision: AnimatedSprite = $line / finish
onready var ray: RayCast2D = $ray
onready var end: = $end
onready var area_2d: Area2D = $DamageOnTouch / area2D
onready var damage_on_touch: Node2D = $DamageOnTouch
onready var finish_particles: Particles2D = $finish_particles

var rotate_speed: int = 60
var executing: bool = false


func _ready() -> void :
	deactivate()

func prepare() -> void :
	finish_particles.emitting = true

func activate() -> void :
	set_physics_process(true)
	set_process(true)
	damage_on_touch.activate()
	line.visible = true
	executing = true

func finish() -> void :
	finish_particles.emitting = true
	deactivate()

func deactivate() -> void :
	set_physics_process(false)
	set_process(false)
	damage_on_touch.deactivate()
	line.visible = false
	executing = false

func flicker(repeats: int = 0) -> void :
	offlick()
	for child in get_children():
		if child is Timer:
			child.queue_free()
			
	if repeats <= 0:
		var total_time = 0.0
		for i in flicker_actions.size():
			total_time += flicker_pattern[i]
			Tools.timer(total_time, flicker_actions[i], self)
	else:
		var flick_time = flicker_pattern[0]
		var off_time = flicker_pattern[1]
		var unflick_time = flicker_pattern[2]
		var total_time = 0.0
		for i in range(repeats):
			total_time += flick_time
			Tools.timer(total_time, "flick", self)
			total_time += off_time
			Tools.timer(total_time, "offlick", self)
			total_time += unflick_time
			Tools.timer(total_time, "unflick", self)
	







func offlick() -> void :
	if executing:
		line.visible = false
		damage_on_touch.deactivate()

func flick() -> void :
	if executing:
		line.visible = true

func unflick() -> void :
	if executing:
		line.visible = true
		damage_on_touch.activate()

func _physics_process(_delta: float) -> void :
	if visible:
		if ray.is_colliding():
			set_line_position(to_local(ray.get_collision_point()))
		else:
			set_line_position(end.position)

func set_line_position(hit_position) -> void :
	line.points[1] = hit_position
	collision.position = hit_position
	area_2d.scale.y = hit_position.y

func _process(_delta: float) -> void :
	if visible:
		line.texture = frames[collision.frame]
