extends Sprite

const debug_current_armor = ["no_head", "no_body", "icarus_arms", "hermes_legs"]

export  var animation_z: float = 0.0
export  var armor_piece: String = "undefined"
export  var shared: bool = false
export  var armorless: Texture

var armor_name: String


func _ready() -> void :
	if CharacterManager.ultimate_x_armor and self.name != "Ultimate":
		self.visible = false
	elif CharacterManager.ultimate_x_armor and self.name == "Ultimate":
		self.visible = true
	var _s = get_parent().connect("color", self, "change_palette")
	_s = $"../..".connect("reset", self, "reset_palette")
	if shared:
		return
	for collectible in GameManager.current_armor:
		if not "no" in collectible and armor_piece in collectible:
			armor_name = collectible
			return
	texture = armorless

func change_palette(weapon: WeaponResource) -> void :
	if not material:
		return
	if "hermes" in armor_name:
		material.set_shader_param("palette", weapon.hermes_palette)
		return
	else:
		material.set_shader_param("palette", weapon.icarus_palette)

func reset_palette() -> void :
	material.set_shader_param("palette", null)
