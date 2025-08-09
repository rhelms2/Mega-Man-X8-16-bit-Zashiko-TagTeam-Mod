extends WeaponAxl

export  var boss_animation: String = ""
export  var animation_time: float = 2.0

onready var parent: = get_parent()
onready var giga_crash: = parent.get_node("GigaCrash")
onready var weapon_stasis: Node2D = $"../../WeaponStasis"
onready var animatedSprite: AnimatedSprite = $"../../animatedSprite"
onready var jump_damage: Node2D = $"../../JumpDamage"

func _ready() -> void :
	pass

func has_ammo() -> bool:
	return current_ammo >= ammo_per_shot

func fire(_charge_level: = 0) -> void :
	add_projectile_to_scene()
	giga_crash.reduce_ammo(ammo_per_shot)
	Event.emit_signal("shot", self)
	weapon_stasis.ExecuteOnce()
	animatedSprite.modulate = Color(1, 1, 1, 0.01)
	character.add_invulnerability("BossSpecial")
	parent.is_executing_special = true

func add_projectile_to_scene(charge_level: int = 0):
	var shot_direction_node = character.get_node("ShotDirection")
	var _shot
	_shot = shots[charge_level].instance()
	var shot_sprite = _shot.get_node("animatedSprite")
	CharacterManager.set_axl_colors(shot_sprite)
	_shot.boss_animation = boss_animation
	_shot.animation_time = animation_time
	_shot.z_index = z_index + 4
	get_parent().get_parent().add_child(_shot, true)
	position_shot(_shot)
	connect_shot_event(_shot)
	return _shot

func connect_shot_event(_shot) -> void :
	_shot.connect("projectile_end", self, "on_special_end")
	character.listen("zero_health", _shot, "on_death")

func on_zero_health() -> void :
	animatedSprite.modulate = Color.white

func position_shot(shot) -> void :
	shot.transform = global_transform
	shot.scale.x = character.get_facing_direction()
	shot.global_position = global_position

func on_special_end(_shot):
	character.remove_invulnerability("BossSpecial")
	
	weapon_stasis.EndAbility()
	animatedSprite.modulate = Color.white
	parent.is_executing_special = false
