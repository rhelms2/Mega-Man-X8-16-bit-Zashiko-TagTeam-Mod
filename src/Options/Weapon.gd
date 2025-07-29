extends X8TextureButton

export  var weapon_resource: Resource

onready var weapon_name: Label = get_node("weapon_name")
onready var ammo: TextureProgress = get_node("ammo/current")

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

func set_player_weapon() -> void :
	if weapon_resource and GameManager.player:
		for _weapon in GameManager.player.get_node("Shot").get_children():
			if _weapon is BossWeapon or _weapon.name == "GigaCrash" or _weapon.name == "XDrive" or _weapon.name == "NovaStrike":
				if _weapon.weapon.collectible == weapon_resource.collectible:
					weapon = _weapon

func _on_focus_entered() -> void :
	._on_focus_entered()
	if GameManager.is_player_in_scene():
		GameManager.player.get_node("Shot").set_current_weapon(weapon)
	get_parent().set_weapon(self)

func _on_focus_exited() -> void :
	if get_parent().choosen_weapon != self:
		._on_focus_exited()

func on_press() -> void :
	pass
