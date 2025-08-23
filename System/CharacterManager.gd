extends Node

onready var _PLAYER: PackedScene = preload("res://src/Actors/Player/Player.tscn")
onready var _X: PackedScene = preload("res://src/Actors/Player/X/PlayerX.tscn")
onready var _X_Ultimate: PackedScene = preload("res://X_mod/UltimateX/Player/UltimateX.tscn")
onready var _Axl: PackedScene = preload("res://Axl_mod/Player/PlayerAxl.tscn")
onready var _Zero_Beta: PackedScene = preload("res://Zero_mod/Player/PlayerZero.tscn")
onready var _Zero: PackedScene = preload("res://Zero_mod/X8/Player/PlayerZeroX8.tscn")

var DEBUG: bool = false
var teleport_to_boss: bool = false
var delay: float = 0.0
var hold_reset: float = 0.0

var new_game: bool = true
var NO_MOVEMENT_CHALLENGE: bool = false

var player_count: int = 1
const min_player_count: int = 1
const max_player_count: int = 3

var ultimate_x_armor: bool = false
var black_zero_armor: bool = false
var white_axl_armor: bool = false


var betazero_unlocked: bool = false
var betazero_activated: bool = false
var nightshade_zero_armor: bool = false


var started_fresh_game: bool = false
var only_zero: bool = false
var custom_zero_armor: bool = false
var custom_zero_unlocked: bool = false

var tenshouha_active: bool = true
var juuhazan_active: bool = true
var rasetsusen_active: bool = true
var raikousen_active: bool = true
var youdantotsu_active: bool = true
var rekkyoudan_active: bool = true
var hyouryuushou_active: bool = true
var enkoujin_active: bool = true


# Character/team management stuff

var current_player_character: String = "X"

var valid_players: Array = ["X", "Zero", "Axl"]

var equipped_hearts: Dictionary = {"X": 1, "Zero": 2, "Axl": 3}

var both_alive = true
var alive_team: Array = []

# Strings here instead of literal objects
export var current_team: Array = []
var max_team_size: int = 2


func on_character_switch_end():
	if not GameManager.player.is_on_floor():
		# Reset horizontal velocity and remove dash/jump/hover abilities from the switching character
		GameManager.player.dashfall = false
		GameManager.player.max_out_air_abilities()

	GameManager.player.pause_mode = PAUSE_MODE_INHERIT
	GameManager.inactive_player.pause_mode = PAUSE_MODE_INHERIT
	GameManager.unpause("CharacterSwitch")


func set_player_equipped_hearts(name: String, num_to_equip: int) -> void:
	equipped_hearts[name] = num_to_equip

func add_player_to_team(new_player: String) -> void:
	if new_player in valid_players and current_team.size() < max_team_size:
		current_team.append(new_player)

func remove_player_from_team(player_to_remove: String) -> void:
	current_team.erase(player_to_remove)


func set_player_character(character) -> void :
	match character:
		"Player":
			player_count = 0
		"X":
			player_count = 1
		"Axl":
			player_count = 2
		"Zero":
			player_count = 3
		_:
			player_count = 0
	current_player_character = character;

func assign_name_to_player_counter(count) -> void :
	var _player_ins = _PLAYER.instance()
	if count == 0:
		_player_ins = _PLAYER.instance()
	elif count == 1:
		_player_ins = _X.instance()
		if ultimate_x_armor:
			_player_ins = _X_Ultimate.instance()
	elif count == 2:
		_player_ins = _Axl.instance()
	elif count == 3:
		_player_ins = _Zero.instance()
	current_player_character = _player_ins.name
	_player_ins.queue_free()

func get_player_character_object(character_str) -> PackedScene:
	match character_str:
		"Player":
			return _PLAYER
		"X":
			if ultimate_x_armor:
				return _X_Ultimate
			return _X
		"Axl":
			return _Axl
		"Zero":
			if betazero_activated:
				return _Zero_Beta
			return _Zero
		_:
			return _PLAYER

func get_player_character_string() -> String:
	return current_player_character

#######

var elevator_walls_y: float = 0.0
var credits_seen: bool = false

var CURRENT_EVENT: int = 0
var EVENT_MESSAGE: String = ""

var DISCLAIMER_ACCPETED: bool = false
var DISCLAIMER_EU: bool = false
var LOGGED_IN: bool = false


var touch_controls: bool = false
func is_Android() -> bool:
	if OS.get_name() == "Android":
		return true
	return false
func touch_controls_enabled() -> bool:
	if is_Android():
		return touch_controls
	return false


const char_data: String = "user://char_data"
func _save() -> void :
	var save_data = {
		"player_count": player_count, 
		"current_player_character": current_player_character, 
		"current_team": current_team,
		"credits_seen": credits_seen, 
		
		"new_game": new_game, 
		"beaten_hard": beaten_hard, 
		"beaten_insanity": beaten_insanity, 
		"beaten_ninjagaiden": beaten_ninjagaiden,
		"custom_zero_unlocked": custom_zero_unlocked,
		"custom_zero_armor": custom_zero_armor,
		"beta_zero_unlocked": betazero_unlocked, 
		"beta_zero_activated": betazero_activated, 
		
		"ultimate_x_armor": ultimate_x_armor, 
		"black_zero_armor": black_zero_armor, 
		"white_axl_armor": white_axl_armor, 
	}
	var bson = BSON.to_bson(save_data)
	
	var file = File.new()
	if file.open(char_data, File.WRITE) == OK:
		file.store_buffer(bson)
		file.close()

func _load() -> void :
	var file = File.new()
	if file.file_exists(char_data):
		file.open(char_data, File.READ)
		var bson = file.get_buffer(file.get_len())
		file.close()
		
		var save_data = BSON.from_bson(bson)
		
		if typeof(save_data) == TYPE_DICTIONARY:
			player_count = int(save_data.get("player_count", 1))
			current_player_character = save_data.get("current_player_character", "X")
			current_team = save_data.get("current_team", ["X", "Zero"])
			credits_seen = bool(save_data.get("credits_seen", false))
			
			new_game = bool(save_data.get("new_game", true))
			beaten_hard = bool(save_data.get("beaten_hard", false))
			beaten_insanity = bool(save_data.get("beaten_insanity", false))
			beaten_ninjagaiden = bool(save_data.get("beaten_ninjagaiden",false))
			
			betazero_unlocked = bool(save_data.get("beta_zero_unlocked", false))
			betazero_activated = bool(save_data.get("beta_zero_activated", false))
			
			custom_zero_unlocked = bool(save_data.get("custom_zero_unlocked",false))
			custom_zero_armor = bool(save_data.get("custom_zero_armor",false))
			
			if "ultima_head" in GameManager.collectibles:
				if evaluate_ultimate_armor_state():
					ultimate_x_armor = bool(save_data.get("ultimate_x_armor", false))
			else:
				ultimate_x_armor = false
			if "black_zero_armor" in GameManager.collectibles:
				black_zero_armor = bool(save_data.get("black_zero_armor", false))
			else:
				black_zero_armor = false
			if "white_axl_armor" in GameManager.collectibles:
				white_axl_armor = bool(save_data.get("white_axl_armor", false))
			else:
				white_axl_armor = false
	update_game_mode()
	check_for_deactivated_skills_Zero()
	
	

func evaluate_ultimate_armor_state() -> bool:
	var required_parts = ["head", "body", "arms", "legs"]
	var found_parts = []
	var i = GameManager.collectibles.size() - 1
	while i >= 0 and found_parts.size() < 4:
		var item = GameManager.collectibles[i]
		if item.begins_with("icarus") or item.begins_with("hermes"):
			return false
		if item.begins_with("ultima"):
			var part = get_body_part_name(item)
			if part in found_parts:
				return false
			found_parts.append(part)
		i -= 1
		
	if found_parts.size() == 4 and found_parts.sort() == required_parts.sort():
		return true
	return false

