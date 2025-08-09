extends KinematicBody2D

onready var collider: CollisionShape2D = $collisionShape2D

var player_inside_platform: = false
var player_in_surfzone: = false

var surf_timer: Timer

func enable_surfing():
	collider.set_deferred("disabled", false)
	surf_timer = Tools.timer_r(6, "surf_achievement", self)

func disable_surfing():
	collider.set_deferred("disabled", true)
	if is_instance_valid(surf_timer):
		surf_timer.queue_free()

func surf_achievement(_p = null):
	Achievements.unlock("SURFEDONMISSILE")


func _on_area2D_body_entered(body: Node) -> void :
	if is_player(body):
		player_inside_platform = true
		handle_collider_solidness()


func _on_area2D_body_exited(body: Node) -> void :
	if is_player(body):
		player_inside_platform = false
		handle_collider_solidness()


func _on_player_active_area_body_entered(body: Node) -> void :
	if is_player(body):
		player_in_surfzone = true
		handle_collider_solidness()


func _on_player_active_area_body_exited(body: Node) -> void :
	if is_player(body):
		player_in_surfzone = false
		handle_collider_solidness()

func handle_collider_solidness():
	if player_in_surfzone and not player_inside_platform:
		enable_surfing()
	else:
		disable_surfing()

func is_player(body) -> bool:
	return body.get_character().name == "X"
