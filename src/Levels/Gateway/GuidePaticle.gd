extends Node2D
var _destination: Node2D
onready var tween: = TweenController.new(self, false)
onready var particles_2d: Particles2D = $particles2D
onready var line_2d: Line2D = $node / line2D

func _ready() -> void :
	var final_pos = _destination.global_position
	tween.create(Tween.EASE_IN, Tween.TRANS_QUAD)
	tween.add_attribute("global_position", final_pos, 2.0)
	tween.add_callback("end")

func end() -> void :
	particles_2d.emitting = false
	tween.attribute("modulate:a", 0.0, 1.0)
	tween.attribute("modulate:a", 0.0, 1.0, line_2d)
	Tools.timer(1, "queue_free", self)
