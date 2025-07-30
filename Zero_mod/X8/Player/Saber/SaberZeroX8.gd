extends Movement
class_name SaberZeroX8

export  var upgraded: bool = false

onready var animatedSprite: = character.get_node("animatedSprite")
onready var saber_sound: AudioStreamPlayer = $saber

var current_weapon_index: int = 0
var weapons: Array = []
var current_weapon
var _listening_to_inputs_start: bool = true
var interrupted_cutscene: bool = false
var slashing: bool = false
var slashes: int = 0


func _StartCondition() -> bool:
	return false
	
func _ResetCondition() -> bool:
	return false

func _EndCondition() -> bool:
	return true

func _Setup() -> void :
	pass

func _Update(_delta: float) -> void :
	pass

func change_animation_if_falling(_s) -> void :
	pass

func _Interrupt() -> void :
	pass

func _ready() -> void :
	if active:
		update_list_of_weapons()
		set_saber_as_weapon()
		Event.listen("weapon_select_left", self, "change_current_weapon_left")
		Event.listen("weapon_select_right", self, "change_current_weapon_right")
		Event.listen("weapon_select_buster", self, "set_saber_as_weapon")
		Event.listen("select_weapon", self, "direct_weapon_select")
		Event.listen("add_to_ammo_reserve", self, "_on_add_to_ammo_reserve")

func update_list_of_weapons() -> void :
	weapons.clear()
	for child in get_children():
		if child is ZeroSpecialWeapon or child is ZeroWeapon:
			if child.active:
				weapons.append(child)

func set_saber_as_weapon() -> void :
	for weapon in weapons:
		if "Saber" in weapon.name and weapon.active:
			set_current_weapon(weapon)
			break

func current_weapon_is_saber() -> bool:
	if current_weapon != null:
		return "Saber" in current_weapon.name
	return false

func change_current_weapon_left() -> void :
	var index = weapons.find(current_weapon)
	if index - 1 < 0:
		set_current_weapon(weapons[weapons.size() - 1])
	else:
		set_current_weapon(weapons[index - 1])

func change_current_weapon_right() -> void :
	update_list_of_weapons()
	var index = weapons.find(current_weapon)
	if index + 1 > weapons.size() - 1:
		set_current_weapon(weapons[0])
	else:
		set_current_weapon(weapons[index + 1])

func set_current_weapon(weapon) -> void :
	current_weapon = weapon
	if not current_weapon:
		set_saber_as_weapon()
	if current_weapon != null:
		update_character_sprites()
		Event.emit_signal("changed_weapon", current_weapon)

func direct_weapon_select(weapon_resource) -> void :
	for weapon in weapons:
		if weapon.weapon == weapon_resource:
			set_current_weapon(weapon)
			return

