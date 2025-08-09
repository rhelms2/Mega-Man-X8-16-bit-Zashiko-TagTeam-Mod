extends NewAbility

export var horizontal_speed := 90.0
export var current_horizontal_speed := 90.0

onready var physics = Physics.new(get_parent())
onready var animation = AnimationController.new($"../animatedSprite", self)
onready var tween = TweenController.new(self)

func should_execute() -> bool:
	return active and character.ride.is_executing() and current_conflicts.size() == 0

func _StartCondition() -> bool:
	return not physics.is_on_floor()

func _Setup() -> void:
	handle_horizontal_speed()
	animation.play("fall")
	tween.method("set_horizontal_speed",physics.get_horizontal_speed(),0,0.35,physics)

func handle_horizontal_speed() -> void:
	current_horizontal_speed = horizontal_speed
	var h_speed = abs(physics.get_horizontal_speed())
	if h_speed > horizontal_speed:
		current_horizontal_speed = h_speed

func _Update(_delta) -> void:
	physics.process_gravity(_delta)

func _Interrupt() -> void:
	horizontal_speed = 90

func _EndCondition() -> bool:
	return physics.is_on_floor()

func _on_move_right() -> void:
	if is_executing():
		tween.reset()
		physics.set_direction(1)
		physics.set_horizontal_speed_towards_facing_direction(current_horizontal_speed)
	
func _on_move_left() -> void:
	if is_executing():
		tween.reset()
		physics.set_direction(-1)
		physics.set_horizontal_speed_towards_facing_direction(current_horizontal_speed)
		
func _on_move_release() -> void:
	if is_executing():
		physics.set_horizontal_speed(0)


func _on_knockback() -> void:
	if tween.is_valid():
		tween.reset()
		physics.set_horizontal_speed(0)

func _on_Jump_stop(ability_name) -> void:
	horizontal_speed = get_parent().get_node(ability_name).current_horizontal_speed
	pass # Replace with function body.
