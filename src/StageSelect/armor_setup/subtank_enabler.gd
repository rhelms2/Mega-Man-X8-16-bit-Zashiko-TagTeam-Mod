extends X8OptionButton

export  var legible_name: String
export  var description: String

onready var name_display: Label = $"../../Description/name"
onready var disc_display: Label = $"../../Description/disc"
onready var equip: AudioStreamPlayer = $"../../../equip"
onready var unequip: AudioStreamPlayer = $"../../../unequip"
onready var subtank_holder = get_parent()

onready var equipped_text: Label = $equipped


func setup() -> void :
	if get_subtank_count() == 0:
		visible = false
		subtank_holder.visible = false
	dim()
	display()
	material.set_shader_param("grayscale", not GameManager.equip_subtanks)

func _on_focus_entered() -> void :
	._on_focus_entered()
	display_info()

func on_press() -> void :
	increase_value()
	if GameManager.equip_subtanks:
		equip.play()
		strong_flash()
	else:
		unequip.play()
		flash()
	material.set_shader_param("grayscale", not GameManager.equip_subtanks)

func process_inputs() -> void :
	pass
		
func increase_value() -> void :
	GameManager.equip_subtanks = not GameManager.equip_subtanks
	display()

func decrease_value() -> void :
	GameManager.equip_subtanks = not GameManager.equip_subtanks
	display()

func display() -> void :
	value.text = str(get_subtank_count())
	if not GameManager.equip_subtanks:
		equipped_text.text = str(0) + "/"
		self_modulate.a = 0.7
	else:
		equipped_text.text = str(get_subtank_count()) + "/"
		self_modulate.a = 1

func get_subtank_count() -> int:
	var count = 0
	for item in GameManager.collectibles:
		if "subtank" in item:
			count += 1
	return count

func display_info() -> void :
	name_display.text = tr(legible_name)
	disc_display.text = tr(description)
