extends Area2D
export  var active: = true
var done: = false
var box_list: Array
var rotator_list: Array
var enemies_to_activate: Array

func _ready() -> void :
	for child in get_parent().get_children():
		var rotator = child.get_node_or_null("rotator")
		if child is NewBox:
			child.active = false
			child.gravity = false
			box_list.append(child)
		elif child is Enemy:
			child.active = false
			child.set_physics_process(false)
			enemies_to_activate.append(child)
		if rotator != null:
			rotator.active = false
			rotator_list.append(rotator)

func _on_body_entered(body: Node) -> void :
	if active and not done and body.name == CharacterManager.current_player_character:
		done = true
		Tools.timer_p(0.02, "reparent", self, body)
		Tools.timer(0.03, "activate_boxes", self)
		Tools.timer(0.03, "activate_rotators", self)
		Tools.timer(0.03, "activate_enemies", self)

func activate_boxes() -> void :
	for box in box_list:
		box.active = true
		box.gravity = true
	
func activate_rotators() -> void :
	for rotator in rotator_list:
		if is_instance_valid(rotator):
			rotator.active = true

func reparent(body: Node) -> void :
	var gp = body.global_position
	body.get_parent().remove_child(body)
	get_parent().call_deferred("add_child", body)
	body.set_deferred("rotation_degrees", 0.0)
	Event.emit_signal("unrotate")
	body.set_deferred("global_position", gp)

func activate_enemies() -> void :
	for enemy in enemies_to_activate:
		enemy.visible = true
		enemy.active = true
		enemy.set_physics_process(true)
