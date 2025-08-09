extends Node

const final_color: Color = Color(2, 2, 2, 1)

export  var interval: float = 0.21
export  var max_flashes: = - 1
export  var total_duration: float = 0.3

onready var tween: = TweenController.new(self, false)
onready var target: = get_parent()

var active: bool = false
var current_flashes: int = 0


func _ready() -> void :
	Event.connect("gateway_skip", self, "deactivate")
	Event.connect("full_reset_gateway", self, "deactivate")

func activate():
	if not active:
		active = true
		flash()

func flash():
	if active:
		if max_flashes > 0:
			if current_flashes >= max_flashes:
				current_flashes = 0
				return
		current_flashes += 1
		target.modulate = Color.white
		tween.attribute("modulate", final_color, total_duration / 3, target)
		tween.add_attribute("modulate", Color.white, total_duration / 3 * 2, target)
		Tools.timer(interval, "flash", self)

func hide():
	target.modulate = Color.white

func deactivate():
	active = false
	Tools.timer(interval * 2, "hide", self)
