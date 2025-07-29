extends X8TextureButton
class_name X8OptionButton

var active: bool = false
onready var value: Label = get_node_or_null("Value")

var frequency: float = 0.5
var timer: float = 0.0

func _ready() -> void :
	var _s = Savefile.connect("loaded", self, "setup")
	Event.listen("update_options", self, "setup")

func setup() -> void :
	pass

func _on_focus_exited() -> void :
	._on_focus_exited()
	active = false

func _on_focus_entered() -> void :
	._on_focus_entered()
	active = true

func on_press() -> void :
	strong_flash()
	increase_value()
	play_pick_sound()

func play_pick_sound() -> void :
	if not silent and menu:
		menu.play_pick_sound()
	silent = false

func _physics_process(delta: float) -> void :
	if active:
		timer += delta
		if Input.is_action_pressed("ui_right") or Input.is_action_pressed("ui_left"):
			if frequency == 0.5:
				process_inputs()
			elif timer > frequency:
				process_inputs()
		else:
			timer = 0
			frequency = 0.5

func reduce_frequency() -> void :
	frequency = frequency * 0.8
	frequency = clamp(frequency, 0.04, 0.5)

func process_inputs() -> void :
	timer = 0
	if Input.is_action_pressed("ui_right"):
		flash()
		increase_value()
		play_pick_sound()
		reduce_frequency()
	elif Input.is_action_pressed("ui_left"):
		flash()
		decrease_value()
		play_pick_sound()
		reduce_frequency()
	elif Input.is_action_pressed("ui_accept"):
		flash()
		increase_value()
		play_sound()
		reduce_frequency()
	else:
		timer = 0
		frequency = 0.5

func increase_value() -> void :
	display_value("increased")

func decrease_value() -> void :
	display_value("decreased")

func display_value(new_value) -> void :
	if value:
		value.text = tr(str(new_value))
