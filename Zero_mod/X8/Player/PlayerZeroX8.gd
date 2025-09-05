extends Character

export  var skip_intro: bool = false

onready var lowjumpcast: Label = $lowjumpcast
onready var saber_node = get_node("Shot")
onready var ability_animation: Resource = preload("res://Zero_mod/X8/Sprites/BossAbilities/ability_effects.tres")

onready var _saber_sprites: Resource = preload("res://Zero_mod/X8/Sprites/zerox8.tres")
onready var _fan_sprites: Resource = preload("res://Zero_mod/X8/Sprites/bfan/bfan.tres")
onready var _glaive_sprites: Resource = preload("res://Zero_mod/X8/Sprites/dglaive/dglaive.tres")
onready var _knuckle_sprites: Resource = preload("res://Zero_mod/X8/Sprites/kknuckle/zerox8knuckle.tres")
onready var _breaker_sprites: Resource = preload("res://Zero_mod/X8/Sprites/tbreaker/tbreaker.tres")
onready var _hanger_sprites: Resource = preload("res://Zero_mod/X8/Sprites/zerox8.tres")
onready var _sigmablade_sprites: Resource = preload("res://Zero_mod/X8/Sprites/zerox8.tres")

onready var rekkyoudan_hitbox = preload("res://Zero_mod/Player/Hitboxes/Rekkyoudan_Hitbox.tscn")
onready var saber_hitbox = preload("res://Zero_mod/Player/Hitboxes/Saber_Hitbox.tscn")
onready var bfan_shield: = get_node("FanShield")

onready var saber_combo: = get_node("SaberCombo")
onready var saber_dash: = get_node("SaberDash")
onready var saber_jump: = get_node("SaberJump")
onready var saber_wall: = get_node("SaberWall")

onready var knuckle_combo: = get_node("KnuckleCombo")
onready var knuckle_dash: = get_node("KnuckleDash")
onready var knuckle_jump: = get_node("KnuckleJump")
onready var knuckle_wall: = get_node("KnuckleWall")

onready var zero_weapons: Array = [
	"Saber", 
	"Knuckle"
]

onready var skill_tenshouha: = get_node("Tenshouha")
onready var skill_juuhazan: = get_node("Juuhazan")
onready var skill_rasetsusen: = get_node("Rasetsusen")
onready var skill_raikousen: = get_node("Raikousen")
onready var skill_youdantotsu: = get_node("Youdantotsu")
onready var skill_hyouryuushou: = get_node("Hyouryuushou")
onready var skill_enkoujin: = get_node("Enkoujin")
onready var skill_enkoukyaku: = get_node("Enkoukyaku")

onready var attack_nodes: Array = [
	saber_combo, 
	saber_dash, 
	saber_jump, 
	saber_wall, 
	knuckle_combo, 
	knuckle_dash, 
	knuckle_jump, 
	knuckle_wall, 
	skill_juuhazan, 
	skill_rasetsusen, 
	skill_raikousen, 
	skill_youdantotsu, 
	skill_hyouryuushou, 
	skill_enkoujin, 
	skill_enkoukyaku
]

var Tenshouha: bool = false
var Juuhazan: bool = false
var Rasetsusen: bool = false
var Rasetsusen_used: bool = false
var Raikousen: bool = false
var Youdantotsu: bool = false
var Rekkyoudan: bool = false
var Hyouryuushou: bool = false
var Hyouryuushou_used: bool = false
var Enkoujin: bool = false
var Enkoukyaku: bool = false

var saber_animations = [
	"saber_1", 
	"saber_2", 
	"saber_3", 
	"saber_dash", 
	"saber_jump", 
	"saber_jump_1", 
	"saber_jump_2", 
	"saber_land", 
	"saber_slide", 
	"juuhazan", 
	"rasetsusen", 
	"tenshouha", 
	"youdantotsu", 
	"hyouryuushou", 
	"hyouryuushou_air", 
	"enkoujin", 
	"raikousen", 
]

var current_armor: Array = ["no_head", "no_body", "no_arms", "no_legs"]
var armor_sprites: Array = []
var flash_timer: float = 0.0
var block_charging: bool = false
var dashfall: bool = false
var dashed: bool = false
var dashjumps_since_jump: int = 0
var raycast_down: RayCast2D
var colliding: bool = true
var using_upgrades: bool = false
var grabbed: bool = false
var ride_eject_delay: float = 0.0
var ride: Node2D

signal walljump
signal wallslide
signal dashjump
signal airdash
signal firedash
signal collected_health(amount)
signal weapon_stasis
signal end_weapon_stasis
signal dry_dash
signal received_damage
signal equipped_armor
signal at_max_hp