func update_character_sprites() -> void :
	if current_weapon_is_saber():
		animatedSprite.frames = character._saber_sprites
		call_deferred("deactivate_fan_moves")
		call_deferred("deactivate_glaive_moves")
		call_deferred("deactivate_knuckle_moves")
		call_deferred("deactivate_breaker_moves")
		call_deferred("activate_saber_moves")
	elif "B-Fan" in current_weapon.name:
		animatedSprite.frames = character._fan_sprites
		call_deferred("deactivate_saber_moves")
		call_deferred("deactivate_glaive_moves")
		call_deferred("deactivate_knuckle_moves")
		call_deferred("deactivate_breaker_moves")
		call_deferred("activate_fan_moves")
	elif "D-Glaive" in current_weapon.name:
		animatedSprite.frames = character._glaive_sprites
		call_deferred("deactivate_saber_moves")
		call_deferred("deactivate_fan_moves")
		call_deferred("deactivate_knuckle_moves")
		call_deferred("deactivate_breaker_moves")
		call_deferred("activate_glaive_moves")
	elif "K-Knuckle" in current_weapon.name:
		animatedSprite.frames = character._knuckle_sprites
		call_deferred("deactivate_saber_moves")
		call_deferred("deactivate_fan_moves")
		call_deferred("deactivate_glaive_moves")
		call_deferred("deactivate_breaker_moves")
		call_deferred("activate_knuckle_moves")
	elif "T-Breaker" in current_weapon.name:
		animatedSprite.frames = character._breaker_sprites
		call_deferred("deactivate_saber_moves")
		call_deferred("deactivate_fan_moves")
		call_deferred("deactivate_glaive_moves")
		call_deferred("deactivate_knuckle_moves")
		call_deferred("activate_breaker_moves")
	elif "V-Hanger" in current_weapon.name:
		animatedSprite.frames = character._hanger_sprites
		call_deferred("deactivate_saber_moves")
		call_deferred("deactivate_fan_moves")
		call_deferred("deactivate_glaive_moves")
		call_deferred("deactivate_knuckle_moves")
		call_deferred("deactivate_breaker_moves")
	elif "Sigma-Blade" in current_weapon.name:
		animatedSprite.frames = character._sigmablade_sprites
		call_deferred("deactivate_saber_moves")
		call_deferred("deactivate_fan_moves")
		call_deferred("deactivate_glaive_moves")
		call_deferred("deactivate_knuckle_moves")
		call_deferred("deactivate_breaker_moves")
	else:
		animatedSprite.frames = character._saber_sprites
		call_deferred("deactivate_saber_moves")
		call_deferred("deactivate_fan_moves")
		call_deferred("deactivate_glaive_moves")
		call_deferred("deactivate_knuckle_moves")
		call_deferred("deactivate_breaker_moves")


func activate_saber_moves() -> void :
	character.saber_combo.active = true
	character.saber_combo.damage = 3
	character.saber_combo.damage_boss = 5
	character.saber_combo.damage_weakness = 24
	character.saber_combo.deflectable_type = 0
	character.saber_combo.only_deflect_weak = true
	character.saber_dash.active = true
	character.saber_dash.damage = 5
	character.saber_dash.damage_boss = 5
	character.saber_dash.damage_weakness = 24
	character.saber_dash.deflectable_type = 0
	character.saber_dash.only_deflect_weak = true
	character.saber_jump.active = true
	character.saber_jump.damage = 5
	character.saber_jump.damage_boss = 5
	character.saber_jump.damage_weakness = 24
	character.saber_jump.deflectable_type = 0
	character.saber_jump.only_deflect_weak = true
	character.saber_wall.active = true
	character.saber_wall.damage = 5
	character.saber_wall.damage_boss = 5
	character.saber_wall.damage_weakness = 24
	character.saber_wall.deflectable_type = 0
	character.saber_wall.only_deflect_weak = true
	
	character.skill_tenshouha.laser_cast_frame = 5
	
	character.skill_juuhazan.hitbox_name = "Juuhazan"
	character.skill_juuhazan.damage = 12
	character.skill_juuhazan.damage_boss = 6
	character.skill_juuhazan.damage_weakness = 20
	character.skill_juuhazan.deflectable_type = - 1
	character.skill_juuhazan.only_deflect_weak = false
	character.skill_juuhazan.movement_frame_start = 5
	character.skill_juuhazan.movement_frame_end = 13
	character.skill_juuhazan.effect_only_frame = 5
	
	character.skill_rasetsusen.hitbox_name = "Rasetsusen"
	character.skill_rasetsusen.max_time = 2.0
	character.skill_rasetsusen.damage = 3
	character.skill_rasetsusen.damage_boss = 3
	character.skill_rasetsusen.damage_weakness = 24
	character.skill_rasetsusen.deflectable_type = 0
	character.skill_rasetsusen.only_deflect_weak = true
	character.skill_rasetsusen.hitbox_rehit_time = 0.15
	character.skill_rasetsusen.hitbox_radius = 48
	character.skill_rasetsusen.hitbox_inner_radius = 0
	
	character.skill_raikousen.hitbox_name = "Raikousen"
	character.skill_raikousen.effect_transparency = 0.65
	character.skill_raikousen.damage = 5
	character.skill_raikousen.damage_boss = 5
	character.skill_raikousen.damage_weakness = 24
	character.skill_raikousen.deflectable_type = - 1
	character.skill_raikousen.only_deflect_weak = false
	character.skill_raikousen.instant_damage = false
	character.skill_raikousen.vulnerable = true
	character.skill_raikousen.start_speed = 900
	character.skill_raikousen.movement_frame_start = 3
	character.skill_raikousen.movement_frame_end = 16
	character.skill_raikousen.shadow_frame = 3
	character.skill_raikousen.sound_1_frame = 0
	character.skill_raikousen.sound_2_frame = 8
	character.skill_raikousen.hitbox_frame_start = 10
	character.skill_raikousen.hitbox_frame_end = 16
	character.skill_raikousen.hitbox_upleft_corner = Vector2( - 120, - 15)
	character.skill_raikousen.hitbox_downright_corner = Vector2(100, 5)
	character.skill_raikousen.light_size = Vector2(3, 2)
	
	character.skill_youdantotsu.hitbox_name = "Youdantotsu"
	character.skill_youdantotsu.movement_frame = 5
	character.skill_youdantotsu.start_speed = 500
	character.skill_youdantotsu.damage = 6
	character.skill_youdantotsu.damage_boss = 6
	character.skill_youdantotsu.damage_weakness = 24
	character.skill_youdantotsu.deflectable_type = - 1
	character.skill_youdantotsu.only_deflect_weak = false
	character.skill_youdantotsu.hitbox_break_guards = true
	character.skill_youdantotsu.hitbox_rehit_time = 0.075
	character.skill_youdantotsu.hitbox_upleft_corner = Vector2(7, - 35)
	character.skill_youdantotsu.hitbox_downright_corner = Vector2(94, 30)
	character.skill_youdantotsu.effect_transparency = 0.75
	
	character.skill_hyouryuushou.loop_frame = 10
	character.skill_hyouryuushou.loop_start_frame = 4
	character.skill_hyouryuushou.damage = 6
	character.skill_hyouryuushou.damage_boss = 6
	character.skill_hyouryuushou.damage_weakness = 24
	character.skill_hyouryuushou.deflectable_type = - 1
	character.skill_hyouryuushou.only_deflect_weak = true
	
	character.skill_enkoujin.hitbox_name = "Enkoujin"
	character.skill_enkoujin.hitbox_upward_movement = 100
	character.skill_enkoujin.deflectable_type = - 1
	character.skill_enkoujin.only_deflect_weak = true
	character.skill_enkoujin.hitbox_break_guards = false

