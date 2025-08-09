extends AnimatedMirror


func _ready() -> void :
	call_deferred("set_materials")

func set_materials():
	if is_instance_valid(GameManager.player):
		if GameManager.player.name == "X":
			material = GameManager.player.animatedSprite.get_child(0).material

func _on_signal() -> void :
	var armor = GameManager.player.get_armor_sprites()
	for piece in armor:
		if piece.name == name:
			visible = piece.visible