func combo_connection_juuhazan() -> bool:
	return false

func combo_connection_raikousen() -> bool:
	if not get_action_pressed("dash"):
		return false
	if get_action_pressed("move_left") or get_action_pressed("move_right") and get_action_pressed("alt_fire"):
		if is_on_floor():
			if saber_node.current_weapon != null:
				var _animation = get_animation()
				if _animation in saber_animations:
					return false
				return true
	return false

func combo_connection_youdantotsu() -> bool:
	return false

func combo_connection_hyouryuushou() -> bool:
	if get_action_pressed("dash"):
		return false
	if saber_node.current_weapon.name == "Saber" or saber_node.current_weapon.name == "D-Glaive":
		var _animation = get_animation()
		if _animation == "saber_1" and animatedSprite.frame >= 7:
			return true
		elif _animation == "saber_2" and animatedSprite.frame >= 7:
			return true
		elif _animation == "saber_3" and animatedSprite.frame >= 8:
			return true






	return false

func deactivate() -> void :
	stop_listening_to_inputs()
	stop_charge()
	stop_shot()
	
func activate() -> void :
	if is_colliding():
		reactivate_charge()
		.activate()
	return

func has_control() -> bool:
	if grabbed:
		return true
	if listening_to_inputs:
		return true
	elif ride:
		return ride.listening_to_inputs
	return false

func is_riding() -> bool:
	return is_instance_valid(ride)

func on_land() -> void :
	dashjumps_since_jump = 0
	dashfall = false
	Rasetsusen_used = false
	Hyouryuushou_used = false
	remove_invulnerability("Enkoukyaku")

func dashjump_signal() -> void :
	emit_signal("dashjump")
	dashjumps_since_jump += 1

func airdash_signal() -> void :
	emit_signal("airdash")

func firedash_signal() -> void :
	emit_signal("firedash")

func stop_charge() -> void :
	for ability in executing_moves:
		if ability.name == "Charge":
			ability.EndAbility()
	block_charging = true

func update_facing_direction() -> void :
	if direction.x < 0:
		facing_right = false;
		Event.emit_signal("player_faced_left")
	elif direction.x > 0:
		facing_right = true;
		Event.emit_signal("player_faced_right")
	if animatedSprite.scale.x != get_facing_direction():
		animatedSprite.scale.x = get_facing_direction()

func reactivate_charge() -> void :
	block_charging = false

func reduce_hitbox() -> void :
	collisor.disabled = true

func increase_hitbox() -> void :
	collisor.disabled = false

func _ready() -> void :
	current_armor = ["no_head", "no_body", "no_arms", "no_legs"]
	Event.listen("collected", self, "equip_parts")
	Event.listen("collected", self, "collect")
	listen("land", self, "on_land")
	equip_zero_parts()
	if is_current_player:
		GameManager.set_player(self)
		Event.call_deferred("emit_signal", "player_set")
	animatedSprite.offset.y = - 2
	change_ride_chaser_sprites()
	if not "z_saber_zero" in GameManager.collectibles:
		GameManager.add_collectible_to_savedata("z_saber_zero")

func change_ride_chaser_sprites() -> void :
	var _texture = load("res://Zero_mod/X8/Sprites/zero_ride_chaser.png")
	var _reference_frames = load("res://Zero_mod/X8/Sprites/zerox8.tres")
	var _replace_animations = [
		"empty", 
	]
	animatedSprite.frames = CharacterManager.update_texture_specific_animations(_texture, _reference_frames, _replace_animations)

func get_armor_sprites() -> Array:
	var sprites = []
	for child in animatedSprite.get_children():
		if "armor" in child.name:
			sprites.append(child)
	return sprites

func _process(delta: float) -> void :
	if skill_rasetsusen.saber_sound.playing and animatedSprite.animation != "rasetsusen":
		skill_rasetsusen.saber_sound.stop()
	if ride_eject_delay >= 0:
		ride_eject_delay -= delta
	process_flash(delta)

func process_flash(delta: float) -> void :
	if flash_timer > 0:
		flash_timer += delta
		if flash_timer > 0.034:
			end_flash()

