extends X8OptionButton

export  var legible_name: String
export  var description: String

onready var name_display: Label = $"../../Description/name"
onready var disc_display: Label = $"../../Description/disc"
onready var equip: AudioStreamPlayer = $"../../../equip"
onready var unequip: AudioStreamPlayer = $"../../../unequip"
onready var heart_holder = get_parent()


func setup() -> void :
#	if get_heart_count() == 0:
#		visible = false
#		heart_holder.visible = false
	dim()
	display()
	#material.set_shader_param("grayscale", not GameManager.equip_hearts)

func _on_focus_entered() -> void :
	._on_focus_entered()
	display_info()

func on_press() -> void :
	increase_value()
#	if GameManager.equip_hearts:
#		equip.play()
#		strong_flash()
#	else:
#		unequip.play()
#		flash()
	#material.set_shader_param("grayscale", not GameManager.equip_hearts)

func process_inputs() -> void :
	pass
		
func increase_value() -> void :
	pass
	#GameManager.equip_hearts = not GameManager.equip_hearts
	#display()

func decrease_value() -> void :
#	GameManager.equip_hearts = not GameManager.equip_hearts
#	display()
	pass

func display() -> void :
#	if not GameManager.equip_hearts:
#		value.text = " "
#		self_modulate.a = 0.7
#	else:
#		value.text = "x" + str(get_heart_count())
#		self_modulate.a = 1
	pass

func get_heart_count() -> void:
#	var count = 0
#	for item in GameManager.collectibles:
#		if "life_up" in item:
#			count += 1
#	return count
	pass

func display_info() -> void :
	name_display.text = tr(legible_name)
	disc_display.text = tr(description)

