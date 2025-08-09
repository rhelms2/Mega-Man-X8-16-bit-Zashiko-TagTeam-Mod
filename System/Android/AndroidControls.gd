extends CanvasLayer

onready var _pause_menu = get_parent().get_node("Pause")
onready var _paused = _pause_menu.paused

onready var exceptions = [
	"Pause", 
]

func _process(delta):
	_paused = _pause_menu.paused
	set_button_visibility( not _paused)

func set_button_visibility(_visible):
	var touch_key = self.get_children()
	
	for child in touch_key:
		if not child.name in exceptions:
			child.visible = _visible
