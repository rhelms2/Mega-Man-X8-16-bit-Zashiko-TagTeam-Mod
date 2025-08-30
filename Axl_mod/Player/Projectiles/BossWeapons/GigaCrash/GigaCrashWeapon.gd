extends WeaponAxl

const minimum_time_between_recharges: float = 0.2

export  var recharge_rate: float = 1.0
export  var weapon: Resource

onready var parent: = get_parent()
onready var animatedsprite: AnimatedSprite = $"../../animatedSprite"
onready var weapon_stasis: Node2D = $"../../WeaponStasis"
onready var jump_damage: Node2D = $"../../JumpDamage"
onready var vfx: AnimatedSprite = $break_vfx
onready var vfx_casted: bool = false
onready var tween: SceneTreeTween
onready var sprite_floor: Resource = preload("res://Axl_mod/Player/Projectiles/BossWeapons/GigaCrash/gigacrash.res")
onready var sprite_air: Resource = preload("res://Axl_mod/Player/Projectiles/BossWeapons/GigaCrash/gigacrash_air.tres")

var timer: float = 0.0
var last_time_hit: float = 0.0
var recharge_exceptions: Array = [
		"BlackArrow Special", 
	]


func _ready() -> void :
	character.listen("equipped_armor", self, "on_equip")
	character.listen("zero_health", self, "on_zero_health")
	Event.listen("hit_enemy", self, "recharge")
	Event.listen("enemy_kill", self, "recharge")
	Event.listen("special_end", self, "reset_ammo_to_zero")
	
func reset_ammo_to_zero() -> void:
	current_ammo = 0

func recharge(_d = null) -> void :
	if current_ammo < max_ammo:
		for child in parent.get_parent().get_children():
			if child is SpecialAbilityAxl:
				if child.name in recharge_exceptions:
					return
		if timer > last_time_hit + minimum_time_between_recharges:
			last_time_hit = timer
			current_ammo = clamp(current_ammo + recharge_rate, 0.0, max_ammo)

func on_equip() -> void :
	active = true
	current_ammo = max_ammo
	Event.emit_signal("special_activated", self, character)
	parent.update_list_of_weapons()
	set_physics_process(active)

func has_ammo() -> bool:
	return current_ammo >= max_ammo

func reduce_ammo(expent):
	current_ammo -= expent

func fire(_charge_level: = 0) -> void :
	parent.set_pistol_as_weapon()
	add_projectile_to_scene(0)
	reduce_ammo(ammo_per_shot)
	Event.emit_signal("shot", self)
	weapon_stasis.ExecuteOnce()
	jump_damage.effect.visible = false
	animatedsprite.modulate = Color(1, 1, 1, 0.01)
	character.add_invulnerability("GigaCrash")
	parent.is_executing_special = true
	character.is_executing_special = true

func add_projectile_to_scene(charge_level: int):
	var shot_direction_node = character.get_node("ShotDirection")
	var _shot
	_shot = shots[charge_level].instance()

	var _sprite = _shot.get_node("animatedSprite")
	if character.is_on_floor():
		_sprite.frames = sprite_floor
	else:
		_sprite.frames = sprite_air
	CharacterManager.set_axl_colors(_shot.get_node("animatedSprite"))

	get_tree().current_scene.add_child(_shot, true)
	position_shot(_shot)
	connect_shot_event(_shot)
	return _shot

func connect_shot_event(_shot) -> void :
	_shot.connect("projectile_end", self, "on_shot_end")
	character.listen("zero_health", _shot, "on_death")

func on_zero_health() -> void :
	animatedsprite.modulate = Color.white

func position_shot(shot) -> void :
	shot.transform = global_transform
	shot.scale.x = character.get_facing_direction()

func on_shot_end(_shot) -> void :
	character.remove_invulnerability("GigaCrash")
	if character.is_on_floor():
		weapon_stasis.play_animation("idle")
	else:
		weapon_stasis.play_animation("fall")
	weapon_stasis.EndAbility()
	animatedsprite.modulate = Color.white
	parent.is_executing_special = false
	character.is_executing_special = false
	Event.emit_signal("special_end")

func _physics_process(delta: float) -> void :
	timer += delta


	if has_ammo() and not vfx_casted:
		vfx.frame = 0
		vfx_casted = true
	elif not has_ammo() and vfx_casted:
		vfx_casted = false
