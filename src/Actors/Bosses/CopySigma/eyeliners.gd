extends Node2D

onready var tween := TweenController.new(self,false)
onready var line: Line2D = $line2D
onready var ray: RayCast2D = $rayCast2D
onready var collision: AnimatedSprite = $collision
export var positions := [-75,55,-35,10]
var direction := 1

func _ready() -> void:
	visible = false

func start_eyes(facing_direction := -1) -> void:
	direction = facing_direction
	ray.enabled = true
	ray.rotation_degrees = -positions[0] * direction
	set_physics_process(true)
	Tools.timer(0.02,"make_visible",self)
	Tools.timer(0.35,"rotate_eyes",self)

func make_visible():
	visible = true

func rotate_eyes() -> void:
	tween.create(Tween.EASE_IN_OUT,Tween.TRANS_CUBIC)
	tween.add_attribute("rotation_degrees",positions[0] * direction,.7,ray)
	tween.add_attribute("rotation_degrees",positions[1] * direction,.67,ray)
	tween.add_attribute("rotation_degrees",positions[2] * direction,.57,ray)
	tween.add_attribute("rotation_degrees",positions[3] * direction,.47,ray)

func end():
	set_physics_process(false)
	visible = false

func _physics_process(_delta: float) -> void:
	synchronize_line()

func synchronize_line() -> void:
	if ray.is_colliding():
		#var distance = global_position.distance_to(ray.get_collision_point())  
		line.points[0] = to_local(ray.get_collision_point())
		collision.position = to_local(ray.get_collision_point())
