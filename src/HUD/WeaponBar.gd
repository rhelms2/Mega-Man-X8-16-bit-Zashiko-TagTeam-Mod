extends NinePatchRect

onready var weapon_icon: TextureRect = $"../WeaponIcon"
onready var ammo_bar: TextureProgress = $textureProgress
onready var x_bar = get_parent()
var char_name = "null"

var weapon

signal displayed(weapon)
signal hidden




func display(current_weapon) -> void :
	if is_exception(current_weapon) or not char_name == GameManager.player.name:
		weapon = null
		hide()
		return
	weapon = current_weapon
	var icon = weapon.weapon.icon
	var palette = weapon.weapon.palette
	weapon_icon.texture.atlas = icon
	ammo_bar.material.set_shader_param("palette", palette)
	ammo_bar.value = get_bar_value()
	show()
	emit_signal("displayed", current_weapon, char_name)

func is_exception(current_weapon) -> bool:
	if "Buster" in current_weapon.name:
		return true
	if "Pistol" in current_weapon.name:
		return true
	if "Saber" in current_weapon.name:
		return true
	return false

func _process(_delta: float) -> void :
	if weapon:
		ammo_bar.value = get_bar_value()
		if weapon.current_ammo > 0 and weapon.current_ammo < 1:
			ammo_bar.value = 1

func get_bar_value() -> float:
	return inverse_lerp(0.0, weapon.max_ammo, weapon.current_ammo) * 28

func _ready() -> void :
	Event.listen("changed_weapon", self, "display")
	hide()
	if x_bar.team_member_index > 0 and CharacterManager.team.size() > 1:
		char_name = CharacterManager.team[x_bar.team_member_index]
	else:
		char_name = CharacterManager.team[0]

func hide() -> void :
	weapon_icon.visible = false
	visible = false
	emit_signal("hidden")

func show() -> void :
	weapon_icon.visible = true
	visible = true
