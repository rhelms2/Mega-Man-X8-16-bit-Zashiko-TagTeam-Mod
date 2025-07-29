extends StaticBody2D

func _physics_process(_delta: float) -> void :
	if GameManager.get_player_position().y > global_position.y + 70:
		scale.x = 20
