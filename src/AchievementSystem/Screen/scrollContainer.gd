extends ScrollContainer

onready var tween := TweenController.new(self,false)

var moving := 0

func _ready() -> void:
	pass

func _input(event: InputEvent) -> void:
	if is_pressed(event,["move_up","analog_up","ui_up"]):
		if moving != 1:
			tween.reset()
			tween.create(Tween.EASE_IN,Tween.TRANS_SINE)
			tween.add_attribute("scroll_vertical",scroll_vertical - 10000,10.0)
			moving = 1

	elif is_pressed(event,["move_down","analog_down","ui_down"]):
		if moving != -1:
			tween.reset()
			tween.create(Tween.EASE_IN,Tween.TRANS_SINE)
			tween.add_attribute("scroll_vertical",scroll_vertical + 10000,10.0)
			moving = -1
	elif is_released(event,["move_up","analog_up","ui_up","move_down","analog_down","ui_down"]):
		tween.reset()
		moving = 0

func is_pressed(event,actions) -> bool:
	for action in actions:
		if event.is_action_pressed(action):
			return true
	return false
	
func is_released(event,actions) -> bool:
	for action in actions:
		if event.is_action_released(action):
			return true
	return false