func get_body_part_name(collectible_name: String) -> String:
	if collectible_name.length() <= 4:
		return collectible_name
	return collectible_name.substr(7)


func _ready() -> void :

	set_process(true)
	pause_mode = PAUSE_MODE_PROCESS
	Event.listen("character_switch_end", self, "on_character_switch_end")

func _process(_delta: float) -> void :
	if started_fresh_game:
		if game_mode >= 3:
			if current_player_character != "Zero":
				only_zero = false



var beaten_hard: bool = false
var beaten_insanity: bool = false
var beaten_ninjagaiden: bool = false
var game_mode_set: bool = false
var damage_deal_multiplier: float = 1.0
var damage_get_multiplier: float = 1.0
var boss_ai_multiplier: float = 1.0
var boss_damage_reduction: float = 1.0
var game_mode: int = 0
var GAME_MODE: String = ""
var game_mode_stats: Dictionary = {
	- 1: {"deal": 1.0, "get": 0.75, "bossai": 2.0, "bossreduction": 0.75}, 
		0: {"deal": 1.0, "get": 1.0, "bossai": 1.0, "bossreduction": 0.5}, 
		1: {"deal": 0.8, "get": 1.2, "bossai": 0.8, "bossreduction": 0.25}, 
		2: {"deal": 0.5, "get": 1.5, "bossai": 0.5, "bossreduction": 0.0}, 
		3: {"deal": 0.5, "get": 5.0, "bossai": 0.0, "bossreduction": 0.0}
}
func update_game_mode() -> void :
	
	if game_mode == - 1:
		GAME_MODE = "GAME_START_ROOKIE"
		set_drop_rate(75, 10, 35, 5, 15, 1)
	elif game_mode == 0:
		GAME_MODE = "GAME_START_NORMAL"
		set_drop_rate(25, 30, 15, 15, 10, 0.1)
	elif game_mode == 1:
		GAME_MODE = "GAME_START_HARD"
		set_drop_rate(15, 20, 10, 10, 10, 0.1)
	elif game_mode == 2:
		GAME_MODE = "GAME_START_INSANITY"
		set_drop_rate(5, 10, 5, 10, 5, 0)
	elif game_mode >= 3:
		GAME_MODE = "GAME_START_NINJA"
		set_drop_rate(0, 0, 0, 0, 0, 0)
	var stats = game_mode_stats.get(game_mode, {"deal": 1.0, "get": 1.0, "bossai": 1.0, "bossreduction": 1.0})
	damage_deal_multiplier = stats["deal"]
	damage_get_multiplier = stats["get"]
	boss_ai_multiplier = stats["bossai"]
	boss_damage_reduction = stats["bossreduction"]

func set_drop_rate(
	drop_item_chance = 25, 
	small_health_chance = 30, 
	big_health_chance = 15, 
	small_ammo_chance = 15, 
	big_ammo_chance = 10, 
	extra_life_chance = 0.1
) -> void :
	GameManager.drop_item_chance_default = drop_item_chance
	GameManager.small_health_chance_default = small_health_chance
	GameManager.big_health_chance_default = big_health_chance
	GameManager.small_ammo_chance_default = small_ammo_chance
	GameManager.big_ammo_chance_default = big_ammo_chance
	GameManager.extra_life_chance_default = extra_life_chance


func add_all_armors() -> void :
	
	GameManager.add_collectible_to_savedata("icarus_head")
	GameManager.add_collectible_to_savedata("icarus_body")
	GameManager.add_collectible_to_savedata("icarus_arms")
	GameManager.add_collectible_to_savedata("icarus_legs")
	GameManager.add_collectible_to_savedata("hermes_head")
	GameManager.add_collectible_to_savedata("hermes_body")
	GameManager.add_collectible_to_savedata("hermes_arms")
	GameManager.add_collectible_to_savedata("hermes_legs")
	GameManager.add_collectible_to_savedata("ultima_head")
	GameManager.add_collectible_to_savedata("ultima_body")
	GameManager.add_collectible_to_savedata("ultima_arms")
	GameManager.add_collectible_to_savedata("ultima_legs")
	GameManager.add_collectible_to_savedata("black_zero_armor")
	GameManager.add_collectible_to_savedata("white_axl_armor")

func add_subtanks() -> void :
	GameManager.add_collectible_to_savedata("subtank_trilobyte")
	GameManager.add_collectible_to_savedata("subtank_sunflower")
	GameManager.add_collectible_to_savedata("subtank_yeti")
	GameManager.add_collectible_to_savedata("subtank_rooster")

func add_hearttanks() -> void :
	GameManager.add_collectible_to_savedata("life_up_panda")
	GameManager.add_collectible_to_savedata("life_up_sunflower")
	GameManager.add_collectible_to_savedata("life_up_trilobyte")
	GameManager.add_collectible_to_savedata("life_up_manowar")
	GameManager.add_collectible_to_savedata("life_up_yeti")
	GameManager.add_collectible_to_savedata("life_up_rooster")
	GameManager.add_collectible_to_savedata("life_up_antonion")
	GameManager.add_collectible_to_savedata("life_up_mantis")

func remove_all_zero_weapons() -> void :
	GameManager.remove_collectible_from_savedata("b_fan_zero")
	GameManager.remove_collectible_from_savedata("d_glaive_zero")
	GameManager.remove_collectible_from_savedata("k_knuckle_zero")
	GameManager.remove_collectible_from_savedata("t_breaker_zero")

func clear_subtanks() -> void :
	GameManager.remove_collectible_from_savedata("subtank_trilobyte")
	GameManager.remove_collectible_from_savedata("subtank_sunflower")
	GameManager.remove_collectible_from_savedata("subtank_yeti")
	GameManager.remove_collectible_from_savedata("subtank_rooster")

func clear_hearttanks() -> void :
	GameManager.remove_collectible_from_savedata("life_up_panda")
	GameManager.remove_collectible_from_savedata("life_up_sunflower")
	GameManager.remove_collectible_from_savedata("life_up_trilobyte")
	GameManager.remove_collectible_from_savedata("life_up_manowar")
	GameManager.remove_collectible_from_savedata("life_up_yeti")
	GameManager.remove_collectible_from_savedata("life_up_rooster")
	GameManager.remove_collectible_from_savedata("life_up_antonion")
	GameManager.remove_collectible_from_savedata("life_up_mantis")


func unlocked_boss_weapon() -> bool:
	if is_instance_valid(GameManager.player):
		var shot = GameManager.player.get_node("Shot")
		if GameManager.player.name == "Axl":
			for child in shot.get_children():
				if child is WeaponBossAxl:
					if child.active:
						return true
	return false

func reset_material(material: ShaderMaterial) -> void :
	if material != null:
		var new_material = ShaderMaterial.new()
		new_material.shader = material.shader
		material = new_material

func set_axl_colors(node) -> void :
	if white_axl_armor:
		set_white_axl_colors(node)
	else:
		set_axl_normal_colors(node)
	
func set_axl_normal_colors(node) -> void :
	reset_material(node.material)
	if node != null:
		node.material.set_shader_param("R_MainColor1", Color("#51688c"))
		node.material.set_shader_param("R_MainColor2", Color("#404964"))
		node.material.set_shader_param("R_MainColor3", Color("#2d3344"))
		node.material.set_shader_param("R_MainColor4", Color("#b0b0b0"))
		node.material.set_shader_param("R_MainColor5", Color("#807880"))
		node.material.set_shader_param("R_MainColor6", Color("#605960"))
		
		node.material.set_shader_param("R_CrystalColor1", Color("#f8f8f8"))
		node.material.set_shader_param("R_CrystalColor2", Color("#4f8eee"))
		node.material.set_shader_param("R_CrystalColor3", Color("#1258c2"))
		
		node.material.set_shader_param("R_HairColor1", Color("#ff6318"))
		node.material.set_shader_param("R_HairColor2", Color("#ce3910"))
		node.material.set_shader_param("R_HairColor3", Color("#8c2900"))
		
		node.material.set_shader_param("R_YellowColor1", Color("#f8d820"))
		node.material.set_shader_param("R_YellowColor2", Color("#cb8925"))
		node.material.set_shader_param("R_RedColor1", Color("#db3b3d"))
		node.material.set_shader_param("R_RedColor2", Color("#8c1a1f"))
		
		node.material.set_shader_param("R_FlameColor1", Color("#ef6649"))
		node.material.set_shader_param("R_FlameColor2", Color("#c72c23"))
		node.material.set_shader_param("R_FlameColor3", Color("#9f221c"))

