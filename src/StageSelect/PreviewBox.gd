extends AnimatedSprite

export  var buttons: NodePath
export  var map: NodePath

onready var level_preview: Sprite = $level_preview
onready var tween: TweenController = TweenController.new(self, false)
onready var final_position: Vector2 = position
onready var o_map_position: Vector2 = get_node(map).global_position

var exceptions: Array = ["JakobElevator", "Gateway", "SigmaPalace"]
var blinking: bool = false


func _input(event: InputEvent) -> void :
	if event.is_action_pressed("alt_fire"):
		increase()

func connect_with_buttons() -> void :
	for child in get_node(buttons).get_children():
		if child.has_signal("stage_selected"):
			child.connect("stage_selected", self, "on_stage_selected")
		else:
			child.connect("focus_entered", self, "hide")

func on_stage_selected(info: StageInfo) -> void :
	if info.get_load_name() in exceptions:
		hide()
	else:
		level_preview.texture = info.preview
		increase(info.pointer_position + o_map_position)
	pass

func hide() -> void :
	visible = false

func _ready() -> void :
	hide()
	connect_with_buttons()

func increase(initial_position: Vector2 = Vector2(200, 118)) -> void :
	visible = true
	level_preview.visible = false
	position = initial_position
	tween.reset()
	tween.attribute("position", final_position, 0.65)
	tween.add_callback("show_preview")
	tween.add_callback("start_blink")
	frame = 0

func show_preview() -> void :
	level_preview.visible = true

func start_blink() -> void :
	if not blinking:
		blinking = true
		blink()

func blink() -> void :
	if blinking:
		if modulate.a == 0.75:
			modulate.a = 0.6
		else:
			modulate.a = 0.75
		Tools.timer(0.032, "blink", self)
	else:
		modulate.a = 1.0
