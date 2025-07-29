extends Node
onready var title_intro: Node = $"../title_card_intro"
onready var bg: Sprite = $bg
onready var bg2: Sprite = $bg2
onready var bg3: Sprite = $bg3
onready var xx: Sprite = $xx

var timer: = 0.0
var total_time: = 0.0
var step: = - 1
var tween
var pulse_tween
var active: = false

func _ready() -> void :
	set_physics_process(false)
	var parent = get_node_or_null("../..")
	if parent.name == "CapcomLogo":
		parent.connect("finished", self, "start")
		
	else:
		set_physics_process(true)
		start()
		get_parent().play_theme()
		
func next_step() -> void :
	step += 1
	timer = 0
	

func start() -> void :
	set_physics_process(true)
	active = true
	step = 0
	total_time = 0

func _physics_process(delta: float) -> void :
	timer += delta
	total_time += delta
	if step == 0 and total_time > 0.5:
		pulse(xx)
		next_step()
	elif step == 1 and total_time > 2:
		light(bg3, Color.indigo)
		next_step()
	elif step == 2 and total_time > 3.15:
		pulse(xx)
		next_step()
	elif step == 3 and total_time > 4.65:
		light(bg2, Color.firebrick)
		next_step()
	elif step == 4 and total_time > 5.8:
		xx.visible = false
		pulse(bg, Color.blue, Vector2(16, 16), false, 6, 3)
		next_step()
	elif step == 5 and total_time > 7.3:
		fade(bg3)
		next_step()
	elif step == 6 and timer > 1:
		fade(bg2)
		next_step()
	elif step == 7 and timer > 1:
		fade(bg, pulse_tween)
		next_step()
	elif step == 8 and total_time > 11:
		title_intro.set_physics_process(true)
		next_step()
	elif step == 9 and total_time > 21:
		if Achievements.got_all():
			repeat_pulse(bg2, Color("70310a"))
		else:
			repeat_pulse(bg2, Color("3a083d"))
		next_step()
	elif step == 10 and timer > 3:
		if Achievements.got_all():
			repeat_pulse(bg2, Color("70310a"))
		else:
			repeat_pulse(bg2, Color("3a083d"))
				
		timer = 0

func pulse(object, color = Color.blue, scale: = Vector2(16, 16), fade: = true, duration = 1, tween_dur = 1, _kill = false) -> void :
	object.scale = Vector2.ZERO
	object.modulate = color
	object.visible = true
	pulse_tween = create_tween()
	pulse_tween.tween_property(object, "scale", scale, tween_dur).set_ease(Tween.EASE_OUT)
	if fade:
		pulse_tween.tween_property(object, "modulate", Color.black, duration)
func alt_pulse(object, color = Color.blue, fade: = true, duration = 1, tween_dur = 1, _kill = false) -> void :
	object.scale = Vector2.ZERO
	object.modulate = color
	object.visible = true
	var tw = create_tween()
	tw.tween_property(object, "scale", Vector2(8, 8), tween_dur).set_ease(Tween.EASE_OUT)
	if fade:
		tw.tween_property(object, "modulate", Color.black, duration)

func repeat_pulse(object, color = Color.blue) -> void :
	object.scale = Vector2.ZERO
	object.modulate = color
	object.visible = true
	if tween:
		tween.kill()
	tween = create_tween()
	tween.tween_property(object, "scale", Vector2(8, 8), 2).set_ease(Tween.EASE_OUT)
	tween.tween_property(object, "modulate", Color.black, 2)


func fade(object, _tween = null) -> void :
	object.visible = true
	if _tween:
		_tween.kill()
	var t = create_tween()
	t.tween_property(object, "modulate", Color.black, 1)

func light(object, color = Color.blue) -> void :
	object.scale = Vector2.ZERO
	object.modulate = color
	object.visible = true
	if tween:
		tween.kill()
	tween = create_tween()
	tween.tween_property(object, "scale", Vector2(6, 6), 2).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)

