extends CanvasModulate
class_name StageLights

export  var normal_color: Color
export  var darkness: Color
export  var alarm_color: Color
export  var alarm_color2: Color

export  var alarm_duration: = 16.0

export  var alarm: = false
var went_to_black: = false
export  var darkness_area: = false
var went_to_darkness: = false
var timer: = 0.0
var lights_turned_on: = false

func _ready() -> void :
	Event.listen("alarm", self, "start_alarm")
	Event.listen("darkness", self, "start_darkness")
	Event.listen("turn_off_darkness", self, "turn_off_darkness")
	Event.listen("pitch_black_energized", self, "turn_on_all_lights")
	if not visible:
		visible = true

func _physics_process(delta: float) -> void :
	if alarm:
		handle_alarm(delta)
	else:
		if lights_turned_on:
			handle_normallights()
			set_physics_process(false)
			return
		if darkness_area:
			handle_darkness()
		elif not went_to_black:
			handle_normallights()

func start_alarm() -> void :
	if lights_turned_on:
		return
	if not darkness_area:
		alarm = true
		timer = 0

func start_darkness() -> void :
	if lights_turned_on:
		return
	darkness_area = true
	alarm = false

func turn_off_darkness() -> void :
	if lights_turned_on:
		return
	darkness_area = false

func reset_lights() -> void :
	alarm = false

func handle_alarm(delta: float) -> void :
	timer += delta
	color = lerp(alarm_color, alarm_color2, abs(sin(timer * 8)))
	went_to_black = false
	went_to_darkness = false
	if timer > alarm_duration:
		if alarm == true:
			Event.emit_signal("alarm_done")
		alarm = false

func handle_darkness() -> void :
	if lights_turned_on:
		light_up_stage()
		return
	if not went_to_darkness:
		var tween = get_tree().create_tween()
		tween.tween_property(self, "color", darkness, 1)
		went_to_darkness = true
		went_to_black = false

func handle_normallights() -> void :
	if lights_turned_on:
		light_up_stage()
		return
	var tween = get_tree().create_tween()
	tween.tween_property(self, "color", normal_color, 1)
	went_to_black = true
	went_to_darkness = false
	reset_lights()
	Event.emit_signal("turn_off_alarm")
	
func turn_on_all_lights() -> void :
	lights_turned_on = true
	alarm = false
	light_up_stage()
	pass

func light_up_stage() -> void :
	Event.emit_signal("turn_off_alarm")
	var tween = get_tree().create_tween()
	tween.tween_property(self, "color", Color(0.7, 0.7, 1, 1), 1)
