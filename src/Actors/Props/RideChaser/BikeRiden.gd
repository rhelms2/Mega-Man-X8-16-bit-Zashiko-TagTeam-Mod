extends Ride

var engine_started: bool = false


func _ready() -> void :
	pass

func _OnPlayerAssumeControl() -> void :
	Event.emit_signal("new_camera_focus", character)
	Event.emit_signal("camera_ahead")
	Event.listen("stage_clear", self, "Force_Eject")

func _Setup():
	engine_started = true
	Log("Starting Engine")
	mount_audio.play()
	audio.pitch_scale = 0.2
	._Setup()

func Force_Eject() -> void :
	if character.is_on_floor():
		character.global_position.y -= 10
	character.force_end("Jump")
	character.force_end("Fall")
	character.force_end("HyperDash")
	character.force_execute("HyperDash")
	disable_camera_offset()

func _Eject() -> void :
	if Input.is_action_pressed("dash"):
		if character.is_on_floor():
			character.global_position.y -= 10
		character.force_end("Jump")
		character.force_end("Fall")
		character.force_end("HyperDash")
		character.force_execute("HyperDash")
	disable_camera_offset()

func _Interrupt() -> void :
	disable_camera_offset()
	._Interrupt()

func _physics_process(delta: float) -> void :
	if engine_started:
		set_pitch_based_on_speed(delta)

func set_pitch_based_on_speed(_delta: float):
	var destination_pitch = abs(character.get_actual_speed() / 320)
	if destination_pitch < 0.33:
		audio.pitch_scale = 0.33
		audio.volume_db = - 8.5
	else:
		if audio.pitch_scale != destination_pitch and destination_pitch > 0.33:
			if not character.is_on_floor() and audio.pitch_scale > destination_pitch:
				return
			audio.pitch_scale += (destination_pitch - audio.pitch_scale) / 15
			audio.volume_db = - 8.5 - audio.pitch_scale * 8
