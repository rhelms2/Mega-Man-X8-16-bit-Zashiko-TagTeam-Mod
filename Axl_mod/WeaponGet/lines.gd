extends Node2D

export  var start_on_ready: = false
onready var tween: = TweenController.new(self, false)
export  var initial_color: Color
export  var middle_color: Color
export  var middle_color2: Color
export  var final_color: Color
export  var duration: = 4.0
export  var scale_change: = Vector2(0.25, 5.0)
var line_color: = Color(1, 1, 1, 0)
onready var h_line: Line2D = $HLine
onready var v_line: Line2D = $VLine
export  var ignore_pause: = true
signal delayed_signal

func _ready() -> void :
	create_lines()
	if start_on_ready:
		start_loop()
	Tools.timer_p(2.0, "emit_signal", self, "delayed_signal")

func create_lines():
	var i: = 0
	while i < 40:
		var new_h_line = h_line.duplicate()
		new_h_line.position.y += 40.0 * i
		add_child(new_h_line)
		i += 1
		
	i = 0
	while i < 40:
		var new_v_line = v_line.duplicate()
		add_child(new_v_line)
		new_v_line.position.x += 40.0 * i
		i += 1
	
func start_loop() -> void :
	tween.reset()
	tween.create(Tween.EASE_OUT, Tween.TRANS_QUAD, false, - 1)
	if ignore_pause:
		tween.set_ignore_pause_mode()
	tween.add_attribute("scale", Vector2(scale_change.x, scale_change.x), 0.01)
	tween.add_attribute("scale", Vector2(scale_change.y, scale_change.y), duration)
	
	tween.create(Tween.EASE_IN_OUT, Tween.TRANS_LINEAR, false, - 1)
	if ignore_pause:
		tween.set_ignore_pause_mode()
	tween.add_attribute("line_color", initial_color, 0.01)
	tween.add_attribute("line_color", middle_color, duration / 4)
	tween.add_attribute("line_color", middle_color2, duration / 4)
	tween.add_attribute("line_color", final_color, duration / 2)

func appear() -> void :
	visible = true
	
func disappear() -> void :
	visible = false

func define_color_via_weapon(current_weapon: WeaponResource) -> void :
	initial_color = current_weapon.MainColor2
	initial_color.a = 0
	middle_color = current_weapon.MainColor1
	middle_color2 = current_weapon.MainColor5
	final_color = current_weapon.MainColor5
	final_color.a = 0
