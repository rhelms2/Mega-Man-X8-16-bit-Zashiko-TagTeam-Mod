extends Movement
class_name SaberZero

export  var upgraded: = false
onready var animatedSprite = character.get_node("animatedSprite")
onready var saber_sound: AudioStreamPlayer = $saber

var current_weapon_index: = 0
var weapons = []
var current_weapon
var _listening_to_inputs_start: bool = true
var interrupted_cutscene: bool = false
var slashing: bool = false
var slashes = 0

	
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

func _Interrupt():
	pass

func _ready() -> void :
	if active:
		update_list_of_weapons()
		set_saber_as_weapon()
		Event.listen("add_to_ammo_reserve", self, "_on_add_to_ammo_reserve")

func change_current_weapon_left():
	Log("Changing weapon left")
	var index = weapons.find(current_weapon)
	if index - 1 < 0:
		set_current_weapon(weapons[weapons.size() - 1])
	else:
		set_current_weapon(weapons[index - 1])
	Log("New weapon: " + current_weapon.name)

func change_current_weapon_right():
	Log("Changing weapon right")
	
	var index = weapons.find(current_weapon)
	if index + 1 > weapons.size() - 1:
		set_current_weapon(weapons[0])
	else:
		set_current_weapon(weapons[index + 1])
	Log("New weapon: " + current_weapon.name)

func set_current_weapon(weapon):
	current_weapon = weapon
	if not current_weapon:
		set_saber_as_weapon()





func direct_weapon_select(weapon_resource):
	for weapon in weapons:
		if "weapon" in weapon:
			if weapon.weapon == weapon_resource:
				set_current_weapon(weapon)
				return

func update_character_sprites() -> void :
	if current_weapon_is_saber():
		animatedSprite.frames = character._saber_sprites
	else:
		animatedSprite.frames = character._saber_sprites

func update_list_of_weapons():
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

func weapon_cooldown_ended(_weapon) -> void :
	if character.listening_to_inputs:
		if current_weapon.has_ammo():
			Log("Starting saved shot")
			if executing:
				EndAbility()
			ExecuteOnce()
	
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