func equip_zero_parts() -> void :
	var dash = get_node("Dash")
	var airdash = get_node("AirDash")
	var airjump = get_node("AirJump")
	var fall = get_node("Fall")
	dash.invulnerability_duration = 0
	airdash.upgraded = false
	airdash.max_airdashes = 1
	airjump.set_max_air_jumps(1)
	airjump.upgraded = false
	fall.upgraded = false
	
	var lifesteal = get_node("LifeSteal")
	lifesteal.deactivate()
	
	var dmg = get_node("Damage")
	dmg.damage_reduction = 15
	dmg.prevent_knockbacks = false
	dmg.conflicting_moves = ["Death", "WallSlide", "Ride"]
	
	
	dash.horizontal_velocity = 260
	airdash.horizontal_velocity = 260
	saber_dash.horizontal_velocity = 260
	fall.dashjump_speed = 260
	var _afterimage = animatedSprite.get_node("afterImages")
	_afterimage.upgraded = false

	
	if CharacterManager.NO_MOVEMENT_CHALLENGE:
		get_node("Walk").horizontal_velocity = 0.01
		get_node("Jump").horizontal_velocity = 0.01
		get_node("DashJump").horizontal_velocity = 0.01
		get_node("WallJump").horizontal_velocity = 0.01
		get_node("DashWallJump").horizontal_velocity = 0.01
		airjump.horizontal_velocity = 0.01
		airjump.dashjump_speed = 0.01
		airjump.fall_base_velocity = 0.01
		dash.horizontal_velocity = 0.01
		airdash.horizontal_velocity = 0.01
		fall.horizontal_velocity = 0.01
		fall.dashjump_speed = 0.01
		fall.fall_base_velocity = 0.01
	
	
	var dmg_multiplikator = 1.0
	for _saber_node in attack_nodes:
		_saber_node.hitbox_extra_damage = dmg_multiplikator
		_saber_node.hitbox_extra_damage_boss = dmg_multiplikator
		_saber_node.hitbox_extra_damage_weakness = dmg_multiplikator
		_saber_node.hitbox_extra_break_guard_value = dmg_multiplikator

	skill_youdantotsu.hitbox_upgraded = true
	for node in attack_nodes:
		if node != skill_youdantotsu:
			node.hitbox_upgraded = false
	skill_rasetsusen.upgraded = false
	bfan_shield.hitbox_upgraded = false

func equip_black_zero_parts() -> void :
	var dash = get_node("Dash")
	var airdash = get_node("AirDash")
	var airjump = get_node("AirJump")
	var fall = get_node("Fall")
	dash.invulnerability_duration = 0
	airdash.upgraded = false
	airdash.max_airdashes = 2
	airjump.set_max_air_jumps(2)
	airjump.upgraded = true
	fall.upgraded = true
	
	var lifesteal = get_node("LifeSteal")
	lifesteal.activate()
	lifesteal.first_decay = 1.5
	lifesteal.lifesteal_decay = 0.75
	lifesteal.minimum_time_between_heals = 0.3
	
	var dmg = get_node("Damage")
	dmg.damage_reduction = 15
	dmg.prevent_knockbacks = true
	dmg.conflicting_moves = ["Death", "Nothing"]
	
	
	dash.horizontal_velocity = 300
	airdash.horizontal_velocity = 300
	saber_dash.horizontal_velocity = 300
	get_node("DashJump").horizontal_velocity = 300
	get_node("DashWallJump").horizontal_velocity = 300
	fall.dashjump_speed = 300
	var _afterimage = animatedSprite.get_node("afterImages")
	_afterimage.upgraded = true
	
	
	if CharacterManager.NO_MOVEMENT_CHALLENGE:
		get_node("Walk").horizontal_velocity = 0.0
		get_node("Jump").horizontal_velocity = 0.0
		get_node("DashJump").horizontal_velocity = 0.0
		get_node("WallJump").horizontal_velocity = 0.0
		get_node("DashWallJump").horizontal_velocity = 0.0
		airjump.horizontal_velocity = 0.0
		airjump.dashjump_speed = 0.0
		airjump.fall_base_velocity = 0.0
		dash.horizontal_velocity = 0.0
		airdash.horizontal_velocity = 0.0
		fall.horizontal_velocity = 0.0
		fall.dashjump_speed = 0.0
		fall.fall_base_velocity = 0.0
	
	
	var dmg_multiplikator = 1.2
	for node in attack_nodes:
		node.hitbox_upgraded = true
		node.hitbox_extra_damage = dmg_multiplikator
		node.hitbox_extra_damage_boss = dmg_multiplikator
		node.hitbox_extra_damage_weakness = dmg_multiplikator
		node.hitbox_extra_break_guard_value = dmg_multiplikator
	skill_rasetsusen.upgraded = true
	bfan_shield.hitbox_upgraded = true

