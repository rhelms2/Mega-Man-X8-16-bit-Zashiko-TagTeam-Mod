extends X8OptionButton

export  var legible_name: String
export  var description: String

onready var equip: AudioStreamPlayer = $"../../../equip"
onready var choice: AudioStreamPlayer = $"../../../choice"
onready var name_display: Label = $"../../Description/name"
onready var disc_display: Label = $"../../Description/disc"


func setup() -> void :
	display()

func _on_focus_entered() -> void :
	._on_focus_entered()
	display_info()

func on_press() -> void :
	menu.change_next_character()
	strong_flash()

func process_inputs() -> void :
	pass

func display() -> void :
	value.text = ">"

func display_info() -> void :
	name_display.text = tr(legible_name)
	disc_display.text = tr(description)
