extends Sprite
class_name SigmaFlash

export  var initial_alpha: float = 0.5
export  var initial_scale: float = 5.0
export  var tween_scale_y: bool = true
export  var initial_color: Color = Color.white
export  var final_color: Color = Color(0.75, 0.6, 0.9, 1.0)
export  var duration: float = 0.2
export  var flip_chance: bool = false

onready var tween_brightness: TweenController = TweenController.new(self, false)


func _ready() -> void :
	visible = false

func start() -> void :
	if flip_chance:
		flip_h = randf() > 0.5
		flip_v = randf() > 0.5
	tween_brightness.reset()
	visible = true
	scale.y = initial_scale
	modulate = Color(initial_color.r, initial_color.g, initial_color.b, initial_alpha)
	tween_brightness.create()
	tween_brightness.set_parallel()
	tween_brightness.set_ignore_pause_mode()
	tween_brightness.add_attribute("modulate", Color(final_color.r, final_color.g, final_color.b, 0.0), duration)
	if tween_scale_y:
		tween_brightness.add_attribute("scale:y", 0.5, duration)
