extends WalkAxl
var shooting: bool = false

func shooting():
	shooting = true
	
func not_shooting():
	shooting = false

func _ready() -> void :
	._ready()
	Event.connect("is_shooting", self, "shooting")
	Event.connect("is_not_shooting", self, "not_shooting")
	
func _Update(_delta: float) -> void :
	var _shot_dir = get_parent().get_node("ShotDirection")
	var _animation = get_parent().get_animation()
	if shooting:
		set_movement_and_direction(0)
	else:
		if character.get_animation() != "walk_start" and character.get_animation() != "walk":
			character.play_animation("walk_start")
		if timer < 0.08 and starting_from_stop:
			set_movement_and_direction(horizontal_velocity / 4)
		else:
			set_movement_and_direction(horizontal_velocity)
	update_bonus_horizontal_only_conveyor()


func get_pressed_direction() -> int:
	return less_buggy_pressed_dir

var less_buggy_pressed_dir: = 0
func _input(event: InputEvent) -> void :
	if event.is_action_pressed("right_emulated"):
		less_buggy_pressed_dir = 1
	elif event.is_action_released("right_emulated"):
		less_buggy_pressed_dir = 0
	if event.is_action_pressed("left_emulated"):
		less_buggy_pressed_dir = - 1
	elif event.is_action_released("left_emulated"):
		less_buggy_pressed_dir = 0