func equip_custom_zero_parts() -> void :
	spike_invincibility = true
	var dash = get_node("Dash")
	var airdash = get_node("AirDash")
	var airjump = get_node("AirJump")
	var fall = get_node("Fall")
	dash.invulnerability_duration = 0
	airdash.upgraded = false
	airdash.max_airdashes = 3
	airjump.set_max_air_jumps(3)
	airjump.upgraded = true
	fall.upgraded = true
	
	var lifesteal = get_node("LifeSteal")
	lifesteal.activate()
	lifesteal.first_decay = 1.5
	lifesteal.lifesteal_decay = 1.5
	lifesteal.minimum_time_between_heals = 0.1
	
	var dmg = get_node("Damage")
	dmg.damage_reduction = 99
	dmg.prevent_knockbacks = true
	dmg.conflicting_moves = ["Death", "Nothing"]
	
	
	get_node("Jump").max_jump_time = 0.75
	get_node("Jump").jump_velocity = 420
	get_node("DashJump").max_jump_time = 0.75
	get_node("DashJump").jump_velocity = 420
	get_node("WallJump").max_jump_time = 0.75
	get_node("WallJump").jump_velocity = 420
	get_node("DashWallJump").max_jump_time = 0.75
	get_node("DashWallJump").jump_velocity = 420
	airjump.max_jump_time = 0.75
	airjump.jump_velocity = 230
	
	
	dash.horizontal_velocity = 400
	airdash.horizontal_velocity = 400
	saber_dash.horizontal_velocity = 400
	get_node("DashJump").horizontal_velocity = 400
	get_node("DashWallJump").horizontal_velocity = 400
	fall.dashjump_speed = 400
	var _afterimage = animatedSprite.get_node("afterImages")
	_afterimage.upgraded = true
	
	
	if CharacterManager.NO_MOVEMENT_CHALLENGE:
		get_node("Walk").horizontal_velocity = 0.0
		get_node("Jump").horizontal_velocity = 0.0
		get_node("DashJump").horizontal_velocity = 0.0
		get_node("WallJump").horizontal_velocity = 0.0
		get_node("DashWallJump").horizontal_velocity = 0.0
		airjump.horizontal_velocity = 0.0
		airjump.dashjump_speed = 0.0
		airjump.fall_base_velocity = 0.0
		dash.horizontal_velocity = 0.0
		airdash.horizontal_velocity = 0.0
		fall.horizontal_velocity = 0.0
		fall.dashjump_speed = 0.0
		fall.fall_base_velocity = 0.0
	
	
	var dmg_multiplikator = 2.0
	for node in attack_nodes:
		node.hitbox_upgraded = true
		node.hitbox_extra_damage = dmg_multiplikator
		node.hitbox_extra_damage_boss = dmg_multiplikator
		node.hitbox_extra_damage_weakness = dmg_multiplikator
		node.hitbox_extra_break_guard_value = dmg_multiplikator
	skill_rasetsusen.upgraded = true
	bfan_shield.hitbox_upgraded = true

func is_full_armor() -> String:
	var armor_set: = 0
	for piece in current_armor:
		if "hermes" in piece:
			armor_set += 1
		elif "icarus" in piece:
			armor_set -= 1
	if armor_set == 4:
		return "hermes"
	elif armor_set == - 4:
		return "icarus"
	return "no_armor"

func equip_parts(collectible: String) -> void :
	CharacterManager.set_zeroX8_colors(animatedSprite)
	equip_zero_parts()
	emit_signal("equipped_armor")
	
	if CharacterManager.black_zero_armor:
		equip_black_zero_parts()
		using_upgrades = true
		
	if CharacterManager.custom_zero_armor:
		equip_custom_zero_parts()
		using_upgrades = true
		
	if is_heart(collectible):
		equip_heart()
		using_upgrades = true
		
	elif is_subtank(collectible):
		equip_subtank(collectible)
		using_upgrades = true
		
	elif is_ability(collectible):
		equip_ability(collectible)
		
	elif is_weapon(collectible):
		equip_weapon(collectible)

func is_ability(collectible: String) -> bool:
	return "weapon" in collectible
	
func equip_ability(collectible: String) -> void :
	get_node("Shot").unlock_ability(collectible)
	
func is_weapon(collectible: String) -> bool:
	return "zero" in collectible

func equip_weapon(collectible: String) -> void :
	get_node("Shot").unlock_weapon(collectible)

func get_current_weapon():
	return get_node("Shot").current_weapon

func is_heart(collectible: String) -> bool:
	return "heart" in collectible or "life" in collectible

func is_subtank(collectible: String) -> bool:
	return "tank" in collectible

func equip_heart() -> void :
	var i = GameManager.team.find(self)
	if i == -1:
		return
	var buff = CharacterManager.heart_tank_buff_amt
	GameManager.team[i].max_health += buff
	GameManager.team[i].recover_health(buff)
	num_equipped_hearts += 1