func set_white_axl_colors(node) -> void :
	reset_material(node.material)
	if node != null:
		node.material.set_shader_param("R_MainColor1", Color("#DCE0FF"))
		node.material.set_shader_param("R_MainColor2", Color("#A0A8BC"))
		node.material.set_shader_param("R_MainColor3", Color("#4C5870"))
		node.material.set_shader_param("R_MainColor4", Color("#C6B0CE"))
		node.material.set_shader_param("R_MainColor5", Color("#AB89AC"))
		node.material.set_shader_param("R_MainColor6", Color("#7E6380"))
		node.material.set_shader_param("R_CrystalColor1", Color("#f8f8f8"))
		node.material.set_shader_param("R_CrystalColor2", Color("#63E2EA"))
		node.material.set_shader_param("R_CrystalColor3", Color("#50B5F4"))
		node.material.set_shader_param("R_HairColor1", Color("#AA77DB"))
		node.material.set_shader_param("R_HairColor2", Color("#8C59BD"))
		node.material.set_shader_param("R_HairColor3", Color("#6318A5"))
		node.material.set_shader_param("R_YellowColor1", Color("#0DD84A"))
		node.material.set_shader_param("R_YellowColor2", Color("#0E9F39"))
		node.material.set_shader_param("R_RedColor1", Color("#8C59BD"))
		node.material.set_shader_param("R_RedColor2", Color("#6318A5"))
		node.material.set_shader_param("R_FlameColor1", Color("#A269DB"))
		node.material.set_shader_param("R_FlameColor2", Color("#731DC4"))
		node.material.set_shader_param("R_FlameColor3", Color("#4F1487"))


func set_zero_colors(node):
	if black_zero_armor:
		set_black_zero_colors(node)
	else:
		set_zero_normal_colors(node)
	
func set_zero_normal_colors(node) -> void :
	reset_material(node.material)
	if node != null:
		node.material.set_shader_param("R_AuraColor", Color("#cc1b00"))
		node.material.set_shader_param("R_LightRedColor1", Color("#ff5959"))
		node.material.set_shader_param("R_MainColor1", Color("#e02000"))
		node.material.set_shader_param("R_MainColor2", Color("#a02000"))
		node.material.set_shader_param("R_MainColor3", Color("#602000"))
		node.material.set_shader_param("R_MainColor4", Color("#e0c000"))
		node.material.set_shader_param("R_MainColor5", Color("#a06000"))
		node.material.set_shader_param("R_MainColor6", Color("#6f4200"))
		
		node.material.set_shader_param("R_CrystalColor1", Color("#f8f8f8"))
		node.material.set_shader_param("R_CrystalColor2", Color("#60a0e0"))
		node.material.set_shader_param("R_CrystalColor3", Color("#0040a0"))
		
		node.material.set_shader_param("R_GreenColor1", Color("#40e040"))
		node.material.set_shader_param("R_GreenColor2", Color("#20a020"))
		
		node.material.set_shader_param("R_OutlineColor", Color("#202020"))
		
		node.material.set_shader_param("R_SaberColor0", Color("#e7e7e7"))
		node.material.set_shader_param("R_SaberColor1", Color("#a0e080"))
		node.material.set_shader_param("R_SaberColor2", Color("#60e040"))
		node.material.set_shader_param("R_SaberColor3", Color("#40c040"))
		node.material.set_shader_param("R_SaberColor4", Color("#42a542"))
		
		node.material.set_shader_param("R_HairColor", Color("#6f4200"))

func set_black_zero_colors(node) -> void :
	reset_material(node.material)
	if node != null:
		
		node.material.set_shader_param("R_AuraColor", Color("#a068c0"))
		
		node.material.set_shader_param("R_LightRedColor1", Color("#595959"))
		node.material.set_shader_param("R_MainColor1", Color("#484848"))
		node.material.set_shader_param("R_MainColor2", Color("#303030"))
		node.material.set_shader_param("R_MainColor3", Color("#181818"))

		node.material.set_shader_param("R_MainColor4", Color("#c8b898"))
		node.material.set_shader_param("R_MainColor5", Color("#a88868"))
		node.material.set_shader_param("R_MainColor6", Color("#786050"))
		node.material.set_shader_param("R_HairColor", Color("#786050"))

		node.material.set_shader_param("R_CrystalColor1", Color("#f8f8f8"))
		node.material.set_shader_param("R_CrystalColor2", Color("#60a0e0"))
		node.material.set_shader_param("R_CrystalColor3", Color("#0040a0"))

		node.material.set_shader_param("R_GreenColor1", Color("#40e040"))
		node.material.set_shader_param("R_GreenColor2", Color("#20a020"))

		node.material.set_shader_param("R_OutlineColor", Color("#0e111e"))

		node.material.set_shader_param("R_SaberColor0", Color("#e7e7e7"))
		node.material.set_shader_param("R_SaberColor1", Color("#e0d0e8"))
		node.material.set_shader_param("R_SaberColor2", Color("#c8b0d8"))
		node.material.set_shader_param("R_SaberColor3", Color("#b888d0"))
		node.material.set_shader_param("R_SaberColor4", Color("#a068c0"))

func set_fake_zero_colors(node) -> void :
	reset_material(node.material)
	if node != null:
		node.material.set_shader_param("R_AuraColor", Color("#941008"))
		node.material.set_shader_param("R_LightRedColor1", Color("#606860"))
		node.material.set_shader_param("R_MainColor1", Color("#606860"))
		node.material.set_shader_param("R_MainColor2", Color("#384838"))
		node.material.set_shader_param("R_MainColor3", Color("#203028"))
		node.material.set_shader_param("R_MainColor4", Color("#a0a0a0"))
		node.material.set_shader_param("R_MainColor5", Color("#787878"))
		node.material.set_shader_param("R_MainColor6", Color("#515151"))
		
		node.material.set_shader_param("R_CrystalColor1", Color("#f8f0d8"))
		node.material.set_shader_param("R_CrystalColor2", Color("#f03000"))
		node.material.set_shader_param("R_CrystalColor3", Color("#a03008"))
		
		node.material.set_shader_param("R_GreenColor1", Color("#48e048"))
		node.material.set_shader_param("R_GreenColor2", Color("#30a030"))
		
		node.material.set_shader_param("R_OutlineColor", Color("#201818"))
		
		node.material.set_shader_param("R_SaberColor0", Color("#f7efd8"))
		node.material.set_shader_param("R_SaberColor1", Color("#e67d7a"))
		node.material.set_shader_param("R_SaberColor2", Color("#e71008"))
		node.material.set_shader_param("R_SaberColor3", Color("#941008"))
		node.material.set_shader_param("R_SaberColor4", Color("#521008"))
		
		node.material.set_shader_param("R_HairColor", Color("#545454"))


func set_saber_colors(node) -> void :
	if rekkyoudan_active:
		if black_zero_armor:
			set_saber_red(node)
		else:
			set_saber_yellow(node)
	else:
		if black_zero_armor:
			set_saber_purple(node)
		else:
			set_saber_green(node)

func set_saber_green(node) -> void :
	if node != null:
		node.material.set_shader_param("R_SaberColor0", Color("#e7e7e7"))
		node.material.set_shader_param("R_SaberColor1", Color("#a0e080"))
		node.material.set_shader_param("R_SaberColor2", Color("#60e040"))
		node.material.set_shader_param("R_SaberColor3", Color("#40c040"))
		node.material.set_shader_param("R_SaberColor4", Color("#42a542"))
