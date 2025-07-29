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

onready var armor_display: Control = $"../../Armor"
onready var black_zero_base: TextureRect = armor_display.get_node("base_B")
onready var black_zero_body: TextureRect = armor_display.get_node("black_body")
onready var black_zero_head: TextureRect = armor_display.get_node("black_head")
onready var black_zero_arms: TextureRect = armor_display.get_node("black_arms")
onready var black_zero_legs: TextureRect = armor_display.get_node("black_legs")
onready var black_zero_base_orignal: Texture = preload("res://Zero_mod/HUD/Char_Selection_Zeroblack_base.png")
onready var black_zero_body_orignal: Texture = preload("res://Zero_mod/HUD/Char_Selection_Zeroblack_Body.png")
onready var black_zero_head_orignal: Texture = preload("res://Zero_mod/HUD/Char_Selection_Zeroblack_Head.png")
onready var black_zero_arms_orignal: Texture = preload("res://Zero_mod/HUD/Char_Selection_Zeroblack_Arms.png")
onready var black_zero_legs_orignal: Texture = preload("res://Zero_mod/HUD/Char_Selection_Zeroblack_Legs.png")
onready var black_zero_base_replace: Texture = preload("res://Zero_mod/HUD/Beta_Char_Selection_Zeroblack_base.png")
onready var black_zero_body_replace: Texture = preload("res://Zero_mod/HUD/Beta_Char_Selection_Zeroblack_Body.png")
onready var black_zero_head_replace: Texture = preload("res://Zero_mod/HUD/Beta_Char_Selection_Zeroblack_Head.png")
onready var black_zero_arms_replace: Texture = preload("res://Zero_mod/HUD/Beta_Char_Selection_Zeroblack_Arms.png")
onready var black_zero_legs_replace: Texture = preload("res://Zero_mod/HUD/Beta_Char_Selection_Zeroblack_Legs.png")

onready var armor_parts: VBoxContainer = $"../../Options Group/ArmorParts"
onready var icon_black_zero_head: X8TextureButton = armor_parts.get_node("HeadParts/black_head")
onready var icon_black_zero_body: X8TextureButton = armor_parts.get_node("BodyParts/black_body")
onready var icon_black_zero_arms: X8TextureButton = armor_parts.get_node("ArmParts/black_arms")
onready var icon_black_zero_legs: X8TextureButton = armor_parts.get_node("LegParts/black_legs")
onready var icon_black_zero_head_orignal: Texture = preload("res://Zero_mod/HUD/Pause/Armor/black_zero_head.png")
onready var icon_black_zero_body_orignal: Texture = preload("res://Zero_mod/HUD/Pause/Armor/black_zero_body.png")
onready var icon_black_zero_arms_orignal: Texture = preload("res://Zero_mod/HUD/Pause/Armor/black_zero_arms.png")
onready var icon_black_zero_legs_orignal: Texture = preload("res://Zero_mod/HUD/Pause/Armor/black_zero_legs.png")
onready var icon_black_zero_head_replace: Texture = preload("res://Zero_mod/HUD/Pause/Armor/beta_black_zero_head.png")
onready var icon_black_zero_body_replace: Texture = preload("res://Zero_mod/HUD/Pause/Armor/beta_black_zero_body.png")
onready var icon_black_zero_arms_replace: Texture = preload("res://Zero_mod/HUD/Pause/Armor/beta_black_zero_arms.png")
onready var icon_black_zero_legs_replace: Texture = preload("res://Zero_mod/HUD/Pause/Armor/beta_black_zero_legs.png")


func _ready() -> void :
	_on_focus_exited()
	icon.material.set_shader_param("grayscale", not CharacterManager.betazero_activated)
	set_textures()

func _on_focus_entered() -> void :
	play_sound()
	display_info()
	flash()

func _on_focus_exited() -> void :
	dim()

func on_press() -> void :
	if not CharacterManager.custom_zero_armor:
		toggle_beta_zero()
		strong_flash()
		icon.material.set_shader_param("grayscale", not CharacterManager.betazero_activated)

func display_info() -> void :
	name_display.text = legible_name
	disc_display.text = description

func process_inputs() -> void :
	pass

func toggle_beta_zero() -> void :
	CharacterManager.betazero_activated = not CharacterManager.betazero_activated
	set_textures()
	if CharacterManager.betazero_activated:
		Tools.timer(0.075, "play", equip)
		char_name.text = "Zero (BETA)"
	else:
		Tools.timer(0.075, "play", unequip)
		char_name.text = "Zero"

func set_textures() -> void :
	if CharacterManager.betazero_activated:
		set_beta_textures()
	else:
		unset_beta_textures()

func set_beta_textures() -> void :
	black_zero_base.texture = black_zero_base_replace
	black_zero_body.texture = black_zero_body_replace
	black_zero_head.texture = black_zero_head_replace
	black_zero_arms.texture = black_zero_arms_replace
	black_zero_legs.texture = black_zero_legs_replace
	icon_black_zero_head.texture_normal = icon_black_zero_head_replace
	icon_black_zero_body.texture_normal = icon_black_zero_body_replace
	icon_black_zero_arms.texture_normal = icon_black_zero_arms_replace
	icon_black_zero_legs.texture_normal = icon_black_zero_legs_replace

func unset_beta_textures() -> void :
	black_zero_base.texture = black_zero_base_orignal
	black_zero_body.texture = black_zero_body_orignal
	black_zero_head.texture = black_zero_head_orignal
	black_zero_arms.texture = black_zero_arms_orignal
	black_zero_legs.texture = black_zero_legs_orignal
	icon_black_zero_head.texture_normal = icon_black_zero_head_orignal
	icon_black_zero_body.texture_normal = icon_black_zero_body_orignal
	icon_black_zero_arms.texture_normal = icon_black_zero_arms_orignal
	icon_black_zero_legs.texture_normal = icon_black_zero_legs_orignal
