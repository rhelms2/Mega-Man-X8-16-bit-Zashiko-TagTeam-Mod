extends AnimatedSprite

onready var tween: = TweenController.new(self, false)
onready var label: Label = $"../label"

var last_dir: = 0
func _ready() -> void :
	pass


func _on_Cutman_new_direction(dir) -> void :
	if dir != last_dir:
		last_dir = dir
		tween.reset()
		scale.x = 0
		tween.attribute("scale:x", dir, 0.16)
		tween.set_ignore_pause_mode()
		label.text = str(last_dir)

