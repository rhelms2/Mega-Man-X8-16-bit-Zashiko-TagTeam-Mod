extends AttackAbility
onready var collision: AnimatedSprite = $"../animatedSprite/collision"
onready var line: Line2D = $"../animatedSprite/line"

func _Setup() -> void:
	pass

func _Update(_delta) -> void:
	var new_x = get_x_relative_to_camera_center()
	var new_y = get_y_relative_to_camera_center()
	var new_pos = Vector2 (new_x,new_y)
	collision.position = -new_pos/7
	line.points[1] = -new_pos/7
	if new_x > 0:
		collision.scale.x = 1
	else:
		collision.scale.x = -1

func check_for_event_errors() ->void:
	pass
