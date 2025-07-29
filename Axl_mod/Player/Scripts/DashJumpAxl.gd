extends JumpAxl
class_name DashJumpAxl

export  var dash_action: String = "dash"

onready var dash: Node2D = $"../Dash"

var dash_leeway_time: float = 0.55


func _ready() -> void :
	if active:
		Event.listen("input_dash", self, "on_dash_press")

func _Setup() -> void :
	._Setup()
	emit_dashjump()
	dash_leeway_time = dash.dash_duration
	Event.emit_signal("dash")

func emit_dashjump() -> void :
	character.dashjump_signal()

func change_animation_if_falling(_s) -> void :
	if not changed_animation:
		if character.get_animation() != "fall":
			if character.get_vertical_speed() > 0:
				EndAbility()
				character.start_dashfall()

func _StartCondition() -> bool:
	if character.get_action_pressed(dash_action) and dash_input_not_too_long_ago(dash_leeway_time):
		return ._StartCondition()
	return false
