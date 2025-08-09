extends NewAbility

export  var speed: = 90.0
export  var final_position_y: = - 139.0
export  var destination_condition: = 0.0
var destination: Vector2
onready var map: = get_parent()
onready var tween: = TweenController.new(self)

func _ready() -> void :
	$"../../StageSelectUI".connect("picked_stage", self, "endtween")

func _on_reposition_map(pos) -> void :
	destination = pos
	_on_signal()

func _StartCondition() -> bool:
	if destination_condition == 0.0:
		return destination.y > 217
	else:
		return destination.y == destination_condition

func _Setup() -> void :
	tween.reset()
	tween.attribute("position:y", final_position_y, get_duration(final_position_y), map)
	tween.add_callback("EndAbility")

func _Interrupt() -> void :
	tween.reset()

func endtween() -> void :
	if executing:
		tween.end()

func get_duration(_final_position_y: float) -> float:
	var d = abs(map.position.y - _final_position_y) / speed
	return d
