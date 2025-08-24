extends X8TextureButton

export  var weapon_resource: Resource

onready var weapon_name: Label = get_node("weapon_name")
onready var ammo: TextureProgress = get_node("ammo/current")
onready var zero_icon = $"../../Lives/Zero_icon"
onready var black_zero_icon: TextureRect = $"../../BlackZeroArmor"
onready var zero_base: Texture = preload("res://Zero_mod/HUD/ZeroX8_base.png")
onready var zero_bfan: Texture = preload("res://Zero_mod/HUD/ZeroX8_fan.png")
onready var zero_dglaive: Texture = preload("res://Zero_mod/HUD/ZeroX8_glaive.png")
onready var zero_kknuckle: Texture = preload("res://Zero_mod/HUD/ZeroX8_knuckle.png")
onready var zero_tbreaker: Texture = preload("res://Zero_mod/HUD/ZeroX8_breaker.png")
onready var zero_vhanger: Texture = preload("res://Zero_mod/HUD/ZeroX8_base.png")
onready var zero_sigmablade: Texture = preload("res://Zero_mod/HUD/ZeroX8_base.png")
onready var zero_base2: Texture = preload("res://Zero_mod/HUD/ZeroX8_base.png")
onready var zero_base3: Texture = preload("res://Zero_mod/HUD/ZeroX8_base.png")

onready var zero_beta: Texture = preload("res://Zero_mod/HUD/Zero_base.png")
onready var black_zero_beta_icon: Texture = preload("res://Zero_mod/HUD/Pause/beta_black_zero_collectible.png")
onready var zero_beta_material: = preload("res://Zero_mod/Sprites/Zero_Material_Shader.tres")

var character_name = "Zero"
var weapon


func _ready() -> void :
	call_deferred("set_player_weapon")
	var _s = menu.connect("pause_starting", self, "on_start")
	if weapon_resource:
		weapon_name.text = tr(weapon_resource.short_name)
		texture_normal = weapon_resource.icon
		pass

func on_start() -> void :
	if CharacterManager.betazero_activated:
		zero_icon.texture = zero_beta
		black_zero_icon.texture = black_zero_beta_icon
		zero_icon.material = zero_beta_material
		CharacterManager.set_zero_colors(zero_icon)

func set_pause_icon(_weapon) -> void :
	if not _weapon:
		zero_icon.texture = zero_base
	else:
		if weapon.name == "B-Fan":
			zero_icon.texture = zero_bfan
		if weapon.name == "D-Glaive":
			zero_icon.texture = zero_dglaive
		if weapon.name == "K-Knuckle":
			zero_icon.texture = zero_kknuckle
		if weapon.name == "T-Breaker":
			zero_icon.texture = zero_tbreaker
		if weapon.name == "V-Hanger":
			zero_icon.texture = zero_vhanger
		if weapon.name == "Sigma-Blade":
			zero_icon.texture = zero_sigmablade
		if weapon.name == "lol":
			zero_icon.texture = zero_base2
		if weapon.name == "lel":
			zero_icon.texture = zero_base3
	if CharacterManager.betazero_activated:
		zero_icon.texture = zero_beta
		black_zero_icon.texture = black_zero_beta_icon

func set_player_weapon() -> void :
	if weapon_resource and GameManager.player:
		var i = CharacterManager.current_team.find(character_name)
		for _weapon in GameManager.team[i].get_node("Shot").get_children():
			if _weapon is ZeroSpecialWeapon:
				if _weapon.weapon.collectible == weapon_resource.collectible:
					weapon = _weapon

func _on_focus_entered() -> void :
	._on_focus_entered()
	if CharacterManager.current_player_character != "Zero":
		return
	if CharacterManager.betazero_activated:
		return
	if GameManager.is_player_in_scene():
		var _shot_node = GameManager.player.get_node("Shot")
		if _shot_node != null:
			var _animation = _shot_node.get_parent().get_animation()
			if _animation in _shot_node.get_parent().saber_animations:
				return
			_shot_node.set_current_weapon(weapon)
	get_parent().set_weapon(self)
	set_pause_icon(weapon)

func _on_focus_exited() -> void :
	if get_parent().choosen_weapon != self:
		._on_focus_exited()

func on_press() -> void :
	pass