func deactivate_saber_moves() -> void :
	character.saber_combo.active = false
	character.saber_dash.active = false
	character.saber_jump.active = false
	character.saber_wall.active = false
	

func activate_fan_moves() -> void :
	character.saber_combo.active = true
	character.saber_combo.damage = 3
	character.saber_combo.damage_boss = 5
	character.saber_combo.damage_weakness = 24
	character.saber_combo.deflectable_type = 2
	character.saber_combo.only_deflect_weak = false
	character.saber_dash.active = true
	character.saber_dash.damage = 5
	character.saber_dash.damage_boss = 5
	character.saber_dash.damage_weakness = 24
	character.saber_dash.deflectable_type = 2
	character.saber_dash.only_deflect_weak = false
	character.saber_jump.active = true
	character.saber_jump.damage = 5
	character.saber_jump.damage_boss = 5
	character.saber_jump.damage_weakness = 24
	character.saber_jump.deflectable_type = 2
	character.saber_jump.only_deflect_weak = false
	character.saber_wall.active = true
	character.saber_wall.damage = 5
	character.saber_wall.damage_boss = 5
	character.saber_wall.damage_weakness = 24
	character.saber_wall.deflectable_type = 2
	character.saber_wall.only_deflect_weak = false
	
	character.skill_tenshouha.laser_cast_frame = 5
	
	character.skill_juuhazan.hitbox_name = "Juuhazan"
	character.skill_juuhazan.damage = 12
	character.skill_juuhazan.damage_boss = 6
	character.skill_juuhazan.damage_weakness = 20
	character.skill_juuhazan.deflectable_type = - 1
	character.skill_juuhazan.only_deflect_weak = false
	character.skill_juuhazan.movement_frame_start = 5
	character.skill_juuhazan.movement_frame_end = 13
	character.skill_juuhazan.effect_only_frame = 5
	
	character.skill_rasetsusen.hitbox_name = "Rasetsusen"
	character.skill_rasetsusen.max_time = 2.0
	character.skill_rasetsusen.damage = 3
	character.skill_rasetsusen.damage_boss = 3
	character.skill_rasetsusen.damage_weakness = 24
	character.skill_rasetsusen.deflectable_type = 2
	character.skill_rasetsusen.only_deflect_weak = false
	character.skill_rasetsusen.hitbox_rehit_time = 0.15
	character.skill_rasetsusen.hitbox_radius = 48
	character.skill_rasetsusen.hitbox_inner_radius = 0
	
	character.skill_raikousen.hitbox_name = "Raikousen"
	character.skill_raikousen.effect_transparency = 0.85
	character.skill_raikousen.damage = 6
	character.skill_raikousen.damage_boss = 6
	character.skill_raikousen.damage_weakness = 24
	character.skill_raikousen.deflectable_type = - 1
	character.skill_raikousen.only_deflect_weak = false
	character.skill_raikousen.instant_damage = false
	character.skill_raikousen.vulnerable = true
	character.skill_raikousen.start_speed = 900
	character.skill_raikousen.movement_frame_start = 3
	character.skill_raikousen.movement_frame_end = 16
	character.skill_raikousen.shadow_frame = 3
	character.skill_raikousen.sound_1_frame = 0
	character.skill_raikousen.sound_2_frame = 8
	character.skill_raikousen.hitbox_frame_start = 10
	character.skill_raikousen.hitbox_frame_end = 16
	character.skill_raikousen.hitbox_upleft_corner = Vector2( - 120, - 15)
	character.skill_raikousen.hitbox_downright_corner = Vector2(100, 5)
	character.skill_raikousen.light_size = Vector2(3, 2)
	
	character.skill_youdantotsu.hitbox_name = "Youdantotsu"
	character.skill_youdantotsu.movement_frame = 5
	character.skill_youdantotsu.start_speed = 500
	character.skill_youdantotsu.damage = 6
	character.skill_youdantotsu.damage_boss = 6
	character.skill_youdantotsu.damage_weakness = 24
	character.skill_youdantotsu.deflectable_type = - 1
	character.skill_youdantotsu.only_deflect_weak = false
	character.skill_youdantotsu.hitbox_break_guards = true
	character.skill_youdantotsu.hitbox_rehit_time = 0.075
	character.skill_youdantotsu.hitbox_upleft_corner = Vector2(7, - 35)
	character.skill_youdantotsu.hitbox_downright_corner = Vector2(94, 30)
	character.skill_youdantotsu.effect_transparency = 1.0
	
	character.skill_hyouryuushou.loop_frame = 10
	character.skill_hyouryuushou.loop_start_frame = 6
	character.skill_hyouryuushou.damage = 3
	character.skill_hyouryuushou.damage_boss = 4
	character.skill_hyouryuushou.damage_weakness = 24
	character.skill_hyouryuushou.deflectable_type = - 1
	character.skill_hyouryuushou.only_deflect_weak = false
	
	character.skill_enkoujin.hitbox_name = "Enkoujin"
	character.skill_enkoujin.hitbox_upward_movement = 100
	character.skill_enkoujin.deflectable_type = - 1
	character.skill_enkoujin.only_deflect_weak = false
	character.skill_enkoujin.hitbox_break_guards = false

