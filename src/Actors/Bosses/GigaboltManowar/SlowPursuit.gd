extends AttackAbility

func _ready() -> void:
	Event.listen("jellyfish_start",self,"start")

func start() -> void:
	var target_direction = (GameManager.get_player_position() - global_position).normalized()
	force_movement_regardless_of_direction(horizontal_velocity * target_direction.x)
	set_vertical_speed(horizontal_velocity * target_direction.y)


