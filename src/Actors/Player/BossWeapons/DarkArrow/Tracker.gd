extends Area2D

export  var active: bool = true

var targets: Array


func get_closest_target() -> Node2D:
	if active:
		var closest_target
		var invalid_targets = []
		for target in targets:
			if is_valid_target(target):
				if not closest_target:
					closest_target = target_or_center(target)
				else:
					if get_dist(target) < get_dist(closest_target):
						closest_target = target_or_center(target)
			else:
				invalid_targets.append(target)
		for object in invalid_targets:
			targets.erase(object)
		return closest_target
	return null

func disable() -> void :
	pass

func target_or_center(target) -> Node2D:
	var actual_center = target.get_node_or_null("actual_center")
	if actual_center != null:
		return actual_center
	return target

func is_valid_target(target) -> bool:
	if "Lamp" in target.name:
		return true
	if not is_instance_valid(target):
		return false
	if target.current_health <= 0:
		return false
	return true

func get_dist(object) -> float:
	return abs(global_position.distance_to(object.global_position))

func get_distance(object) -> Vector2:
	var actual_center = object.get_node_or_null("actual_center")
	if actual_center != null:
		return Vector2(abs(global_position.x - actual_center.global_position.x), abs(global_position.y - actual_center.global_position.y))
	return Vector2(abs(global_position.x - object.global_position.x), abs(global_position.y - object.global_position.y))

func _on_tracker_body_entered(body: Node) -> void :
	if active:
		targets.append(body)

func _on_tracker_body_exited(body: Node) -> void :
	targets.erase(body)