func set_saber_yellow(node) -> void :
	if node != null:
		node.material.set_shader_param("R_SaberColor0", Color("#e7e7e7"))
		node.material.set_shader_param("R_SaberColor1", Color("#e0e080"))
		node.material.set_shader_param("R_SaberColor2", Color("#e0db40"))
		node.material.set_shader_param("R_SaberColor3", Color("#c0ab40"))
		node.material.set_shader_param("R_SaberColor4", Color("#a59542"))
		
func set_saber_purple(node) -> void :
	if node != null:
		node.material.set_shader_param("R_SaberColor0", Color("#e7e7e7"))
		node.material.set_shader_param("R_SaberColor1", Color("#e0d0e8"))
		node.material.set_shader_param("R_SaberColor2", Color("#c8b0d8"))
		node.material.set_shader_param("R_SaberColor3", Color("#b888d0"))
		node.material.set_shader_param("R_SaberColor4", Color("#a068c0"))
func set_saber_red(node) -> void :
	if node != null:
		node.material.set_shader_param("R_SaberColor0", Color("#ff9699"))
		node.material.set_shader_param("R_SaberColor1", Color("#ff5d62"))
		node.material.set_shader_param("R_SaberColor2", Color("#ed0715"))
		node.material.set_shader_param("R_SaberColor3", Color("#bc1819"))
		node.material.set_shader_param("R_SaberColor4", Color("#af0000"))



func set_zeroX8_colors(node) -> void :
	set_zeroX8_normal_colors(node)
	if black_zero_armor:
		set_black_zeroX8_colors(node)
	if nightshade_zero_armor:
		set_nightshade_zeroX8_colors(node)
	if custom_zero_armor:
		set_custom_zeroX8_colors(node)

func set_zeroX8_normal_colors(node) -> void :
	reset_material(node.material)
	if node != null:
		
		node.material.set_shader_param("R_LightRedColor1", Color("#ff5959"))
		node.material.set_shader_param("R_MainColor1", Color("#f03000"))
		node.material.set_shader_param("R_MainColor2", Color("#a02000"))
		node.material.set_shader_param("R_MainColor3", Color("#602000"))
		
		node.material.set_shader_param("R_LightHairColor", Color("#e0e0e0"))
		node.material.set_shader_param("R_MainColor4", Color("#f0c818"))
		node.material.set_shader_param("R_MainColor5", Color("#b07000"))
		node.material.set_shader_param("R_MainColor6", Color("#6b3118"))
		
		node.material.set_shader_param("R_CrystalColor1", Color("#f8f8f8"))
		node.material.set_shader_param("R_CrystalColor2", Color("#158eff"))
		node.material.set_shader_param("R_CrystalColor3", Color("#0545dc"))
		
		node.material.set_shader_param("R_OutlineColor", Color("#202020"))
		
		node.material.set_shader_param("R_ChestColor1", Color("#e8ffe9"))
		node.material.set_shader_param("R_ChestColor2", Color("#40e040"))
		node.material.set_shader_param("R_ChestColor3", Color("#20a020"))
		
		node.material.set_shader_param("R_ArmorColor1", Color("#f0c818"))
		node.material.set_shader_param("R_ArmorColor2", Color("#b07000"))
		node.material.set_shader_param("R_ArmorColor3", Color("#7c4f00"))
		
		node.material.set_shader_param("R_GreyColor1", Color("#e0e0e0"))
		node.material.set_shader_param("R_GreyColor2", Color("#a0a0a0"))
		node.material.set_shader_param("R_GreyColor3", Color("#606060"))
		node.material.set_shader_param("R_GreyColor4", Color("#444444"))
		
		node.material.set_shader_param("R_SkinColor1", Color("#f8b080"))
		node.material.set_shader_param("R_SkinColor2", Color("#b86048"))
		node.material.set_shader_param("R_SkinColor3", Color("#6b3118"))
		
		
		node.material.set_shader_param("R_SaberColor1", Color("#e8ffe9"))
		node.material.set_shader_param("R_SaberColor2", Color("#a5e7a5"))
		node.material.set_shader_param("R_SaberColor3", Color("#63e763"))
		node.material.set_shader_param("R_SaberColor4", Color("#42c642"))

func set_black_zeroX8_colors(node) -> void :
	reset_material(node.material)
	if node != null:
		
		node.material.set_shader_param("R_LightRedColor1", Color("#595959"))
		node.material.set_shader_param("R_MainColor1", Color("#484848"))
		node.material.set_shader_param("R_MainColor2", Color("#303030"))
		node.material.set_shader_param("R_MainColor3", Color("#181818"))
		
		node.material.set_shader_param("R_LightHairColor", Color("#ffffff"))
		node.material.set_shader_param("R_MainColor4", Color("#e0e0e0"))
		node.material.set_shader_param("R_MainColor5", Color("#a0a0a0"))
		node.material.set_shader_param("R_MainColor6", Color("#606060"))
		
		node.material.set_shader_param("R_CrystalColor1", Color("#e7e7e7"))
		node.material.set_shader_param("R_CrystalColor2", Color("#28c898"))
		node.material.set_shader_param("R_CrystalColor3", Color("#186868"))
		
		node.material.set_shader_param("R_OutlineColor", Color("#0e111e"))
		
		node.material.set_shader_param("R_ChestColor1", Color("#e7e7e7"))
		node.material.set_shader_param("R_ChestColor2", Color("#28c898"))
		node.material.set_shader_param("R_ChestColor3", Color("#186868"))
		
		node.material.set_shader_param("R_ArmorColor1", Color("#c8b898"))
		node.material.set_shader_param("R_ArmorColor2", Color("#a88868"))
		node.material.set_shader_param("R_ArmorColor3", Color("#725c47"))
		
		node.material.set_shader_param("R_GreyColor1", Color("#e0e0e0"))
		node.material.set_shader_param("R_GreyColor2", Color("#a0a0a0"))
		node.material.set_shader_param("R_GreyColor3", Color("#606060"))
		node.material.set_shader_param("R_GreyColor4", Color("#444444"))
		
		node.material.set_shader_param("R_SkinColor1", Color("#f8b080"))
		node.material.set_shader_param("R_SkinColor2", Color("#b86048"))
		node.material.set_shader_param("R_SkinColor3", Color("#6b3118"))

		
		node.material.set_shader_param("R_SaberColor1", Color("#c8b0d8"))
		node.material.set_shader_param("R_SaberColor2", Color("#b888d0"))
		node.material.set_shader_param("R_SaberColor3", Color("#a068c0"))
		node.material.set_shader_param("R_SaberColor4", Color("#5F3F72"))

func set_nightshade_zeroX8_colors(node) -> void :
	reset_material(node.material)
	if node != null:
		
		node.material.set_shader_param("R_LightRedColor1", Color("#595959"))
		node.material.set_shader_param("R_MainColor1", Color("#403838"))
		node.material.set_shader_param("R_MainColor2", Color("#282020"))
		node.material.set_shader_param("R_MainColor3", Color("#181818"))
		
		node.material.set_shader_param("R_LightHairColor", Color("#ffffff"))
		node.material.set_shader_param("R_MainColor4", Color("#e0e0e0"))
		node.material.set_shader_param("R_MainColor5", Color("#a0a0a0"))
		node.material.set_shader_param("R_MainColor6", Color("#606060"))
		
		node.material.set_shader_param("R_CrystalColor1", Color("#e7e7e7"))
		node.material.set_shader_param("R_CrystalColor2", Color("#FFD731"))
		node.material.set_shader_param("R_CrystalColor3", Color("#F39428"))
		
		node.material.set_shader_param("R_OutlineColor", Color("#0e111e"))
		
		node.material.set_shader_param("R_ChestColor1", Color("#e7e7e7"))
		node.material.set_shader_param("R_ChestColor2", Color("#FFD731"))
		node.material.set_shader_param("R_ChestColor3", Color("#F39428"))
		
		node.material.set_shader_param("R_ArmorColor1", Color("#4A57CF"))
		node.material.set_shader_param("R_ArmorColor2", Color("#2A3091"))
		node.material.set_shader_param("R_ArmorColor3", Color("#181C6B"))
		
		node.material.set_shader_param("R_GreyColor1", Color("#e0e0e0"))
		node.material.set_shader_param("R_GreyColor2", Color("#a0a0a0"))
		node.material.set_shader_param("R_GreyColor3", Color("#606060"))
		node.material.set_shader_param("R_GreyColor4", Color("#444444"))
		
		node.material.set_shader_param("R_SkinColor1", Color("#f8b080"))
		node.material.set_shader_param("R_SkinColor2", Color("#b86048"))
		node.material.set_shader_param("R_SkinColor3", Color("#6b3118"))

		
		node.material.set_shader_param("R_SaberColor1", Color("#c8b0d8"))
		node.material.set_shader_param("R_SaberColor2", Color("#b888d0"))
		node.material.set_shader_param("R_SaberColor3", Color("#a068c0"))
		node.material.set_shader_param("R_SaberColor4", Color("#5F3F72"))

