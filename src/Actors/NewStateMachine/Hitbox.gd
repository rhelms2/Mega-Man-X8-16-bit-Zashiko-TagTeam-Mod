extends Area2D

export  var active: = true
export  var group: = "Everything"
var active_objects: Array

signal group_body_entered(body)
signal group_body_inside(body)
signal group_body_exited(body)

func _on_Hitbox_body_entered(body: Node) -> void :
	if active:
		if group == "Everything" or body.is_in_group(group):
			active_objects.append(body)
			emit_signal()

func _on_Hitbox_body_exited(body: Node) -> void :
	if body in active_objects:
		active_objects.erase(body)
