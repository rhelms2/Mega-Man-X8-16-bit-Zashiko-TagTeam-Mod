extends NewBox


func _ready() -> void :
	Tools.timer(11.5, "destroy", self)

func _physics_process(delta: float) -> void :
	if active:
		if is_colliding_with_ground():
			process_horizontal_velocity(delta)
			collide_with_ground()
			return
		process_gravity(delta)
		process_vertical_velocity(delta)

func void_touch() -> void :
	destroy()

func deactivate_ground_checks_if_colliding_with_wall() -> void :
	pass

func process_horizontal_velocity(delta: float) -> void :
	global_position.x += - 35 * delta

func process_gravity(delta: float) -> void :
	velocity.y += 250 * delta

func _on_zero_health() -> void :
	collider.set_deferred("disabled", true)
	$kinematicBody2D / collisionShape2D.set_deferred("disabled", true)
	Tools.timer(1.5, "destroy", self)
