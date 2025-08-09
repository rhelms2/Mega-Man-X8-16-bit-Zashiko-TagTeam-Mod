extends NinePatchRect
var player = []



func _on_area2D_body_entered(body: Node) -> void:
	player.append(body)
	set_modulate(Color(1,1,1,0.25)) 
	pass # Replace with function body.


func _on_area2D_body_exited(body: Node) -> void:
	player.erase(body)
	set_modulate(Color(1,1,1,1)) 
	pass # Replace with function body.
