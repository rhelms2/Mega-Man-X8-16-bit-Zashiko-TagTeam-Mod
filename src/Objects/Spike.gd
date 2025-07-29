extends Area2D
class_name InstantDeathArea

export  var active: bool = true
export  var type: String = "spike"

var bodies: Array = []


func affect(body: Node) -> void :
	if body.has_method(type + "_touch"):
		body.call(type + "_touch")
	elif type == "void" and body.is_in_group("Enemies"):
		body.get_parent().destroy()

func _physics_process(_delta: float) -> void :
	if active:
		for body in bodies:
			if is_instance_valid(body):
				affect(body)
			else:
				bodies.erase(body)
	if bodies.size() == 0:
		set_physics_process(false)

func _on_area2D_body_entered(body: Node) -> void :
	if active:
		if body.is_in_group("Player"):
			set_physics_process(true)
			bodies.append(body.get_parent())

func _on_area2D_body_exited(body: Node) -> void :
	bodies.erase(body.get_parent())
	if bodies.size() == 0:
		set_physics_process(false)

func deactivate(_s = null) -> void :
	if active:
		active = false
		set_physics_process(false)
		$collisionShape2D.set_deferred("disabled", true)
