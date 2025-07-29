extends ParallaxLayer



func _ready() -> void :
	pass


func _on_area2D_body_entered(body: Node) -> void :
	motion_offset = Vector2(310, - 40)
