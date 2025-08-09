extends Area2D
class_name ActiveArea2D

export var active := true
export var group := "Everything"
export var exceptions : Array
export var debug_logs := false
var bodies = []

signal group_body_entered(body)
signal group_body_present(body)
signal group_body_exited(body)

func _physics_process(_delta: float) -> void:
	if active:
		for body in bodies:
			if is_instance_valid(body):
				emit_signal("group_body_present",body)
			else:
				bodies.erase(body)

func _on_area2D_body_entered(body: Node) -> void:
	if active:
		Log("Detected body: " + body.name)
		if is_in_matching_group(body):
			bodies.append(body)
			emit_signal("group_body_entered",body)
			set_physics_process(true)
			
			Log("Added to " + body.name)

func _on_area2D_body_exited(body: Node) -> void:
	Log("exiting body: " + str(body))
	if body in bodies:
		bodies.erase(body)
		emit_signal("group_body_exited",body)
		if bodies.size() == 0:
			set_physics_process(false)

func is_in_matching_group(body) -> bool:
	for exception in exceptions:
		if body.is_in_group(exception):
			return false
	return group == "Everything" or body.is_in_group(group)

func Log(message) -> void:
	if debug_logs:
		print(get_parent().name + "." + name + " :" + message)