func set_white_zeroX8_colors(node) -> void :
	reset_material(node.material)
	if node != null:
		
		node.material.set_shader_param("R_LightRedColor1", Color("#ffffff"))
		node.material.set_shader_param("R_MainColor1", Color("#e0e0e0"))
		node.material.set_shader_param("R_MainColor2", Color("#a0a0a0"))
		node.material.set_shader_param("R_MainColor3", Color("#606060"))
		
		node.material.set_shader_param("R_LightHairColor", Color("#595959"))
		node.material.set_shader_param("R_MainColor4", Color("#484848"))
		node.material.set_shader_param("R_MainColor5", Color("#303030"))
		node.material.set_shader_param("R_MainColor6", Color("#181818"))
		
		node.material.set_shader_param("R_CrystalColor1", Color("#ff5959"))
		node.material.set_shader_param("R_CrystalColor2", Color("#f03000"))
		node.material.set_shader_param("R_CrystalColor3", Color("#a02000"))
		
		node.material.set_shader_param("R_OutlineColor", Color("#0e111e"))
		
		node.material.set_shader_param("R_ChestColor1", Color("#E7A5E7"))
		node.material.set_shader_param("R_ChestColor2", Color("#E763E7"))
		node.material.set_shader_param("R_ChestColor3", Color("#C642C6"))
		
		node.material.set_shader_param("R_ArmorColor1", Color("#f0c818"))
		node.material.set_shader_param("R_ArmorColor2", Color("#b07000"))
		node.material.set_shader_param("R_ArmorColor3", Color("#7c4f00"))
		
		node.material.set_shader_param("R_GreyColor1", Color("#f0c818"))
		node.material.set_shader_param("R_GreyColor2", Color("#b07000"))
		node.material.set_shader_param("R_GreyColor3", Color("#7c4f00"))
		node.material.set_shader_param("R_GreyColor4", Color("#472D00"))
		
		node.material.set_shader_param("R_SkinColor1", Color("#F2CAAF"))
		node.material.set_shader_param("R_SkinColor2", Color("#C49385"))
		node.material.set_shader_param("R_SkinColor3", Color("#917163"))
		
		node.material.set_shader_param("R_SaberColor4", Color("#a02000"))
		
		node.material.set_shader_param("R_SaberColor2", Color("#E7A5BB"))
		node.material.set_shader_param("R_SaberColor3", Color("#E7638F"))
		node.material.set_shader_param("R_SaberColor4", Color("#C6426E"))

func set_custom_zeroX8_colors(node) -> void :
	var colors = {
		"R_OutlineColor": "#0e111e", 
		
		"R_LightRedColor1": "#C56AF6", 
		"R_MainColor1": "#C56AF6", 
		"R_MainColor2": "#A400D5", 
		"R_MainColor3": "#6A109C", 
		
		"R_LightHairColor": "#F6F6F6", 
		"R_MainColor4": "#F694E6", 
		"R_MainColor5": "#DE4AAC", 
		"R_MainColor6": "#B4007B", 
		
		"R_CrystalColor1": "#F6F6F6", 
		"R_CrystalColor2": "#31DB73", 
		"R_CrystalColor3": "#187B29", 
		
		"R_ChestColor1": "#F6F6F6", 
		"R_ChestColor2": "#40E040", 
		"R_ChestColor3": "#20A020", 
		
		"R_ArmorColor1": "#F694E6", 
		"R_ArmorColor2": "#DE4AAC", 
		"R_ArmorColor3": "#B4007B", 
		
		"R_GreyColor1": "#F6F6F6", 
		"R_GreyColor2": "#9CB4A4", 
		"R_GreyColor3": "#526A5A", 
		"R_GreyColor4": "#526A5A", 
		
		"R_SkinColor1": "#F694E6", 
		"R_SkinColor2": "#DE4AAC", 
		"R_SkinColor3": "#B4007B", 
		
		"R_SaberColor1": "#F0F0F0", 
		"R_SaberColor2": "#A0B0C0", 
		"R_SaberColor3": "#646A84", 
		"R_SaberColor4": "#404060", 
	}

	var file = File.new()
	var path = "user://custom_zero_palette.ini"
	if not file.file_exists(path):
		var default_text = \
		"# You can customize Zero\'s colors by changing the hex values below.\n# Format: ParameterName=HexColor\n# Lines starting with \'#\' are comments and ignored.\n\n# Outline color\nOutline_Color=#4A086A\n\n# Main body colors (light to dark)\nMainBody_Color1=#C56AF6\nMainBody_Color2=#C56AF6\nMainBody_Color3=#A400D5\nMainBody_Color4=#6A109C\n\n# Hair colors (light to dark)\nHair_Color1=#F6F6F6\nHair_Color2=#F694E6\nHair_Color3=#DE4AAC\nHair_Color4=#B4007B\n\n# Head crystal colors (light to dark)\nHeadCrystal_Color1=#F6F6F6\nHeadCrystal_Color2=#31DB73\nHeadCrystal_Color3=#187B29\n\n# Chest crystal colors (light to dark)\nChestCrystal_Color1=#F6F6F6\nChestCrystal_Color2=#40E040\nChestCrystal_Color3=#20A020\n\n# Armor colors (light to dark)\nArmor_Color1=#F694E6\nArmor_Color2=#DE4AAC\nArmor_Color3=#B4007B\n\n# Grey parts colors (light to dark)\nGrey_Color1=#F6F6F6\nGrey_Color2=#9CB4A4\nGrey_Color3=#526A5A\nGrey_Color4=#526A5A\n\n# Skin colors (light to dark)\nSkin_Color1=#F694E6\nSkin_Color2=#DE4AAC\nSkin_Color3=#B4007B\n\n# Saber colors (light to dark)\nSaber_Color1=#F0F0F0\nSaber_Color2=#A0B0C0\nSaber_Color3=#646A84\n# Also used for afterimage effects when dashing\nSaber_Color4=#404060"
		var err = file.open(path, File.WRITE)
		if err == OK:
			file.store_string(default_text)
			file.close()
	
	if file.file_exists(path):
		var err = file.open(path, File.READ)
		if err == OK:
			
			var name_map = {
				"Outline_Color": "R_OutlineColor", 
				
				"MainBody_Color1": "R_LightRedColor1", 
				"MainBody_Color2": "R_MainColor1", 
				"MainBody_Color3": "R_MainColor2", 
				"MainBody_Color4": "R_MainColor3", 
				
				"Hair_Color1": "R_LightHairColor", 
				"Hair_Color2": "R_MainColor4", 
				"Hair_Color3": "R_MainColor5", 
				"Hair_Color4": "R_MainColor6", 
				
				"HeadCrystal_Color1": "R_CrystalColor1", 
				"HeadCrystal_Color2": "R_CrystalColor2", 
				"HeadCrystal_Color3": "R_CrystalColor3", 
				
				"ChestCrystal_Color1": "R_ChestColor1", 
				"ChestCrystal_Color2": "R_ChestColor2", 
				"ChestCrystal_Color3": "R_ChestColor3", 
				
				"Armor_Color1": "R_ArmorColor1", 
				"Armor_Color2": "R_ArmorColor2", 
				"Armor_Color3": "R_ArmorColor3", 
				
				"Grey_Color1": "R_GreyColor1", 
				"Grey_Color2": "R_GreyColor2", 
				"Grey_Color3": "R_GreyColor3", 
				"Grey_Color4": "R_GreyColor4", 
				
				"Skin_Color1": "R_SkinColor1", 
				"Skin_Color2": "R_SkinColor2", 
				"Skin_Color3": "R_SkinColor3", 
				
				"Saber_Color1": "R_SaberColor1", 
				"Saber_Color2": "R_SaberColor2", 
				"Saber_Color3": "R_SaberColor3", 
				"Saber_Color4": "R_SaberColor4"
			}
			
			while not file.eof_reached():
				var line = file.get_line().strip_edges()
				if line == "" or line.begins_with("#"):
					continue
				var parts = line.split("=")
				if parts.size() != 2:
					continue
				var name = parts[0]
				var hex_color = parts[1]
				
				if name_map.has(name):
					var shader_param = name_map[name]
					var color = Color(hex_color)
					node.material.set_shader_param(shader_param, color)
			file.close()



