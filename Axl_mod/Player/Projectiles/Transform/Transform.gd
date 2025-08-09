
extends Node2D
class_name AxlTransform

export  var active: = true
var logs: bool = false
export  var chargeable_without_ammo: = false
export  var shots: Array
export  var max_shots_alive: = 99
export  var max_charged_shots_alive: = 99
export  var max_ammo: = 28.0
export  var ammo_per_shot: = 2

onready var weapon_changer = get_parent().get_parent().get_node("WeaponChanger")
onready var character: = get_parent().get_parent()

var current_ammo: = 28.0
var shots_currently_alive: = 0
var charged_shots_currently_alive: = 0

var shoot_timer: float = 0.0
export  var shoot_delay: float = 1
var sprite_timer: float = 0.0
export  var sprite_delay: float = 5
export  var bullet_speed: float = 300

onready var transform_enemy
var transformed: bool = false
var detransformed: bool = false

export  var recharge_rate: = 1.0
export  var weapon: Resource
export  var _sprites_weapon: SpriteFrames
export  var _sprites_weapon_B: SpriteFrames

onready var parent: = get_parent()
onready var animatedsprite: AnimatedSprite = $"../../animatedSprite"
onready var weapon_stasis: Node2D = $"../../WeaponStasis"
onready var jump_damage: Node2D = $"../../JumpDamage"


var timer: = 0.0
var last_time_hit: = 0.0
const minimum_time_between_recharges: = 0.2


func _ready() -> void :
	character.listen("equipped_armor", self, "on_equip")
	character.listen("zero_health", self, "on_zero_health")
	Event.listen("hit_enemy_with_copy", self, "recharge")
	Event.listen("enemy_kill_with_copy", self, "recharge")
	
func is_cooling_down() -> bool:
	return false

func recharge(_d = null):
	if active and current_ammo < max_ammo:
		if timer > last_time_hit + minimum_time_between_recharges:
			last_time_hit = timer
			current_ammo = clamp(current_ammo + 1.0, 0.0, max_ammo)

func on_equip():
	if character.is_full_armor() == "axl":
		current_ammo = max_ammo
	else:
		active = false
	parent.update_list_of_weapons()
	set_physics_process(active)

func has_ammo() -> bool:
	return current_ammo > 0

func reduce_ammo(expent):
	current_ammo -= expent

func fire(_charge_level: = 0) -> void :
	add_projectile_to_scene(0)
	Event.emit_signal("shot", self)
	weapon_stasis.ExecuteOnce()
	animatedsprite.modulate = Color(1, 1, 1, 0.01)
	character.add_invulnerability("GigaCrash")
	_transform()
	set_physics_process(true)
	
func add_projectile_to_scene(charge_level: int):
	
	var shot_direction_node = character.get_node("ShotDirection")
	var _shot
	_shot = shots[charge_level].instance()
	_shot.spawner = self
	
	CharacterManager.set_axl_colors(_shot.get_node("animatedSprite"))
	_shot.transform_enemy = transform_enemy

	get_tree().current_scene.add_child(_shot, true)
	position_shot(_shot)
	connect_shot_event(_shot)
	
	return _shot
	
func connect_shot_event(_shot):
	_shot.connect("projectile_end", self, "on_shot_end")
	character.listen("zero_health", _shot, "on_death")

func on_zero_health() -> void :
	animatedsprite.modulate = Color.white
	_detransform()

func position_shot(shot) -> void :
	shot.transform = global_transform
	shot.scale.x = character.get_facing_direction()

func on_shot_end(_shot):
	character.remove_invulnerability("GigaCrash")
	weapon_stasis.play_animation("fall")
	weapon_stasis.EndAbility()
	animatedsprite.modulate = Color.white
	_detransform()

func _transform():
	detransformed = false
	transformed = true
	weapon_changer.active = false
	
func _detransform():
	detransformed = true
	transformed = false
	weapon_changer.active = true

func _physics_process(delta: float) -> void :
	timer += delta
	if transformed:
		if character.get_action_pressed("alt_fire"):
			_detransform()
		if current_ammo > 0:
			reduce_ammo(ammo_per_shot * delta)
		else:
			_detransform()
		

