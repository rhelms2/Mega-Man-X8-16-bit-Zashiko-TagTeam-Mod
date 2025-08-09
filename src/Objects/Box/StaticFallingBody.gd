extends StaticBody2D
class_name NewBox

export  var debug: bool = false
export  var active: bool = true
export  var gravity: bool = true
export  var timer: float = 0.0

onready var ground_check: RayCast2D = $ground_check
onready var ground_check_2: RayCast2D = $ground_check2
onready var ground_check_3: RayCast2D = $ground_check3
onready var left_wall_check: RayCast2D = $left_wall_check
onready var right_wall_check: RayCast2D = $right_wall_check
onready var collider: CollisionShape2D = $collisionShape2D

var velocity: Vector2 = Vector2.ZERO
var on_ground: bool = false
var ground_checked

signal activated
signal falling
signal landed
signal deactivated


func _physics_process(delta: float) -> void :
	if active:
		deactivate_ground_checks_if_colliding_with_wall()
		process_horizontal_velocity(delta)
		if is_colliding_with_ground():
			collide_with_ground()
			return
		else:
			process_gravity(delta)
		process_vertical_velocity(delta)

func deactivate_ground_checks_if_colliding_with_wall() -> void :
	ground_check.enabled = not left_wall_check.is_colliding()
	ground_check_2.enabled = not right_wall_check.is_colliding()

func is_colliding_with_ground() -> bool:
	for check in [ground_check, ground_check_2, ground_check_3]:
		if check.is_colliding():
			ground_checked = check
			return true
	return false

func process_gravity(delta: float) -> void :
	if gravity:
		velocity.y += 750 * delta
		if on_ground:
			on_ground = false
			emit_signal("falling")
			Log("Falling")

func process_vertical_velocity(delta: float) -> void :
	if velocity.y != 0:
		velocity.y = clamp(velocity.y, - 375, 375)
		global_position.y += velocity.y * delta

func process_horizontal_velocity(delta: float) -> void :
	if velocity.x != 0:
		global_position.x += velocity.x * delta

func add_conveyor_belt_speed(speed: float) -> void :
	velocity.x += speed
func reduce_conveyor_belt_speed(speed: float):
	velocity.x -= speed

func collide_with_ground() -> void :
	velocity.y = 0
	global_position.y = ground_checked.get_collision_point().y - 23
	if not on_ground:
		emit_signal("landed")
		Log("landed")
		on_ground = true

func activate() -> void :
	active = true
	emit_signal("activated")

func deactivate() -> void :
	active = false
	emit_signal("deactivated")

func _on_zero_health() -> void :
	collider.set_deferred("disabled", true)
	Tools.timer(1.5, "destroy", self)
	deactivate()

func destroy() -> void :
	queue_free()

func void_touch() -> void :
	destroy()

func Log(message) -> void :
	if debug:
		print(name + ": " + str(message))
