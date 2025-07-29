extends X8OptionButton

export  var legible_name: String
export  var description: String

onready var equip: AudioStreamPlayer = $"../../../../../equip"
onready var unequip: AudioStreamPlayer = $"../../../../../unequip"
onready var choice: AudioStreamPlayer = $"../../../../../choice"
onready var icon: TextureRect = $"icon"
onready var name_display: Label = $"../../../../Description/name"
onready var disc_display: Label = $"../../../../Description/disc"
onready var char_name: Label = $"../../../../CharacterName"

onready var beta_zero: = $"../../betazero_holder/beta_zero"


func _ready() -> void :
	_on_focus_exited()
	icon.material.set_shader_param("grayscale", not CharacterManager.custom_zero_armor)

func _on_focus_entered() -> void :
	play_sound()
	display_info()
	flash()

func show_unlocked() -> void :
	icon.material.set_shader_param("grayscale", not CharacterManager.custom_zero_armor)

func _on_focus_exited() -> void :
	dim()

func on_press() -> void :
	CharacterManager.betazero_activated = false
	beta_zero.icon.material.set_shader_param("grayscale", not CharacterManager.betazero_activated)
	beta_zero.unset_beta_textures()
	toggle_custom_zero()
	strong_flash()
	icon.material.set_shader_param("grayscale", not CharacterManager.custom_zero_armor)

func display_info() -> void :
	name_display.text = legible_name
	disc_display.text = description

func process_inputs() -> void :
	pass

func toggle_custom_zero() -> void :
	CharacterManager.custom_zero_armor = not CharacterManager.custom_zero_armor
	if CharacterManager.custom_zero_armor:
		Tools.timer(0.075, "play", equip)
		char_name.text = "Zero"
	else:
		Tools.timer(0.075, "play", unequip)
		char_name.text = "Zero"