func deactivate_fan_moves() -> void :
	character.saber_combo.active = false
	character.saber_dash.active = false
	character.saber_jump.active = false
	character.saber_wall.active = false


func activate_glaive_moves() -> void :
	character.saber_combo.active = true
	character.saber_combo.damage = 3
	character.saber_combo.damage_boss = 5
	character.saber_combo.damage_weakness = 24
	character.saber_combo.deflectable_type = 0
	character.saber_combo.only_deflect_weak = true
	character.saber_dash.active = true
	character.saber_dash.damage = 5
	character.saber_dash.damage_boss = 5
	character.saber_dash.damage_weakness = 24
	character.saber_dash.deflectable_type = 0
	character.saber_dash.only_deflect_weak = true
	character.saber_jump.active = true
	character.saber_jump.damage = 5
	character.saber_jump.damage_boss = 5
	character.saber_jump.damage_weakness = 24
	character.saber_jump.deflectable_type = 0
	character.saber_jump.only_deflect_weak = true
	character.saber_wall.active = true
	character.saber_wall.damage = 5
	character.saber_wall.damage_boss = 5
	character.saber_wall.damage_weakness = 24
	character.saber_wall.deflectable_type = 0
	character.saber_wall.only_deflect_weak = true
	
	character.skill_tenshouha.laser_cast_frame = 5
	
	character.skill_juuhazan.hitbox_name = "Juuhazan"
	character.skill_juuhazan.damage = 12
	character.skill_juuhazan.damage_boss = 6
	character.skill_juuhazan.damage_weakness = 20
	character.skill_juuhazan.deflectable_type = - 1
	character.skill_juuhazan.only_deflect_weak = false
	character.skill_juuhazan.movement_frame_start = 5
	character.skill_juuhazan.movement_frame_end = 13
	character.skill_juuhazan.effect_only_frame = 5
	
	character.skill_rasetsusen.hitbox_name = "Rasetsusen"
	character.skill_rasetsusen.max_time = 2.0
	character.skill_rasetsusen.damage = 3
	character.skill_rasetsusen.damage_boss = 3
	character.skill_rasetsusen.damage_weakness = 24
	character.skill_rasetsusen.deflectable_type = 0
	character.skill_rasetsusen.only_deflect_weak = true
	character.skill_rasetsusen.hitbox_rehit_time = 0.15
	character.skill_rasetsusen.hitbox_radius = 110
	character.skill_rasetsusen.hitbox_inner_radius = 70
	
	character.skill_raikousen.hitbox_name = "Raikousen"
	character.skill_raikousen.effect_transparency = 1.0
	character.skill_raikousen.damage = 6
	character.skill_raikousen.damage_boss = 6
	character.skill_raikousen.damage_weakness = 24
	character.skill_raikousen.deflectable_type = - 1
	character.skill_raikousen.only_deflect_weak = false
	character.skill_raikousen.instant_damage = true
	character.skill_raikousen.vulnerable = false
	character.skill_raikousen.start_speed = 300
	character.skill_raikousen.movement_frame_start = 2
	character.skill_raikousen.movement_frame_end = 13
	character.skill_raikousen.shadow_frame = 100
	character.skill_raikousen.sound_1_frame = 100
	character.skill_raikousen.sound_2_frame = 2
	character.skill_raikousen.hitbox_frame_start = 3
	character.skill_raikousen.hitbox_frame_end = 11
	character.skill_raikousen.hitbox_upleft_corner = Vector2( - 50, - 15)
	character.skill_raikousen.hitbox_downright_corner = Vector2(160, 5)
	character.skill_raikousen.light_size = Vector2(3, 2)
	
	character.skill_youdantotsu.hitbox_name = "Youdantotsu_Charged"
	character.skill_youdantotsu.movement_frame = 5
	character.skill_youdantotsu.start_speed = 300
	character.skill_youdantotsu.damage = 6
	character.skill_youdantotsu.damage_boss = 6
	character.skill_youdantotsu.damage_weakness = 24
	character.skill_youdantotsu.deflectable_type = - 1
	character.skill_youdantotsu.hitbox_break_guards = true
	character.skill_youdantotsu.hitbox_rehit_time = 0.075
	character.skill_youdantotsu.hitbox_upleft_corner = Vector2(7, - 35)
	character.skill_youdantotsu.hitbox_downright_corner = Vector2(94, 30)
	character.skill_youdantotsu.effect_transparency = 1.0
	
	character.skill_hyouryuushou.loop_frame = 10
	character.skill_hyouryuushou.loop_start_frame = 6
	character.skill_hyouryuushou.damage = 6
	character.skill_hyouryuushou.damage_boss = 6
	character.skill_hyouryuushou.damage_weakness = 24
	character.skill_hyouryuushou.deflectable_type = - 1
	character.skill_hyouryuushou.only_deflect_weak = true
	
	character.skill_enkoujin.hitbox_name = "Enkoujin"
	character.skill_enkoujin.hitbox_upward_movement = 300
	character.skill_enkoujin.deflectable_type = - 1
	character.skill_enkoujin.only_deflect_weak = true
	character.skill_enkoujin.hitbox_break_guards = false

