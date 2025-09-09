extends X8OptionButton

export  var legible_name: String
export  var description: String

onready var name_display: Label = $"../Description/name"
onready var disc_display: Label = $"../Description/disc"

onready var sprite: AnimatedSprite = $"animatedSprite"
onready var choice: AudioStreamPlayer = $"../../choice"
onready var unequip: AudioStreamPlayer = $"../../unequip"

onready var x_head = $"../textureRect/X/Options Group/ArmorParts/HeadParts/head"
onready var axl_head = $"../textureRect/Axl/Options Group/ArmorParts/HeadParts/head"
onready var zero_head = $"../textureRect/Zero/Options Group/ArmorParts/HeadParts/head"

onready var heart_enabler = $"../heart_holder/heart_enabler"
onready var subtank_enabler = $"../subtank_holder/subtank_enabler"



func setup() -> void :
	dim()

func _on_focus_entered() -> void :
	display_info()
	._on_focus_entered()

func _on_focus_exited() -> void :
	._on_focus_exited()
	dim()

func on_press() -> void :
	unequip.play()
	unequip_all_upgrades()
	
func unequip_all_upgrades() -> void :
	CharacterManager.reset_equipped_hearts()
	heart_enabler.refresh_equipped_hearts()
	GameManager.equip_subtanks = true
	subtank_enabler.on_press()
	
	x_head.unequip_full_ultimate()
	x_head.main_color.visible = CharacterManager.ultimate_x_armor
	x_head.main_color_head.visible = CharacterManager.ultimate_x_armor
	zero_head.unequip_black_zero()
	zero_head.base_black.visible = CharacterManager.black_zero_armor
	axl_head.unequip_white_axl()
	axl_head.base_white.visible = CharacterManager.white_axl_armor
	

func process_inputs() -> void :
	pass

func display() -> void :
	pass
	
func display_info() -> void :
	choice.play()
	name_display.text = tr(legible_name)
	disc_display.text = tr(description)
