extends Node2D

export  var minimum_speed_for_explosion: = 320.0
var weapons: = ["OpticShieldCharged", "FireDashCharged", "CrystalBouncerCharged"]
var exploded: = false

var current_bikes: Array
func _on_area2D_body_entered(body: Node) -> void :
	if exploded:
		return
	if is_bike(body):
		current_bikes.append(body.get_parent())
		set_physics_process(true)
	elif is_charged_required_weapon(body):
		explode()

func _on_area2D_body_exited(body: Node) -> void :
	if is_bike(body):
		current_bikes.erase(body.get_parent())
		if current_bikes.size() <= 0:
			set_physics_process(false)

func _physics_process(_delta: float) -> void :
	if exploded:
		set_physics_process(false)
		return
	for b in current_bikes:
		if is_bike_over_minimum_speed(b):
			explode()
			set_physics_process(false)

func is_bike(body: Node) -> bool:
	return "RideChaser" in body.get_parent().name

func is_bike_over_minimum_speed(bike: Node) -> bool:
	if bike.global_position.x < global_position.x:
		return bike.actual_speed > minimum_speed_for_explosion
	return bike.actual_speed < - minimum_speed_for_explosion

func is_charged_required_weapon(body: Node) -> bool:
	for n in weapons:
		if body.name == n:
			return true
	return false

func explode() -> void :
	if exploded:
		return
	exploded = true
	$EnemyShield.deactivate()
	Event.emit_signal("screenshake", 2.0)
	$"Explosion Particles".emitting = true
	$remains_particles.emitting = true
	Tools.timer(1.0, "stop_exploding", self)
	$icebreak.play()
	$animatedSprite.visible = false
	$animatedSprite2.visible = false
	$animatedSprite3.visible = false
	$particles2D.emitting = false
	$staticBody2D / collisionShape2D.set_deferred("disabled", true)
	pass
func stop_exploding() -> void :
	$"Explosion Particles".emitting = false




func _on_teleport_start() -> void :
	queue_free()
	pass
