extends KinematicBody2D

export  var active: = true
var velocity: = Vector2.ZERO
var landed_interval: = 0.0
var ground_checked

onready var ground_check: RayCast2D = $ground_check
onready var ground_check_2: RayCast2D = $ground_check2
onready var ground_check_3: RayCast2D = $ground_check3

onready var collider: CollisionShape2D = $collisionShape2D

signal activated
signal landed
signal deactivated

func _physics_process(delta: float) -> void :
	if active:
		process_horizontal_velocity(delta)
		if is_colliding_with_ground():
			collide_with_ground()
			return
		process_gravity(delta)
		process_vertical_velocity(delta)
		process_landed(delta)

func is_colliding_with_ground() -> bool:
	for check in [ground_check, ground_check_2, ground_check_3]:
		if check.is_colliding():
			ground_checked = check
			return true
	return false

func process_gravity(delta: float) -> void :
	velocity.y += 750 * delta

func process_vertical_velocity(delta: float) -> void :
	velocity.y = clamp(velocity.y, - 375, 375)
	
	global_position.y += velocity.y * delta
	
func process_horizontal_velocity(delta: float) -> void :
	global_position.x += velocity.x * delta

func add_conveyor_belt_speed(speed: float) -> void :
	velocity.x += speed
func reduce_conveyor_belt_speed(speed: float):
	velocity.x -= speed
	
func process_landed(delta: float) -> void :
	landed_interval += delta

func collide_with_ground() -> void :
	velocity.y = 0
	global_position.y = ground_checked.get_collision_point().y - 23
	if landed_interval > 0.35:
		emit_signal("landed")
	landed_interval = 0

func activate() -> void :
	active = true
	emit_signal("activated")

func deactivate() -> void :
	active = false
	emit_signal("deactivated")

func _on_zero_health() -> void :
	collider.set_deferred("disabled", true)
	Tools.timer(1.5, "destroy", self)

func destroy() -> void :
	queue_free()

func _ready() -> void :
	pass