func set_saberX8_colors(node) -> void :
	if rekkyoudan_active:
		set_saberX8_yellow(node)
		if black_zero_armor:
			set_saberX8_red(node)
		if custom_zero_armor:
			set_custom_zeroX8_colors(node)
	else:
		set_saberX8_green(node)
		if black_zero_armor:
			set_saberX8_purple(node)
		if custom_zero_armor:
			set_custom_zeroX8_colors(node)

func set_saberX8_green(node) -> void :
	if node != null:
		node.material.set_shader_param("R_SaberColor1", Color("#e8ffe9"))
		node.material.set_shader_param("R_SaberColor2", Color("#a5e7a5"))
		node.material.set_shader_param("R_SaberColor3", Color("#63e763"))
		node.material.set_shader_param("R_SaberColor4", Color("#42c642"))
func set_saberX8_yellow(node) -> void :
	if node != null:
		node.material.set_shader_param("R_SaberColor1", Color("#ffffff"))
		node.material.set_shader_param("R_SaberColor2", Color("#ffff6f"))
		node.material.set_shader_param("R_SaberColor3", Color("#ffaf3f"))
		node.material.set_shader_param("R_SaberColor4", Color("#bf6d2a"))

func set_saberX8_purple(node) -> void :
	if node != null:
		node.material.set_shader_param("R_SaberColor1", Color("#c8b0d8"))
		node.material.set_shader_param("R_SaberColor2", Color("#b888d0"))
		node.material.set_shader_param("R_SaberColor3", Color("#a068c0"))
		node.material.set_shader_param("R_SaberColor4", Color("#5F3F72"))
func set_saberX8_red(node) -> void :
	if node != null:
		node.material.set_shader_param("R_SaberColor1", Color("#ff5d62"))
		node.material.set_shader_param("R_SaberColor2", Color("#ed0715"))
		node.material.set_shader_param("R_SaberColor3", Color("#8c0000"))
		node.material.set_shader_param("R_SaberColor4", Color("#590000"))

func set_saberX8_aqua(node) -> void :
	if node != null:
		node.material.set_shader_param("R_SaberColor1", Color("#F2FEFF"))
		node.material.set_shader_param("R_SaberColor2", Color("#9AF6FA"))
		node.material.set_shader_param("R_SaberColor3", Color("#52FAFF"))
		node.material.set_shader_param("R_SaberColor4", Color("#23E5EB"))
func set_saberX8_blue(node) -> void :
	if node != null:
		node.material.set_shader_param("R_SaberColor1", Color("#5B6CFF"))
		node.material.set_shader_param("R_SaberColor2", Color("#4A57CF"))
		node.material.set_shader_param("R_SaberColor3", Color("#2A3091"))
		node.material.set_shader_param("R_SaberColor4", Color("#181C6B"))

func set_saberX8_pink(node) -> void :
	if node != null:
		node.material.set_shader_param("R_SaberColor1", Color("#FFE8FE"))
		node.material.set_shader_param("R_SaberColor2", Color("#E7A5E7"))
		node.material.set_shader_param("R_SaberColor3", Color("#E763E7"))
		node.material.set_shader_param("R_SaberColor4", Color("#C642C6"))
func set_saberX8_rose(node) -> void :
	if node != null:
		node.material.set_shader_param("R_SaberColor1", Color("#FFE8EF"))
		node.material.set_shader_param("R_SaberColor2", Color("#E7A5BB"))
		node.material.set_shader_param("R_SaberColor3", Color("#E7638F"))
		node.material.set_shader_param("R_SaberColor4", Color("#C6426E"))


func check_for_deactivated_skills_Zero() -> void :
	remove_deactivated_skills_Zero()
	if "tenshouha_deactivated" in GameManager.collectibles:
		tenshouha_active = false
	if "juuhazan_deactivated" in GameManager.collectibles:
		juuhazan_active = false
	if "rasetsusen_deactivated" in GameManager.collectibles:
		rasetsusen_active = false
	if "raikousen_deactivated" in GameManager.collectibles:
		raikousen_active = false
	if "youdantotsu_deactivated" in GameManager.collectibles:
		youdantotsu_active = false
	if "rekkyoudan_deactivated" in GameManager.collectibles or not "trilobyte_weapon" in GameManager.collectibles:
		rekkyoudan_active = false
	if "hyouryuushou_deactivated" in GameManager.collectibles:
		hyouryuushou_active = false
	if "enkoujin_deactivated" in GameManager.collectibles:
		enkoujin_active = false

func remove_deactivated_skills_Zero() -> void :
	GameManager.remove_collectible_from_savedata("tenshouha_deactivated")
	GameManager.remove_collectible_from_savedata("juuhazan_deactivated")
	GameManager.remove_collectible_from_savedata("rasetsusen_deactivated")
	GameManager.remove_collectible_from_savedata("raikousen_deactivated")
	GameManager.remove_collectible_from_savedata("youdantotsu_deactivated")
	GameManager.remove_collectible_from_savedata("rekkyoudan_deactivated")
	GameManager.remove_collectible_from_savedata("hyouryuushou_deactivated")
	GameManager.remove_collectible_from_savedata("enkoujin_deactivated")



func print_frame_sizes(_sprite):
	if _sprite != null:
		var sprite_frames = _sprite.frames
		var animation_name = _sprite.animation
		var frame_count = sprite_frames.get_frame_count(animation_name)
		
		for i in range(frame_count):
			var frame_texture = sprite_frames.get_frame(animation_name, i)
			var frame_size = frame_texture.get_size()
			
			
			return frame_size

func update_texture(texture: Texture, reference_tex: SpriteFrames):
	var reference_frames: SpriteFrames = reference_tex
	var updated_frames = SpriteFrames.new()
	for animation in reference_frames.get_animation_names():
		if animation != "default":
			updated_frames.add_animation(animation)
			updated_frames.set_animation_speed(animation, reference_frames.get_animation_speed(animation))
			updated_frames.set_animation_loop(animation, reference_frames.get_animation_loop(animation))
			for i in reference_frames.get_frame_count(animation):
				var updated_texture: AtlasTexture = reference_frames.get_frame(animation, i).duplicate()
				updated_texture.atlas = texture
				updated_frames.add_frame(animation, updated_texture)
	updated_frames.remove_animation("default")
	return updated_frames

