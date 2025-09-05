extends X8TextureButton

export  var weapon_resource: Resource

onready var weapon_name: Label = get_node("weapon_name")
onready var ammo: TextureProgress = get_node("ammo/current")

onready var base_texture: Texture = preload("res://Axl_mod/HUD/Pause/Axl_base.png")
onready var raygun_texture: Texture = preload("res://Axl_mod/HUD/Pause/Axl_raygun.png")
onready var sprial_texture: Texture = preload("res://Axl_mod/HUD/Pause/Axl_spiralmagnum.png")
onready var blacka_texture: Texture = preload("res://Axl_mod/HUD/Pause/Axl_blackarrow.png")
onready var plasma_texture: Texture = preload("res://Axl_mod/HUD/Pause/Axl_plasmagun.png")
onready var blastl_texture: Texture = preload("res://Axl_mod/HUD/Pause/Axl_blastlauncher.png")
onready var boundb_texture: Texture = preload("res://Axl_mod/HUD/Pause/Axl_boundblaster.png")
onready var icegat_texture: Texture = preload("res://Axl_mod/HUD/Pause/Axl_icegattling.png")
onready var flameb_texture: Texture = preload("res://Axl_mod/HUD/Pause/Axl_flameburner.png")

var character_name = "Axl"
var weapon


func _ready() -> void :
	call_deferred("set_player_weapon")
	var _s = menu.connect("pause_starting", self, "on_start")
	if weapon_resource:
		weapon_name.text = tr(weapon_resource.short_name)
		texture_normal = weapon_resource.icon

func on_start() -> void :
	ammo.value = get_bar_value()

func get_bar_value() -> float:
	if weapon:
		return inverse_lerp(0.0, weapon.max_ammo, weapon.current_ammo) * 28
	return 28.0

func set_pause_icon(_weapon) -> void :
	var _axl_icon = get_parent().get_parent().get_node("Lives").get_node("Axl_icon")
	if _axl_icon != null:
		if not _weapon:
			_axl_icon.texture = base_texture
		else:
			if weapon.name == "RayGun":
				_axl_icon.texture = raygun_texture
			elif weapon.name == "SpiralMagnum":
				_axl_icon.texture = sprial_texture
			elif weapon.name == "BlackArrow":
				_axl_icon.texture = blacka_texture
			elif weapon.name == "PlasmaGun":
				_axl_icon.texture = plasma_texture
			elif weapon.name == "BlastLauncher":
				_axl_icon.texture = blastl_texture
			elif weapon.name == "BoundBlaster":
				_axl_icon.texture = boundb_texture
			elif weapon.name == "IceGattling":
				_axl_icon.texture = icegat_texture
			elif weapon.name == "FlameBurner":
				_axl_icon.texture = flameb_texture

func set_player_weapon() -> void :
	if weapon_resource and GameManager.player:
		var i = CharacterManager.team.find(character_name)
		for _weapon in GameManager.team[i].get_node("Shot").get_children():
			if _weapon is WeaponBossAxl or _weapon.name == "GigaCrash" or _weapon.name == "XDrive":
				if _weapon.weapon.collectible == weapon_resource.collectible:
					weapon = _weapon

func _on_focus_entered() -> void :
	._on_focus_entered()
	if CharacterManager.player_character != "Axl":
		return
	if GameManager.is_player_in_scene():
		var _shot_node = GameManager.player.get_node("Shot")
		if _shot_node != null:
			_shot_node.set_current_weapon(weapon)
	get_parent().set_weapon(self)
	set_pause_icon(weapon)

func _on_focus_exited() -> void :
	if get_parent().choosen_weapon != self:
		._on_focus_exited()

func on_press() -> void :
	pass
