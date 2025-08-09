extends ShotAxl

onready var special_pistol: Node2D = get_node_or_null("GigaCrash")
onready var special_raygun: Node2D = get_node_or_null("RayGun Special")
onready var special_spiralmagnum: Node2D = get_node_or_null("SpiralMagnum Special")
onready var special_blackarrow: Node2D = get_node_or_null("BlackArrow Special")
onready var special_plasmagun: Node2D = get_node_or_null("PlasmaGun Special")
onready var special_blastlauncher: Node2D = get_node_or_null("BlastLauncher Special")
onready var special_boundblaster: Node2D = get_node_or_null("BoundBlaster Special")
onready var special_icegattling: Node2D = get_node_or_null("IceGattling Special")
onready var special_flameburner: Node2D = get_node_or_null("FlameBurner Special")

var _special_active: bool = false
var is_executing_special: bool = false


func _ready() -> void :
	Event.listen("weapon_select_left", self, "activate_different_alternates")
	Event.listen("weapon_select_right", self, "activate_different_alternates")
	Event.listen("weapon_select_buster", self, "activate_different_alternates")
	Event.listen("select_weapon", self, "activate_different_alternates")
	activate_different_alternates()

func _physics_process(_delta: float) -> void :
	activate_different_alternates()

func activate_different_alternates() -> void :
	var _shot_node = character.get_node("Shot")
	if _shot_node != null:
		var index = _shot_node.weapons.find(_shot_node.current_weapon)
		var _main_weapon = _shot_node.weapons[_shot_node.weapons.find(_shot_node.current_weapon)]
		deactivate_all_specials()
		if "Pistol" in _main_weapon.name:
			special_pistol.active = true
			set_current_weapon(special_pistol)
			_special_active = true
			
		elif "RayGun" in _main_weapon.name:
			set_current_weapon(special_raygun)
			_special_active = true
		
		elif "SpiralMagnum" in _main_weapon.name:
			set_current_weapon(special_spiralmagnum)
			_special_active = true

		elif "BlackArrow" in _main_weapon.name:
			set_current_weapon(special_blackarrow)
			_special_active = true

		elif "PlasmaGun" in _main_weapon.name:
			set_current_weapon(special_plasmagun)
			_special_active = true

		elif "BlastLauncher" in _main_weapon.name:
			set_current_weapon(special_blastlauncher)
			_special_active = true

		elif "BoundBlaster" in _main_weapon.name:
			set_current_weapon(special_boundblaster)
			_special_active = true

		elif "IceGattling" in _main_weapon.name:
			set_current_weapon(special_icegattling)
			_special_active = true

		elif "FlameBurner" in _main_weapon.name:
			set_current_weapon(special_flameburner)
			_special_active = true
		
		else:
			set_current_weapon(null)

func _Setup() -> void :
	current_weapon.fire(0)

func _StartCondition() -> bool:
	if _special_active:
		if current_weapon and character.has_control():
			if special_pistol.current_ammo >= current_weapon.ammo_per_shot:
				return true
		return false
	else:
		return false

func deactivate_all_specials() -> void :
	for child in get_children():
		child.active = false
	_special_active = false
