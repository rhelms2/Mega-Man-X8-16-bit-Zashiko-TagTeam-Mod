extends Node2D
class_name Weapon

export  var active: bool = true
export  var chargeable_without_ammo: bool = false
export  var shots: Array
export  var max_shots_alive: int = 3
export  var max_charged_shots_alive: int = 3
export  var max_ammo: float = 100.0
export  var ammo_per_shot: float = 1.0

export  var MainColor1: Color
export  var MainColor2: Color
export  var MainColor3: Color
export  var MainColor4: Color
export  var MainColor5: Color
export  var MainColor6: Color

onready var arm_cannon = get_parent()
onready var character: Character = get_parent().get_parent()

var shots_currently_alive: int = 0
var charged_shots_currently_alive: int = 0
var current_ammo: float = 100.0
var logs: bool = false

func _ready() -> void :
	current_ammo = max_ammo

func get_charge_color() -> Color:
	return MainColor2

func get_palette() -> Array:
	return [MainColor1, MainColor2, MainColor3, MainColor4, MainColor5, MainColor6]

func get_ammo() -> float:
	return current_ammo

func can_shoot() -> bool:
	return get_ammo() > 0 and shots_currently_alive < max_shots_alive

func fire(charge_level: int = 0) -> void :
	clamp_to_max_charge(charge_level)
	add_projectile_to_scene(charge_level)
	reduce_ammo(ammo_per_shot)
	Event.emit_signal("shot", self)

func has_ammo() -> bool:
	return true

func is_cooling_down() -> bool:
	return false

func reduce_ammo(expent: float) -> void :
	current_ammo -= expent

func add_projectile_to_scene(charge_level: int):
	var _shot
	_shot = shots[charge_level].instance()
	get_tree().current_scene.add_child(_shot, true)
	position_shot(_shot)
	if charge_level != 0:
		connect_charged_shot_event(_shot)
	else:
		connect_shot_event(_shot)
	return _shot

func connect_shot_event(_shot: KinematicBody2D) -> void :
	_shot.connect("projectile_started", self, "on_shot_created")
	_shot.connect("projectile_end", self, "on_shot_end")

func connect_charged_shot_event(_shot: KinematicBody2D) -> void :
	_shot.connect("projectile_started", self, "on_charged_shot_created")
	_shot.connect("projectile_end", self, "on_charged_shot_end")

func on_shot_created() -> void :
	shots_currently_alive += 1

func on_charged_shot_created() -> void :
	charged_shots_currently_alive += 1

func on_shot_end(_shot: KinematicBody2D) -> void :
	shots_currently_alive -= 1

func on_charged_shot_end(_shot: KinematicBody2D) -> void :
	charged_shots_currently_alive -= 1

func clamp_to_max_charge(charge_level: int) -> void :
	if charge_level > shots.size() - 1:
		charge_level = shots.size() - 1

func position_shot(shot: KinematicBody2D) -> void :
	shot.global_position = character.global_position
	shot.projectile_setup(character.get_facing_direction(), character.shot_position.position)

func recharge_ammo(value: float = ammo_per_shot) -> void :
	current_ammo = current_ammo + value
	if current_ammo > max_ammo:
		current_ammo = max_ammo

func expent_ammo(_weapon, emitter) -> void :
	if emitter != self:
		current_ammo = current_ammo - ammo_per_shot
