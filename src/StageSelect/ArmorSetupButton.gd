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
	set_correct_player_icon()
	for item in menu.get_children():
		if item.name == name:
			var _s = item.connect("focus_entered", self, "focus")
			_s = item.connect("focus_exited", self, "unfocus")
			call_deferred("synchronize_visibility", item)

func _process(_delta):
	set_correct_player_icon()

func set_correct_player_icon():
	match CharacterManager.current_player_character:
		"Player":
			play(get_correct_animation("X"))
		"X":
			play(get_correct_animation("X"))
		"Axl":
			play(get_correct_animation("Axl"))
		"Zero":
			play(get_correct_animation("Zero"))

func synchronize_visibility(selectable) -> void :
	visible = selectable.visible

func focus() -> void :
	cursor.visible = true
	pointer.visible = true
	emit_signal("focused")

func unfocus() -> void :
	cursor.visible = false
	emit_signal("unfocused")

func get_correct_animation(anim_name: String) -> String:
	if defeated:
		return "defeated_" + anim_name
	else:
		return anim_name
