extends ShotAxl
class_name PrimaryShotAxl

export  var upgraded: bool = false

onready var damage: Node2D = $"../Damage"

var current_weapon_index: int = 0
var charged_shot: bool = true

func _ready() -> void :
	if active:
		Event.listen("charged_shot_release", self, "charged_shot_release")
		Event.listen("weapon_select_left", self, "change_current_weapon_left")
		Event.listen("weapon_select_right", self, "change_current_weapon_right")
		Event.listen("weapon_select_buster", self, "set_pistol_as_weapon")
		Event.listen("select_weapon", self, "direct_weapon_select")
		Event.listen("add_to_ammo_reserve", self, "_on_add_to_ammo_reserve")

func charged_shot_release(_charge_level):
	if not character.has_control():
		return
	if has_infinite_charged_ammo():
		if not current_weapon_is_pistol():
			return

func _StartCondition() -> bool:
	if name == "Shot" and Input.is_action_pressed("alt_fire"):
		return false
	var _animation = get_parent().get_animation()
	if _animation == "dodge":
		return false
	if current_weapon and character.has_control():
		if current_weapon_is_pistol():
			return current_weapon.has_ammo()
		elif not current_weapon.is_cooling_down():
			return true
	return false

func save_shot() -> void :
	if action_just_pressed() and current_weapon.can_buffer:
		if not damage.executing and not current_weapon.last_fired_shot_was_charged:
			next_shot_ready = true

func manual_save_shot() -> void :
	next_shot_ready = true

func change_current_weapon_left():
	var index = weapons.find(current_weapon)
	if index - 1 < 0:
		set_current_weapon(weapons[weapons.size() - 1])
	else:
		set_current_weapon(weapons[index - 1])

func change_current_weapon_right():
	var index = weapons.find(current_weapon)
	if index + 1 > weapons.size() - 1:
		set_current_weapon(weapons[0])
	else:
		set_current_weapon(weapons[index + 1])

func set_current_weapon(weapon):
	current_weapon = weapon
	update_character_sprites()
	
	if current_weapon != null and character.is_current_player:
		current_weapon.shoot_timer = 0
		current_weapon.sprite_timer = 0
		
		Event.emit_signal("changed_weapon", current_weapon)
	next_shot_ready = false
	
func direct_weapon_select(weapon_resource):
	for weapon in weapons:
		if "weapon" in weapon:
			if weapon.weapon == weapon_resource:
				set_current_weapon(weapon)
				return

func update_character_sprites() -> void :
	if not current_weapon:
		set_pistol_as_weapon()
		animatedSprite.frames = character._sprites_pistol_A
	else:
		if current_weapon_is_pistol():
			animatedSprite.frames = character._sprites_pistol_A
		elif "RayGun" in current_weapon.name:
			animatedSprite.frames = character._sprites_raygun
		elif "SpiralMagnum" in current_weapon.name:
			animatedSprite.frames = character._sprites_sprialmagnum_A
		elif "BlackArrow" in current_weapon.name:
			animatedSprite.frames = character._sprites_blackarrow
		elif "PlasmaGun" in current_weapon.name:
			animatedSprite.frames = character._sprites_plasmagun
		elif "BlastLauncher" in current_weapon.name:
			animatedSprite.frames = character._sprites_blastlauncher_A
		elif "BoundBlaster" in current_weapon.name:
			animatedSprite.frames = character._sprites_boundblaster_A
		elif "IceGattling" in current_weapon.name:
			animatedSprite.frames = character._sprites_icegattling_1
		elif "FlameBurner" in current_weapon.name:
			animatedSprite.frames = character._sprites_flameburner
		else:
			animatedSprite.frames = character._sprites_pistol_A

func update_character_palette() -> void :
	if not current_weapon:
		set_pistol_as_weapon()
	if current_weapon_is_pistol():
		character.change_palette(current_weapon.get_palette(), false)
	else:
		character.change_palette(current_weapon.get_palette())

func current_weapon_is_pistol() -> bool:
	if current_weapon != null:
		return "Pistol" in current_weapon.name
	return false

func weapon_cooldown_ended(_weapon) -> void :
	if next_shot_ready and character.listening_to_inputs:
		if has_infinite_regular_ammo() or current_weapon.has_ammo():
			next_shot_ready = false
			if executing:
				EndAbility()
			ExecuteOnce()

func unlock_weapon(collectible: String) -> void :
	for child in get_children():
		if child is WeaponBossAxl:
			if child.should_unlock(collectible):
				child.active = true

func _on_add_to_ammo_reserve(amount) -> void :
	var lowest_ammo_weapon
	for weapon in weapons:
		if weapon is WeaponBossAxl:
			if lowest_ammo_weapon:
				if weapon.current_ammo < lowest_ammo_weapon.current_ammo:
					lowest_ammo_weapon = weapon
			else:
				if weapon.current_ammo < 28:
					lowest_ammo_weapon = weapon
	if lowest_ammo_weapon:
		lowest_ammo_weapon.increase_ammo(amount)
