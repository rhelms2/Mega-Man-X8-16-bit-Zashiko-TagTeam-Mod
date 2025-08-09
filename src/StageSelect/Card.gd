extends AnimatedSprite

onready var cursor: AnimatedSprite = $cursor
onready var menu: Control = $"../../StageSelectUI/Menu"
onready var pointer: AnimatedSprite = $"../../map/pointer"

var defeated: bool = false
var stage: StageInfo

signal focused
signal moved_cursor(pos)
signal unfocused


func _ready() -> void :
	for item in menu.get_children():
		if item.name == name:
			stage = item.stage_info
			var _s = item.connect("focus_entered", self, "focus")
			_s = item.connect("focus_exited", self, "unfocus")
			call_deferred("synchronize_visibility", item)
	set_defeated_status()
	play(get_correct_animation("idle"))

func synchronize_visibility(selectable) -> void :
	visible = selectable.visible

func set_defeated_status() -> void :
	defeated = stage.was_beaten()

func focus() -> void :
	play(get_correct_animation("selected"))
	cursor.visible = true
	pointer.visible = true
	emit_signal("focused")
	emit_signal("moved_cursor", stage.pointer_position)

func unfocus() -> void :
	play(get_correct_animation("idle"))
	cursor.visible = false
	emit_signal("unfocused")

func get_correct_animation(anim_name: String) -> String:
	if defeated:
		return "defeated_" + anim_name
	else:
		return anim_name
