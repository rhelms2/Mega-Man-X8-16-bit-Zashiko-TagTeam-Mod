extends Light2D
var timer: = 0.0
onready var bg2: Sprite = $"../bg2"
var tween: SceneTreeTween

var repeat_pulse_time: = 1.0

func _physics_process(delta: float) -> void :
	if bg2.visible:
		timer += delta
		if timer > repeat_pulse_time:
			if Achievements.got_all():
				repeat_pulse(bg2, Color("ea800a"), Color("3a083d"))
			else:
				repeat_pulse(bg2, Color("3a083d"))
			repeat_pulse_time = 3
			timer = 0

func repeat_pulse(object, _color = Color.blue, _color2 = null) -> void :
	object.scale = Vector2.ZERO
	object.modulate = _color
	
	if tween:
		tween.kill()
	tween = create_tween()
	tween.tween_property(object, "scale", Vector2(8, 8), 2)
	
	if not _color2:
		tween.set_ease(Tween.EASE_OUT)
		tween.tween_property(object, "modulate", Color.black, 2)
	else:
		tween.set_trans(Tween.TRANS_LINEAR)
		tween.set_parallel()
		tween.tween_property(object, "modulate", _color2, 2.5)
		tween.set_parallel(false)
		tween.tween_property(object, "modulate", Color.black, 0.5)
		