func deactivate_glaive_moves() -> void :
	character.saber_combo.active = false
	character.saber_dash.active = false
	character.saber_jump.active = false
	character.saber_wall.active = false


func activate_knuckle_moves() -> void :












	character.knuckle_combo.active = true
	character.knuckle_combo.deflectable_type = - 1
	character.knuckle_combo.only_deflect_weak = false
	character.knuckle_dash.active = true
	character.knuckle_dash.deflectable_type = - 1
	character.knuckle_dash.only_deflect_weak = false
	character.knuckle_dash.hitbox_upleft_corner = Vector2( - 5, - 40)
	character.knuckle_dash.hitbox_downright_corner = Vector2(30, 15)
	character.knuckle_jump.active = true
	character.knuckle_jump.deflectable_type = - 1
	character.knuckle_jump.only_deflect_weak = false
	character.knuckle_wall.active = true
	character.knuckle_wall.deflectable_type = - 1
	character.knuckle_wall.only_deflect_weak = false
	
	character.skill_tenshouha.laser_cast_frame = 3
	
	character.skill_juuhazan.hitbox_name = "Juuhazan_Charged"
	character.skill_juuhazan.damage = 16
	character.skill_juuhazan.damage_boss = 8
	character.skill_juuhazan.damage_weakness = 24
	character.skill_juuhazan.deflectable_type = - 1
	character.skill_juuhazan.only_deflect_weak = false
	character.skill_juuhazan.movement_frame_start = 100
	character.skill_juuhazan.movement_frame_end = 8
	character.skill_juuhazan.effect_only_frame = 5
	
	character.skill_rasetsusen.hitbox_name = "Rasetsusen_Charged"
	character.skill_rasetsusen.max_time = 1.0
	character.skill_rasetsusen.damage = 4
	character.skill_rasetsusen.damage_boss = 4
	character.skill_rasetsusen.damage_weakness = 30
	character.skill_rasetsusen.deflectable_type = - 1
	character.skill_rasetsusen.only_deflect_weak = false
	character.skill_rasetsusen.hitbox_rehit_time = 0.075
	character.skill_rasetsusen.hitbox_radius = 28
	character.skill_rasetsusen.hitbox_inner_radius = 0
	
	character.skill_raikousen.hitbox_name = "Raikousen_Charged"
	character.skill_raikousen.effect_transparency = 0.65
	character.skill_raikousen.damage = 8
	character.skill_raikousen.damage_boss = 8
	character.skill_raikousen.damage_weakness = 30
	character.skill_raikousen.deflectable_type = - 1
	character.skill_raikousen.only_deflect_weak = false
	character.skill_raikousen.instant_damage = true
	character.skill_raikousen.vulnerable = true
	character.skill_raikousen.start_speed = 600
	character.skill_raikousen.movement_frame_start = 0
	character.skill_raikousen.movement_frame_end = 20
	character.skill_raikousen.shadow_frame = 100
	character.skill_raikousen.sound_1_frame = 100
	character.skill_raikousen.sound_2_frame = 8
	character.skill_raikousen.hitbox_frame_start = 9
	character.skill_raikousen.hitbox_frame_end = 17
	character.skill_raikousen.hitbox_upleft_corner = Vector2( - 5, - 140)
	character.skill_raikousen.hitbox_downright_corner = Vector2(30, 65)
	character.skill_raikousen.light_size = Vector2(2, 3)
	
	character.skill_youdantotsu.hitbox_name = "Youdantotsu_Charged"
	character.skill_youdantotsu.movement_frame = 3
	character.skill_youdantotsu.start_speed = 500
	character.skill_youdantotsu.damage = 8
	character.skill_youdantotsu.damage_boss = 8
	character.skill_youdantotsu.damage_weakness = 30
	character.skill_youdantotsu.deflectable_type = - 1
	character.skill_youdantotsu.only_deflect_weak = false
	character.skill_youdantotsu.hitbox_break_guards = true
	character.skill_youdantotsu.hitbox_rehit_time = 0.075
	character.skill_youdantotsu.hitbox_upleft_corner = Vector2( - 10, - 30)
	character.skill_youdantotsu.hitbox_downright_corner = Vector2(45, 20)
	character.skill_youdantotsu.effect_transparency = 0.75
	
	character.skill_hyouryuushou.loop_frame = 10
	character.skill_hyouryuushou.loop_start_frame = 4
	character.skill_hyouryuushou.damage = 8
	character.skill_hyouryuushou.damage_boss = 8
	character.skill_hyouryuushou.damage_weakness = 30
	character.skill_hyouryuushou.deflectable_type = - 1
	character.skill_hyouryuushou.only_deflect_weak = false
	
	character.skill_enkoujin.hitbox_name = "Enkoujin"
	character.skill_enkoujin.hitbox_upward_movement = 100
	character.skill_enkoujin.deflectable_type = - 1
	character.skill_enkoujin.only_deflect_weak = true
	character.skill_enkoukyaku.deflectable_type = - 1
	character.skill_enkoukyaku.only_deflect_weak = false
	if character.Enkoujin:
		character.Enkoukyaku = true
		character.Enkoujin = false

