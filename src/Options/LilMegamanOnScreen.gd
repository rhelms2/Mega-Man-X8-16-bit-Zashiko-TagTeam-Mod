extends AnimatedSprite

onready var option_holder: VBoxContainer = $"../Menu/OptionHolder"
onready var shot = get_child(0)
onready var initial_shot_pos: Vector2 = get_child(0).position
onready var menu: Control = $"../Menu"
onready var _shot = get_node("shot")

var choices: Array = []


func _ready() -> void :
	choices = option_holder.get_children()
	visible = false
	for option in choices:
		var _s = option.connect("focus_entered", self, "_on_focus", [option])
		_s = option.connect("pressed", self, "_on_pressed", [option])
	connect("animation_finished", self, "_on_anim_finished")

func _on_focus(option) -> void :
	initial_shot_pos = Vector2(13, 2)
	global_position.y = option.rect_global_position.y + 7
	frame = 0
	play("recover")

func _process(_delta: float) -> void :
	if visible != menu.visible:
		visible = menu.visible

func _on_pressed(option) -> void :
	if option.name != "Options" and option.name != "Keycfg" and option.name != "Loading" and option.name != "Leaderboards":
		if option.name != "GameStartZero":
			shot.visible = true
			shot.position = initial_shot_pos
			var t = create_tween()
			t.tween_property(shot, "position:x", 400.0, 1)
			play("shot")

func _on_anim_finished() -> void :
	play("recover")