func update_texture_with_new_size(texture: Texture, reference_tex: SpriteFrames):
	var reference_frames: SpriteFrames = reference_tex
	var updated_frames = SpriteFrames.new()
	
	var new_texture_size = texture.get_size()
	var first_frame_texture: AtlasTexture = reference_frames.get_frame("idle", 0)
	var old_texture_size = first_frame_texture.atlas.get_size()
	var width_scale = new_texture_size.x / old_texture_size.x
	var height_scale = new_texture_size.y / old_texture_size.y
	
	for animation in reference_frames.get_animation_names():
		if animation != "default":
			updated_frames.add_animation(animation)
			updated_frames.set_animation_speed(animation, reference_frames.get_animation_speed(animation))
			updated_frames.set_animation_loop(animation, reference_frames.get_animation_loop(animation))
			
			for i in reference_frames.get_frame_count(animation):
				var old_texture: AtlasTexture = reference_frames.get_frame(animation, i)
				var updated_texture: AtlasTexture = old_texture.duplicate()
				updated_texture.atlas = texture
				
				var old_region = old_texture.region
				var new_region = Rect2(
					old_region.position * Vector2(width_scale, height_scale), 
					old_region.size * Vector2(width_scale, height_scale)
				)
				updated_texture.region = new_region
				updated_frames.add_frame(animation, updated_texture)
			
	updated_frames.remove_animation("default")
	return updated_frames

func update_texture_animations(texture: Texture, reference_tex: SpriteFrames, animations_to_replace: Array) -> SpriteFrames:
	var reference_frames: SpriteFrames = reference_tex
	var updated_frames = SpriteFrames.new()
	
	var new_texture_size = texture.get_size()
	var first_frame_texture: AtlasTexture = reference_frames.get_frame("idle", 0)
	var old_texture_size = first_frame_texture.atlas.get_size()
	var width_scale = new_texture_size.x / old_texture_size.x
	var height_scale = new_texture_size.y / old_texture_size.y
	
	for animation in reference_frames.get_animation_names():
		if animation in animations_to_replace:
			updated_frames.add_animation(animation)
			updated_frames.set_animation_speed(animation, reference_frames.get_animation_speed(animation))
			updated_frames.set_animation_loop(animation, reference_frames.get_animation_loop(animation))
			
			for i in range(reference_frames.get_frame_count(animation)):
				var old_texture: AtlasTexture = reference_frames.get_frame(animation, i)
				var updated_texture: AtlasTexture = old_texture.duplicate()
				updated_texture.atlas = texture
				
				var old_region = old_texture.region
				var new_region = Rect2(
					old_region.position * Vector2(width_scale, height_scale), 
					old_region.size * Vector2(width_scale, height_scale)
				)
				updated_texture.region = new_region
				updated_frames.add_frame(animation, updated_texture)
			
	return updated_frames

func update_texture_specific_animations(texture: Texture, reference_tex: SpriteFrames, animations_to_update: Array):
	var reference_frames: SpriteFrames = reference_tex
	var updated_frames = SpriteFrames.new()
	
	var frames_per_row = 13
	
	for animation in reference_frames.get_animation_names():
		updated_frames.add_animation(animation)
		updated_frames.set_animation_speed(animation, reference_frames.get_animation_speed(animation))
		updated_frames.set_animation_loop(animation, reference_frames.get_animation_loop(animation))
		
		if animation in animations_to_update:
			
			for i in range(reference_frames.get_frame_count(animation)):
				var updated_texture: AtlasTexture = reference_frames.get_frame(animation, i).duplicate()
				updated_texture.atlas = texture
				updated_frames.add_frame(animation, updated_texture)
				
				var x_index = i % frames_per_row
				var y_index = i / frames_per_row
				
		else:
			for i in range(reference_frames.get_frame_count(animation)):
				updated_frames.add_frame(animation, reference_frames.get_frame(animation, i))
	return updated_frames

func get_texture_animation(texture: Texture, reference_tex: SpriteFrames, animations_to_update: Array) -> SpriteFrames:
	var reference_frames: SpriteFrames = reference_tex
	var updated_frames = SpriteFrames.new()
	var frames_per_row = 13
	for animation in reference_frames.get_animation_names():
		updated_frames.add_animation(animation)
		updated_frames.set_animation_speed(animation, reference_frames.get_animation_speed(animation))
		updated_frames.set_animation_loop(animation, reference_frames.get_animation_loop(animation))
		
		if animation in animations_to_update:
			for i in range(reference_frames.get_frame_count(animation)):
				var atlas_texture: AtlasTexture = reference_frames.get_frame(animation, i)
				
				if atlas_texture is AtlasTexture:
					var region = atlas_texture.region
					var frame_x = int(region.position.x / region.size.x)
					var frame_y = int(region.position.y / region.size.y)
					
				var updated_texture: AtlasTexture = atlas_texture.duplicate()
				updated_texture.atlas = texture
				updated_frames.add_frame(animation, updated_texture)
		else:
			for i in range(reference_frames.get_frame_count(animation)):
				updated_frames.add_frame(animation, reference_frames.get_frame(animation, i))
	return updated_frames
	

func process_res_file(input_res_path: String, new_texture_path: String, output_res_path: String, animations_to_skip: Array):
	var sprite_frames = load(input_res_path) as SpriteFrames
	if not sprite_frames:
		return

	var new_texture = load(new_texture_path) as Texture
	if not new_texture:
		return
	
	for animation_name in sprite_frames.get_animation_names():
		if animation_name in animations_to_skip:
			continue
		for i in range(sprite_frames.get_frame_count(animation_name)):
			var frame_texture = sprite_frames.get_frame(animation_name, i)
			if frame_texture is AtlasTexture:
				var atlas_texture = frame_texture as AtlasTexture
				var updated_texture = atlas_texture.duplicate() as AtlasTexture
				updated_texture.atlas = new_texture
				updated_texture.region = atlas_texture.region
				var original_position = atlas_texture.region.position
				var new_position = updated_texture.region.position
				sprite_frames.set_frame(animation_name, i, updated_texture)
	var result = ResourceSaver.save(output_res_path, sprite_frames)


func process_res_file_include(input_res_path: String, new_texture_path: String, output_res_path: String, animations_to_include: Array):
	var sprite_frames = load(input_res_path) as SpriteFrames
	if not sprite_frames:
		return

	var new_texture = load(new_texture_path) as Texture
	if not new_texture:
		return

	for animation_name in sprite_frames.get_animation_names():
		var should_replace = animation_name in animations_to_include
		for i in range(sprite_frames.get_frame_count(animation_name)):
			var frame_texture = sprite_frames.get_frame(animation_name, i)
			if frame_texture is AtlasTexture:
				var old_atlas = frame_texture as AtlasTexture
				var new_atlas = AtlasTexture.new()
				if should_replace:
					new_atlas.atlas = new_texture
				else:
					new_atlas.atlas = old_atlas.atlas
				new_atlas.region = old_atlas.region
				new_atlas.margin = old_atlas.margin
				new_atlas.filter_clip = old_atlas.filter_clip
				sprite_frames.set_frame(animation_name, i, new_atlas)
	var result = ResourceSaver.save(output_res_path, sprite_frames)