func recover_health(value: float) -> void :
	if current_health < max_health:
		current_health += value
	if current_health >= max_health:
		emit_signal("at_max_hp")

func equip_subtank(collectible: String) -> void :
	for subtank in $Subtanks.get_children():
		if subtank.subtank.id == collectible:
			subtank.activate()

func get_subtank_current_health(id) -> int:
	for subtank in $Subtanks.get_children():
		if subtank.get_id() == id:
			return subtank.current_health
	return - 1

func add_part_to_current_armor(collectible: String) -> void :
	var part_location = collectible.replace("icarus_", "").replace("hermes_", "")
	for location in current_armor:
		if part_location in location:
			current_armor.remove(current_armor.find(location))
			current_armor.append(collectible)
	GameManager.remove_equip_exception(part_location)

func is_armor_part(collectible: String) -> bool:
	return "icarus" in collectible or "hermes" in collectible

func finished_equipping() -> void :
	get_node("Shot").update_list_of_weapons()

func has_any_upgrades() -> bool:
	return true

func collect(collectible: String) -> void :
	GameManager.add_collectible_to_savedata(collectible)

func save_original_colors() -> void :
	colors.append(animatedSprite.material.get_shader_param("MainColor1"))
	colors.append(animatedSprite.material.get_shader_param("MainColor2"))
	colors.append(animatedSprite.material.get_shader_param("MainColor3"))
	colors.append(animatedSprite.material.get_shader_param("MainColor4"))
	colors.append(animatedSprite.material.get_shader_param("MainColor5"))
	colors.append(animatedSprite.material.get_shader_param("MainColor6"))

func change_palette(new_colors, paint_armor: = true) -> void :
	if not animatedSprite:
		animatedSprite = get_node("animatedSprite")
	set_new_colors_on_shader_parameters(animatedSprite, new_colors)
	if paint_armor:
		for sprite in armor_sprites:
			set_new_colors_for_armor_on_shader_parameters(sprite, new_colors)
	else:
		for sprite in armor_sprites:
			set_new_colors_for_armor_on_shader_parameters(sprite, $Armor.BodyColors)

func set_new_colors_on_shader_parameters(object, new_colors) -> void :
	object.material.set_shader_param("R_MainColor1", new_colors[0])
	object.material.set_shader_param("R_MainColor2", new_colors[1])
	object.material.set_shader_param("R_MainColor3", new_colors[2])
	object.material.set_shader_param("R_MainColor4", new_colors[3])
	object.material.set_shader_param("R_MainColor5", new_colors[4])
	object.material.set_shader_param("R_MainColor6", new_colors[5])
	
func set_new_colors_for_armor_on_shader_parameters(object, new_colors) -> void :
	object.material.set_shader_param("R_MainColor2", new_colors[1])
	object.material.set_shader_param("R_MainColor3", new_colors[2])

func disable_collision() -> void :
	colliding = false
	get_node("CollisionShape2D").set_deferred("disabled", true)

func enable_collision() -> void :
	colliding = true
	get_node("CollisionShape2D").set_deferred("disabled", false)

func is_colliding() -> bool:
	return colliding

func flash() -> void :
	if has_health():
		animatedSprite.material.set_shader_param("Flash", 1)
		flash_timer = 0.01

func end_flash() -> void :
	animatedSprite.material.set_shader_param("Flash", 0)
	flash_timer = 0

func are_low_walljump_raycasts_active() -> bool:
	var b: = true
	for raycast in low_jumpcasts:
		if not raycast.enabled:
			b = false
	return b

func activate_low_walljump_raycasts() -> void :
	for raycast in low_jumpcasts:
		raycast.enabled = true
	lowjumpcast.text = "on"

func deactivate_low_walljump_raycasts() -> void :
	for raycast in low_jumpcasts:
		raycast.enabled = false
	lowjumpcast.text = "off"

func set_global_position(new_position: Vector2) -> void :
	global_position = new_position

func start_dashfall() -> void :
	if not is_on_floor():
		dashfall = true

func set_x(pos) -> void :
	if can_be_moved():
		global_position.x = pos
func set_y(pos) -> void :
	if can_be_moved():
		global_position.y = pos

func move_x(difference) -> void :
	if can_be_moved():
		global_position.x += difference
func move_y(difference) -> void :
	if can_be_moved():
		global_position.y += difference

func can_be_moved() -> bool:
	return not is_executing("Ride")

func stop_forced_movement(forcer = null) -> void :
	if not is_executing("Ride"):
		emit_signal("stop_forced_movement", forcer)
		grabbed = false
