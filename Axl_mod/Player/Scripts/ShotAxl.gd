extends Ability
class_name ShotAxl

export  var normal_sprites: SpriteFrames
export  var arm_pointing_sprites: SpriteFrames
export  var default_arm_point_duration: float = 0.3
export  var infinite_regular_ammo: bool = false
export  var infinite_charged_ammo: bool = false

onready var animatedSprite = character.get_node("animatedSprite")

var ammo_cost_reduction: float = 1
var next_bullet_ready: bool = false
var next_shot_ready: bool = false
var arm_point_dur: float = 0.0
var disabled_layer: bool = false
var weapons: Array = []
var current_weapon
var shoot_timer: float = 0.0
var _sprite_delay: float = 0


func _ready() -> void :
	if active:
		update_list_of_weapons()
		set_pistol_as_weapon()
		Event.listen("shot_layer_disabled", self, "on_shot_layer_disabled")
		Event.listen("shot_layer_enabled", self, "on_shot_layer_enabled")
	if actions.size() == 0:
		actions.append("default_action")

func _StartCondition() -> bool:
	if current_weapon:
		return current_weapon.has_ammo()
	return false

func _Setup():
	if current_weapon is Pistol:
		current_weapon.bullet_count = 0
	next_bullet_ready = false
	next_shot_ready = false

func _EndCondition() -> bool:
	if self.name == "Shot" and Input.is_action_pressed("alt_fire"):
		return false
	if self.name == "AltFire" and Input.is_action_pressed("fire"):
		return false
	return not character.is_executing("Forced") and not Input.is_action_pressed(actions[0]) and Has_time_ran_out()

func Has_time_ran_out() -> bool:
	if arm_point_dur != 0:
		return arm_point_dur < timer
	else:
		return default_arm_point_duration < timer

func _Interrupt():
	disable_animation_layer()

func got_hit() -> bool:
	for each in character.executing_moves:
		if each.name == "Damage":
			return true
	return false

func change_gattling_sprites():
	current_weapon._gattling_sprites += 1
	if current_weapon._gattling_sprites > 4:
		current_weapon._gattling_sprites = 1
	if current_weapon._gattling_sprites == 1:
		animatedSprite.frames = current_weapon._gattling_1
	elif current_weapon._gattling_sprites == 2:
		animatedSprite.frames = current_weapon._gattling_2
	elif current_weapon._gattling_sprites == 3:
		animatedSprite.frames = current_weapon._gattling_3
	elif current_weapon._gattling_sprites == 4:
		animatedSprite.frames = current_weapon._gattling_4

func _physics_process(delta: float) -> void :
	if current_weapon != null:
		if current_weapon.sprite_timer > 0:
			current_weapon.sprite_timer -= 1
			if current_weapon.sprite_timer <= 0:
				if current_weapon.name != "IceGattling" and current_weapon.name != "GigaCrash":
					if current_weapon._sprites_weapon:
						animatedSprite.frames = current_weapon._sprites_weapon
				elif current_weapon.name == "IceGattling":
					change_gattling_sprites()
		if not next_bullet_ready:
			current_weapon.shoot_timer -= delta
			if current_weapon.shoot_timer <= 0:
				next_bullet_ready = true

func _Update(_delta: float) -> void :
	if got_hit():
		return
	if action_pressed() and not is_initial_frame():
		var shot_direction_node = character.get_node("ShotDirection")
		shot_direction_node.update_sprite_direction()
		if next_bullet_ready:
			if _StartCondition() and current_weapon.has_ammo():
				current_weapon.fire(0)
				current_weapon.sprite_timer = current_weapon.sprite_delay
				current_weapon.shoot_timer = current_weapon.shoot_delay
				next_bullet_ready = false
				if current_weapon.name != "IceGattling":
					if current_weapon._sprites_weapon_B:
						animatedSprite.frames = current_weapon._sprites_weapon_B
				else:
					change_gattling_sprites()

func update_list_of_weapons():
	weapons.clear()
	for child in get_children():
		if child is WeaponAxl or child is WeaponBossAxl or child is AxlTransform:
			if child.active:
				weapons.append(child)

func set_pistol_as_weapon() -> void :
	next_shot_ready = false
	for weapon in weapons:
		if "Pistol" in weapon.name and weapon.active:
			set_current_weapon(weapon)
			break

func set_current_weapon(weapon):
	next_shot_ready = false
	current_weapon = weapon

func has_infinite_regular_ammo() -> bool:
	return infinite_regular_ammo

func has_infinite_charged_ammo() -> bool:
	return infinite_charged_ammo

func play_animation_on_initialize():
	enable_animation_layer()

func enable_animation_layer():
	Event.emit_signal("shot_layer_enabled")
	disabled_layer = false

func restart_animation():
	if character.get_animation() == "recover":
		character.animatedSprite.set_frame(1)

func action_pressed() -> bool:
	for input in actions:
		if character.get_action_pressed(input):
			return true
	return false

func action_just_pressed() -> bool:
	for input in actions:
		if character.get_action_just_pressed(input):
			return true
	return false

func on_shot_layer_disabled():
	disabled_layer = true

func on_shot_layer_enabled():
	disabled_layer = false
	timer = 0.0

func disable_animation_layer():
	if not disabled_layer:
		Event.emit_signal("shot_layer_disabled")
