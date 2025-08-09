extends SimpleProjectile

var ending := false
var last_speed : Vector2
var bounces := 0
var last_bounce := 0.0
const max_bounces := 8
const destroyer := true

var cutman : Node2D

func _Setup() -> void:
	var target_dir = Tools.get_player_angle(global_position)
	set_vertical_speed(target_dir.y * 320)
	set_horizontal_speed(target_dir.x * 320)

func _Update(_delta) -> void:
	if timer > .75:
		set_trajectory_towards_cutman()
		if cutman.global_position.distance_to(global_position) <= 16:
			Event.emit_signal("cutman_received")
			queue_free()

func set_trajectory_towards_cutman() -> void:
	var target_dir = get_cutman_angle()
	set_vertical_speed(target_dir.y * 320)
	set_horizontal_speed(target_dir.x * 320)
	pass

func explode() -> void:
	#disable_visuals()
	#deactivate()
	#set_rotation(0)
	hitparticle.emit()

func _OnHit(_d) -> void:
	#explode()
	pass
	#hitparticle.emit()
	#disable_visuals()

func get_cutman_angle() -> Vector2:
	return ((cutman.global_position + Vector2(0,5)) - global_position).normalized()

func _OnScreenExit() -> void: #override
	pass
