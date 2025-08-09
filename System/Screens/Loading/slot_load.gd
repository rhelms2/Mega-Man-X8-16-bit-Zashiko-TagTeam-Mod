extends X8TextureButton

export  var slot_index: int = 0

onready var slot_number: Label = $number
onready var difficulty: Label = $difficulty
onready var completion: Label = $completion
onready var newgame_plus: Label = $newgameplus
onready var last_saved: Label = $last_saved


func _on_focus_entered() -> void :
	if menu:
		menu.set_current_slot(slot_index)
	play_sound()
	flash()

func _on_pressed() -> void :
	modulate = Color(3, 3, 3, 1)
	reset_tween()
	tween.tween_property(self, "modulate", Color.white, 0.35)
	Savefile.save_slot = slot_index
	menu.loaded_end()
	play_loading_sound()
	on_press()

func play_loading_sound() -> void :
	if not silent and menu:
		menu.play_loaded_sound()
	silent = false
