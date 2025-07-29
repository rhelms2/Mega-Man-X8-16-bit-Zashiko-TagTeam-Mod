extends AnimatedSprite

var facing_direction: = - 1
var destination: = 0.0
var tween: = TweenController.new(self, false)
export  var reploid_frames: SpriteFrames
onready var initial_color: = modulate
onready var sigma_frames: = frames
onready var flash: Sprite = $flash
onready var transformsfx: AudioStreamPlayer2D = $transform
onready var step: AudioStreamPlayer2D = $step

func _ready() -> void :
	reset()

func appear():
	tween.attribute("self_modulate:a", 1.0, 2.0)

func appear_and_move(wait_time: = 3.0, destination: = 0.0):
	appear()
	tween.add_wait(wait_time)
	tween.add_callback("color_to_light")
	tween.add_callback("move", self, [destination])

func transform_into_reploid():
	tween.attribute("modulate", Color(5, 5, 5, 1), 1.0)
	tween.add_callback("start", flash)
	tween.add_callback("change_frames_to_reploid")
	tween.add_attribute("modulate", Color.white, 2.0)

func change_frames_to_reploid():
	frames = reploid_frames
	position.y += 16
	play("land")
	transformsfx.play_rp()

func reset():
	facing_direction = - 1
	scale.x = facing_direction
	tween.reset()
	modulate = initial_color
	self_modulate.a = 0.0
	position = Vector2(282, 159)
	z_index = 1
	frames = sigma_frames

func color_to_light():
	tween.attribute("modulate", Color.white, 4.0)

func move(new_destination: = 0.0):
	if new_destination != 0.0:
		destination = new_destination
	if moving_towards_back():
		turn_and_step_foward()
	else:
		step_foward()

func turn_and_step_foward():
	
	play("turn")
	z_index = 3
	connect("animation_finished", self, "change_direction", ["step_foward"])

func change_direction(next_method: = "none"):
	if facing_direction == 1:
		facing_direction = - 1
	else:
		facing_direction = 1
	scale.x = facing_direction
	if next_method != "none":
		call(next_method)
	disconnect_finish("change_direction")

func step_foward():
	
	if animation != "step_left":
		play("step_left")
	else:
		play("step_right")
	
	var step_distance: = 20.0
	if abs(destination) < step_distance:
		step_distance = abs(destination)
	
	tween.create(Tween.EASE_IN_OUT, Tween.TRANS_SINE)
	tween.add_attribute("position:x", position.x + step_distance * facing_direction, 0.5)
	destination = destination - step_distance * facing_direction
	Tools.timer(0.3, "play_r", step)
	if abs(destination) > 0.0:
		tween.add_wait(0.5)
		tween.add_callback("step_foward")
	else:
		tween.add_wait(0.5)
		tween.add_callback("recover")
		
	

func recover():
	if facing_direction == 1:
		play("turn")
		z_index = 3
		connect("animation_finished", self, "change_direction", ["recover"])
	else:
		play("shield_end")
		set_frame(9)
		connect("animation_finished", self, "idle")

func idle():
	play("idle")
	disconnect_finish("idle")

func moving_towards_back() -> bool:
	if destination > 0 and facing_direction == - 1:
		return true
	if destination < 0 and facing_direction == 1:
		return true
	return false

func disconnect_finish(method_name: String):
	if is_connected("animation_finished", self, method_name):
		disconnect("animation_finished", self, method_name)