func deactivate_knuckle_moves() -> void :
	character.knuckle_combo.active = false
	character.knuckle_dash.active = false
	character.knuckle_jump.active = false
	character.knuckle_wall.active = false
	if character.Enkoukyaku:
		character.Enkoukyaku = false
		character.Enkoujin = true


func activate_breaker_moves() -> void :
	character.saber_combo.active = true
	character.saber_combo.damage = 8
	character.saber_combo.damage_boss = 8
	character.saber_combo.damage_weakness = 24
	character.saber_combo.deflectable_type = - 1
	character.saber_combo.only_deflect_weak = true
	character.saber_dash.active = true
	character.saber_dash.damage = 8
	character.saber_dash.damage_boss = 8
	character.saber_dash.damage_weakness = 24
	character.saber_dash.deflectable_type = - 1
	character.saber_dash.only_deflect_weak = true
	character.saber_jump.active = true
	character.saber_jump.damage = 8
	character.saber_jump.damage_boss = 8
	character.saber_jump.damage_weakness = 24
	character.saber_jump.deflectable_type = - 1
	character.saber_jump.only_deflect_weak = true
	character.saber_wall.active = true
	character.saber_wall.damage = 8
	character.saber_wall.damage_boss = 8
	character.saber_wall.damage_weakness = 24
	character.saber_wall.deflectable_type = - 1
	character.saber_wall.only_deflect_weak = true
	
	character.skill_tenshouha.laser_cast_frame = 5
	
	character.skill_juuhazan.hitbox_name = "Juuhazan_Charged_B"
	character.skill_juuhazan.damage = 12
	character.skill_juuhazan.damage_boss = 6
	character.skill_juuhazan.damage_weakness = 30
	character.skill_juuhazan.deflectable_type = - 1
	character.skill_juuhazan.only_deflect_weak = false
	character.skill_juuhazan.movement_frame_start = 4
	character.skill_juuhazan.movement_frame_end = 4
	character.skill_juuhazan.effect_only_frame = 6
	
	character.skill_rasetsusen.hitbox_name = "Rasetsusen"
	character.skill_rasetsusen.max_time = 2.0
	character.skill_rasetsusen.damage = 3
	character.skill_rasetsusen.damage_boss = 3
	character.skill_rasetsusen.damage_weakness = 24
	character.skill_rasetsusen.deflectable_type = - 1
	character.skill_rasetsusen.only_deflect_weak = true
	character.skill_rasetsusen.hitbox_rehit_time = 0.15
	character.skill_rasetsusen.hitbox_radius = 64
	character.skill_rasetsusen.hitbox_inner_radius = 0
	
	character.skill_raikousen.hitbox_name = "Raikousen"
	character.skill_raikousen.effect_transparency = 0.65
	character.skill_raikousen.damage = 6
	character.skill_raikousen.damage_boss = 6
	character.skill_raikousen.damage_weakness = 24
	character.skill_raikousen.deflectable_type = - 1
	character.skill_raikousen.only_deflect_weak = false
	character.skill_raikousen.instant_damage = false
	character.skill_raikousen.vulnerable = true
	character.skill_raikousen.start_speed = 900
	character.skill_raikousen.movement_frame_start = 3
	character.skill_raikousen.movement_frame_end = 16
	character.skill_raikousen.shadow_frame = 3
	character.skill_raikousen.sound_1_frame = 0
	character.skill_raikousen.sound_2_frame = 8
	character.skill_raikousen.hitbox_frame_start = 10
	character.skill_raikousen.hitbox_frame_end = 16
	character.skill_raikousen.hitbox_upleft_corner = Vector2( - 90, - 15)
	character.skill_raikousen.hitbox_downright_corner = Vector2(130, 5)
	character.skill_raikousen.light_size = Vector2(3, 2)
	
	character.skill_youdantotsu.hitbox_name = "Youdantotsu"
	character.skill_youdantotsu.movement_frame = 5
	character.skill_youdantotsu.start_speed = 500
	character.skill_youdantotsu.damage = 6
	character.skill_youdantotsu.damage_boss = 6
	character.skill_youdantotsu.damage_weakness = 24
	character.skill_youdantotsu.deflectable_type = - 1
	character.skill_youdantotsu.only_deflect_weak = false
	character.skill_youdantotsu.hitbox_break_guards = true
	character.skill_youdantotsu.hitbox_rehit_time = 0.075
	character.skill_youdantotsu.hitbox_upleft_corner = Vector2(37, - 35)
	character.skill_youdantotsu.hitbox_downright_corner = Vector2(104, 30)
	character.skill_youdantotsu.effect_transparency = 0.75
	
	character.skill_hyouryuushou.loop_frame = 10
	character.skill_hyouryuushou.loop_start_frame = 6
	character.skill_hyouryuushou.damage = 6
	character.skill_hyouryuushou.damage_boss = 6
	character.skill_hyouryuushou.damage_weakness = 24
	character.skill_hyouryuushou.deflectable_type = - 1
	character.skill_hyouryuushou.only_deflect_weak = true
	
	character.skill_enkoujin.hitbox_name = "Enkoujin"
	character.skill_enkoujin.hitbox_upward_movement = 100
	character.skill_enkoujin.deflectable_type = - 1
	character.skill_enkoujin.only_deflect_weak = true
	character.skill_enkoujin.hitbox_break_guards = true

