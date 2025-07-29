extends Node2D
class_name Press

export (AudioStream) var start_close_sound
export (AudioStream) var close_sound
export  var debug_logs: = false
export  var distance: = 64
export  var duration: = 2.0
export  var direction: = - 1
export  var delay_before_close: = 1.0
var original_position: float
onready var press: = $tiled_press
var timer: = 0.0
var active: = false
var debug: = true

signal close

func _ready() -> void :
	original_position = press.global_position.x
	call_deferred("close")

func Log(message) -> void :
	if debug_logs:
		print(name + ": " + message)

func _physics_process(delta: float) -> void :
	if active:
		timer += delta
		if timer > delay_before_close + duration:
			close()
			active = false

func emit_close() -> void :
	emit_signal("close")
	if GameManager.is_on_screen(global_position):
		Event.emit_signal("screenshake", 2)
	play(close_sound)

func close() -> void :
	var final_pos = Vector2(original_position + (distance * direction), press.global_position.y)
	var tween = create_tween()
	Log("Closing")
	play(start_close_sound)
	tween.tween_property(press, "global_position", final_pos, proportional_duration())
	tween.tween_callback(self, "emit_close")

func open():
	active = true
	timer = 0
	var final_pos = Vector2(original_position, press.global_position.y)
	Log("Opening")
	var tween = create_tween()
	tween.tween_property(press, "global_position", final_pos, proportional_duration())

func proportional_duration() -> float:
	var final_pos = original_position + (distance * direction)
	Log("Timing: " + str(duration * abs(global_position.x - final_pos) / distance))
	return duration * abs(global_position.x - final_pos) / distance


func _on_Button_button_press() -> void :
	open()


func play(sound):
	if sound:
		var audio = $audioStreamPlayer2D
		audio.pitch_scale = BossRNG.rng.randf_range(0.9, 1.1)
		audio.stream = sound
		audio.play()
