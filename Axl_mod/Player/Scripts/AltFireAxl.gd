extends ShotAxl

onready var alternate_pistol: Node2D = get_node_or_null("Alternate Pistol")
onready var alternate_raygun: Node2D = get_node_or_null("Alternate RayGun")
onready var alternate_spiralmagnum: Node2D = get_node_or_null("Alternate SpiralMagnum")
onready var alternate_blackarrow: Node2D = get_node_or_null("Alternate BlackArrow")
onready var alternate_plasmagun: Node2D = get_node_or_null("Alternate PlasmaGun")
onready var alternate_blastlauncher: Node2D = get_node_or_null("Alternate BlastLauncher")
onready var alternate_boundblaster: Node2D = get_node_or_null("Alternate BoundBlaster")
onready var alternate_icegattling: Node2D = get_node_or_null("Alternate IceGattling")
onready var alternate_flameburner: Node2D = get_node_or_null("Alternate FlameBurner")

var _alternate_active: bool = false

func activate_different_alternates() -> void :
	var _shot_node = character.get_node("Shot")
	if _shot_node != null:
		var index = _shot_node.weapons.find(_shot_node.current_weapon)
		var _main_weapon = _shot_node.weapons[_shot_node.weapons.find(_shot_node.current_weapon)]
		deactivate_all_alternates()
		if "Pistol" in _main_weapon.name:
			set_current_weapon(alternate_pistol)
			_alternate_active = true
		elif "Transform" in _main_weapon.name:
			set_current_weapon(alternate_pistol)
			_alternate_active = true
			
		elif "RayGun" in _main_weapon.name:
			set_current_weapon(alternate_raygun)
			_alternate_active = true

		elif "SpiralMagnum" in _main_weapon.name:
			set_current_weapon(alternate_spiralmagnum)
			_alternate_active = true

		elif "BlackArrow" in _main_weapon.name:
			set_current_weapon(alternate_blackarrow)
			_alternate_active = true

		elif "PlasmaGun" in _main_weapon.name:
			set_current_weapon(alternate_plasmagun)
			_alternate_active = true

		elif "BlastLauncher" in _main_weapon.name:
			set_current_weapon(alternate_blastlauncher)
			_alternate_active = true

		elif "BoundBlaster" in _main_weapon.name:
			set_current_weapon(alternate_boundblaster)
			_alternate_active = true

		elif "IceGattling" in _main_weapon.name:
			set_current_weapon(alternate_icegattling)
			_alternate_active = true

		elif "FlameBurner" in _main_weapon.name:
			set_current_weapon(alternate_flameburner)
			_alternate_active = true

func _Update(_delta: float) -> void :
	._Update(_delta)

func _StartCondition() -> bool:
	if name == "AltFire" and Input.is_action_pressed("fire"):
		return false
	activate_different_alternates()
	if _alternate_active:
		if current_weapon and character.has_control():
			return true
		return false
	else:
		return false

func deactivate_all_alternates() -> void :
	for child in get_children():
		child.active = false
	_alternate_active = false

func switch_to_alternate() -> void :
	if alternate_pistol != null:
		alternate_pistol.active = true
		set_current_weapon(alternate_pistol)