func deactivate_breaker_moves() -> void :
	character.saber_combo.active = false
	character.saber_dash.active = false
	character.saber_jump.active = false
	character.saber_wall.active = false


func weapon_cooldown_ended(_weapon) -> void :
	if character.listening_to_inputs:
		if current_weapon.has_ammo():
			if executing:
				EndAbility()
			ExecuteOnce()

func lock_weapon(collectible: String) -> void :
	for child in get_children():
		if child is ZeroSpecialWeapon:
			if child.should_unlock(collectible):
				child.active = false

func unlock_weapon(collectible: String) -> void :
	for child in get_children():
		if child is ZeroSpecialWeapon:
			if child.should_unlock(collectible):
				child.active = true

func unlock_ability(collectible: String) -> void :
	for child in get_children():
		if child is BossAbilityZero:
			if child.should_unlock(collectible):
				child.active = true

func _on_add_to_ammo_reserve(amount) -> void :
	var lowest_ammo_weapon
	for weapon in weapons:
		if weapon is BossAbilityZero:
			if lowest_ammo_weapon:
				if weapon.current_ammo < lowest_ammo_weapon.current_ammo:
					lowest_ammo_weapon = weapon
			else:
				if weapon.current_ammo < 28:
					lowest_ammo_weapon = weapon
	if lowest_ammo_weapon:
		lowest_ammo_weapon.increase_ammo(amount)
		if lowest_ammo_weapon != current_weapon:
			saber_sound.play()
