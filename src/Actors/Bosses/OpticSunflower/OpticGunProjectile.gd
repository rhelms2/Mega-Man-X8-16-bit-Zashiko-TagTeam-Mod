extends Node2D
const rotate_duration: = 0.75
const speed: = 150
var stop_positions = []
var starting_direction: = 0

onready var line: Line2D = $animatedSprite / line
onready var collision: AnimatedSprite = $animatedSprite / collision
onready var ray: RayCast2D = $rayCast2D
onready var collider: CollisionShape2D = $DamageOnTouch / area2D / collisionShape2D
onready var tween: = TweenController.new(self, false)
onready var damage_on_touch: Node2D = $DamageOnTouch
onready var animated_sprite: AnimatedSprite = $animatedSprite
onready var collision_noise: AudioStreamPlayer2D = $animatedSprite / collision / collision_noise

func _ready() -> void :
	rotation_degrees = 90
	Tools.timer(0.1, "activate", self)

func activate() -> void :
	line.visible = true
	collision.visible = true
	damage_on_touch.activate()
	collision_noise.play()
	go_to_first_stop_position()

func go_to_first_stop_position() -> void :
	var first_position = stop_positions[0]
	var distance = global_position.distance_to(Vector2(first_position, global_position.y))
	var travel_duration = distance / speed
	if not is_beyond_stop_position():
		tween.attribute("global_position:x", first_position, travel_duration)
		tween.add_callback("rotate_at_first_position")
	else:
		rotate_at_first_position()

func is_beyond_stop_position() -> bool:
	var position_direction: = 0
	if global_position.x > stop_positions[0]:
		position_direction = - 1
	else:
		position_direction = 1
	return starting_direction > 0 and position_direction < 0 or starting_direction < 0 and position_direction > 0

func rotate_at_first_position() -> void :
	if starting_direction < 0:
		tween.attribute("rotation_degrees", 270.0, rotate_duration)
	else:
		tween.attribute("rotation_degrees", - 90.0, rotate_duration)
		
	tween.add_callback("go_to_second_stop_position")

func go_to_second_stop_position() -> void :
	var second_position = stop_positions[1]
	var distance = global_position.distance_to(Vector2(second_position, global_position.y))
	var travel_duration = abs(distance) / speed
	tween.attribute("global_position:x", second_position, travel_duration)
	tween.add_callback("rotate_at_second_position")

func rotate_at_second_position() -> void :
	rotation_degrees = - 90
	if starting_direction < 0:
		tween.attribute("rotation_degrees", 90.0, rotate_duration)
	else:
		tween.attribute("rotation_degrees", - 270.0, rotate_duration)
	tween.add_callback("deactivate")

func deactivate() -> void :
	disappear_and_throw_leaves()
	Tools.timer(1.25, "queue_free", self)

func disappear_and_throw_leaves() -> void :
	rotation_degrees = 0
	animated_sprite.play("end")
	line.visible = false
	collision.visible = false
	animated_sprite.set_physics_process(false)
	damage_on_touch.deactivate()
	$leaves.emitting = true
	Tools.tween(collision_noise, "volume_db", - 80.0, 0.35)

func _physics_process(_delta: float) -> void :
	if ray.is_colliding():
		var distance = global_position.distance_to(ray.get_collision_point())
		line.points[1].x = abs(distance)
		collision.position.x = abs(distance)
		collider.scale.x = abs(distance) / 2
		collider.position.x = abs(distance) / 2
	