func _set_correct_dialogues(dialog_starter, dialogue) -> Resource:
	var _dialog = dialogue
	if dialog_starter == "StartCutscene":
		if current_player_character == "Zero":
			_dialog = load("res://Zero_mod/DialogSystem/Dialogs/Stages/Intro_Dialogue.tres")
		if current_player_character == "Axl":
			_dialog = load("res://Axl_mod/DialogSystem/Dialogs/Stages/Intro_Dialogue.tres")
			
	if dialog_starter == "INTRO_1":
		if current_player_character == "Zero":
			_dialog = load("res://Zero_mod/DialogSystem/Dialogs/Stages/Intro_Dialogue_2.tres")
		if current_player_character == "Axl":
			_dialog = load("res://Axl_mod/DialogSystem/Dialogs/Stages/Intro_Dialogue_2.tres")
	if dialog_starter == "INTRO_2":
		if current_player_character == "Zero":
			_dialog = load("res://Zero_mod/DialogSystem/Dialogs/Stages/Intro_Dialogue_3.tres")
		if current_player_character == "Axl":
			_dialog = load("res://Axl_mod/DialogSystem/Dialogs/Stages/Intro_Dialogue_3.tres")
	if dialog_starter == "INTRO_3":
		if current_player_character == "Zero":
			_dialog = load("res://Zero_mod/DialogSystem/Dialogs/Stages/Intro_Dialogue_4.tres")
		if current_player_character == "Axl":
			_dialog = load("res://Axl_mod/DialogSystem/Dialogs/Stages/Intro_Dialogue_4.tres")
	if dialog_starter == "INTRO_4":
		if current_player_character == "Zero":
			_dialog = load("res://Zero_mod/DialogSystem/Dialogs/Stages/Intro_Dialogue_5.tres")
		if current_player_character == "Axl":
			_dialog = load("res://Axl_mod/DialogSystem/Dialogs/Stages/Intro_Dialogue_5.tres")

	if dialog_starter == "Antonion":
		if current_player_character == "Zero":
			_dialog = load("res://Zero_mod/DialogSystem/Dialogs/Stages/Antonion_Dialogue.tres")
		if current_player_character == "Axl":
			_dialog = load("res://Axl_mod/DialogSystem/Dialogs/Stages/Antonion_Dialogue.tres")
	if dialog_starter == "Manowar":
		if current_player_character == "Zero":
			_dialog = load("res://Zero_mod/DialogSystem/Dialogs/Stages/Manowar_Dialogue.tres")
		if current_player_character == "Axl":
			_dialog = load("res://Axl_mod/DialogSystem/Dialogs/Stages/Manowar_Dialogue.tres")
	if dialog_starter == "Mantis":
		if current_player_character == "Zero":
			_dialog = load("res://Zero_mod/DialogSystem/Dialogs/Stages/Mantis_Dialogue.tres")
		if current_player_character == "Axl":
			_dialog = load("res://Axl_mod/DialogSystem/Dialogs/Stages/Mantis_Dialogue.tres")
	if dialog_starter == "Panda":
		if current_player_character == "Zero":
			_dialog = load("res://Zero_mod/DialogSystem/Dialogs/Stages/Panda_Dialogue.tres")
		if current_player_character == "Axl":
			_dialog = load("res://Axl_mod/DialogSystem/Dialogs/Stages/Panda_Dialogue.tres")
	if dialog_starter == "Rooster":
		if current_player_character == "Zero":
			_dialog = load("res://Zero_mod/DialogSystem/Dialogs/Stages/Rooster_Dialogue.tres")
		if current_player_character == "Axl":
			_dialog = load("res://Axl_mod/DialogSystem/Dialogs/Stages/Rooster_Dialogue.tres")
	if dialog_starter == "Sunflower":
		if current_player_character == "Zero":
			_dialog = load("res://Zero_mod/DialogSystem/Dialogs/Stages/Sunflower_Dialogue.tres")
		if current_player_character == "Axl":
			_dialog = load("res://Axl_mod/DialogSystem/Dialogs/Stages/Sunflower_Dialogue.tres")
	if dialog_starter == "Trilobyte":
		if current_player_character == "Zero":
			_dialog = load("res://Zero_mod/DialogSystem/Dialogs/Stages/Trilobyte_Dialogue.tres")
		if current_player_character == "Axl":
			_dialog = load("res://Axl_mod/DialogSystem/Dialogs/Stages/Trilobyte_Dialogue.tres")
	if dialog_starter == "Yeti":
		if current_player_character == "Zero":
			_dialog = load("res://Zero_mod/DialogSystem/Dialogs/Stages/Yeti_Dialogue.tres")
		if current_player_character == "Axl":
			_dialog = load("res://Axl_mod/DialogSystem/Dialogs/Stages/Yeti_Dialogue.tres")
	
	if dialog_starter == "Vile Booster Forest":
		if current_player_character == "Zero":
			_dialog = load("res://Zero_mod/DialogSystem/Dialogs/Stages/Vile_miniboss_Dialogue.tres")
		if current_player_character == "Axl":
			_dialog = load("res://Axl_mod/DialogSystem/Dialogs/Stages/Vile_miniboss_Dialogue.tres")
	if dialog_starter == "Vile Primrose":
		if current_player_character == "Zero":
			_dialog = load("res://Zero_mod/DialogSystem/Dialogs/Stages/Vile_antonion_Dialogue.tres")
		if current_player_character == "Axl":
			_dialog = load("res://Axl_mod/DialogSystem/Dialogs/Stages/Vile_antonion_Dialogue.tres")
	if dialog_starter == "Vile":
		if current_player_character == "Zero":
			_dialog = load("res://Zero_mod/DialogSystem/Dialogs/Stages/Vile_jakob_Dialogue.tres")
		if current_player_character == "Axl":
			_dialog = load("res://Axl_mod/DialogSystem/Dialogs/Stages/Vile_jakob_Dialogue.tres")
	if dialog_starter == "Vile Final":
		if current_player_character == "Zero":
			_dialog = load("res://Zero_mod/DialogSystem/Dialogs/Stages/Vile_final_Dialogue.tres")
		if current_player_character == "Axl":
			_dialog = load("res://Axl_mod/DialogSystem/Dialogs/Stages/Vile_final_Dialogue.tres")
	
	if dialog_starter == "CopySigma":
		if current_player_character == "Zero":
			_dialog = load("res://Zero_mod/DialogSystem/Dialogs/Stages/CopySigma_Dialogue.tres")
		if current_player_character == "Axl":
			_dialog = load("res://Axl_mod/DialogSystem/Dialogs/Stages/CopySigma_Dialogue.tres")
			
	if dialog_starter == "Sigma":
		if current_player_character == "Zero":
			_dialog = load("res://Zero_mod/DialogSystem/Dialogs/Stages/Sigma_Dialogue.tres")
		if current_player_character == "Axl":
			_dialog = load("res://Axl_mod/DialogSystem/Dialogs/Stages/Sigma_Dialogue.tres")
			
	if dialog_starter == "Lumine":
		if current_player_character == "Zero":
			_dialog = load("res://Zero_mod/DialogSystem/Dialogs/Stages/Lumine_Dialogue.tres")
		if current_player_character == "Axl":
			_dialog = load("res://Axl_mod/DialogSystem/Dialogs/Stages/Lumine_Dialogue.tres")
			
			
	if dialog_starter == "Secret1":
		if current_player_character == "Zero":
			_dialog = load("res://Zero_mod/DialogSystem/Dialogs/Stages/Secret3_Dialogue.tres")
		if current_player_character == "Axl":
			_dialog = load("res://Axl_mod/DialogSystem/Dialogs/Stages/Secret3_Dialogue.tres")
	if dialog_starter == "Secret1Defeated":
		if current_player_character == "Zero":
			_dialog = load("res://Zero_mod/DialogSystem/Dialogs/Stages/Secret3_Def_Dialogue.tres")
		if current_player_character == "Axl":
			_dialog = load("res://Axl_mod/DialogSystem/Dialogs/Stages/Secret3_Def_Dialogue.tres")
			
	if dialog_starter == "Secret2":
		if current_player_character == "Zero":
			_dialog = load("res://Zero_mod/DialogSystem/Dialogs/Stages/Secret2_Dialogue.tres")
		if current_player_character == "Axl":
			_dialog = load("res://Axl_mod/DialogSystem/Dialogs/Stages/Secret2_Dialogue.tres")
	if dialog_starter == "Secret2Defeated":
		if current_player_character == "Zero":
			_dialog = load("res://Zero_mod/DialogSystem/Dialogs/Stages/Secret2_Def_Dialogue.tres")
		if current_player_character == "Axl":
			_dialog = load("res://Axl_mod/DialogSystem/Dialogs/Stages/Secret2_Def_Dialogue.tres")
	return _dialog
