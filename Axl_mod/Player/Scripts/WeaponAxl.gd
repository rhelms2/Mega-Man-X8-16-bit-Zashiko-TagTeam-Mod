extends Node2D
class_name WeaponAxl

export  var active: = true
export  var chargeable_without_ammo: = false
export  var shots: Array
export  var max_shots_alive: int = 99
export  var max_charged_shots_alive: int = 99
export  var max_ammo: float = 32.0
export  var ammo_per_shot: float = 0.0
export  var shoot_delay: float = 1
export  var sprite_delay: float = 5
export  var bullet_speed: float = 300
export  var projectile_damage: float = 1.0
export  var projectile_damage_to_bosses: float = 1.0
export  var projectile_damage_to_weakness: float = 1.0

onready var arm_cannon = get_parent()
onready var character: = get_parent().get_parent()
onready var shot_node: = character.get_node("Shot")
onready var alt_shot: = character.get_node("AltFire")

var current_ammo: float = 28.0
var shoot_timer: float = 0.0
var sprite_timer: float = 0.0
var raygun_currently_alive: int = 0
var spiralmagnum_currently_alive: int = 0
var blackarrow_currently_alive: int = 0
var plasmagun_currently_alive: int = 0
var blastlauncher_currently_alive: int = 0
var boundblaster_currently_alive: int = 0
var icegattling_currently_alive: int = 0
var flameburner_currently_alive: int = 0
var raygun_alternate_currently_alive: int = 0
var spiralmagnum_alternate_currently_alive: int = 0
var blackarrow_alternate_currently_alive: int = 0
var plasmagun_alternate_currently_alive: int = 0
var blastlauncher_alternate_currently_alive: int = 0
var boundblaster_alternate_currently_alive: int = 0
var icegattling_alternate_currently_alive: int = 0
var flameburner_alternate_currently_alive: int = 0

var shots_currently_alive: int = 0
var charged_shots_currently_alive: int = 0


func _ready() -> void :
	current_ammo = max_ammo

func get_charge_color() -> Color:
	return Color(1, 1, 1, 1)

func get_palette() -> Array:
	return []

func get_ammo() -> float:
	return current_ammo

func can_shoot() -> bool:
	return get_ammo() > 0 and shots_currently_alive < max_shots_alive

func is_cooling_down() -> bool:
	return false

func reduce_ammo(expent):
	if shot_node.current_weapon.name == "RayGun" and name == "Alternate RayGun":
		shot_node.current_weapon.current_ammo -= expent * shot_node.ammo_cost_reduction
	elif shot_node.current_weapon.name == "SpiralMagnum" and name == "Alternate SpiralMagnum":
		shot_node.current_weapon.current_ammo -= expent * shot_node.ammo_cost_reduction
	elif shot_node.current_weapon.name == "BlackArrow" and name == "Alternate BlackArrow":
		shot_node.current_weapon.current_ammo -= expent * shot_node.ammo_cost_reduction
	elif shot_node.current_weapon.name == "PlasmaGun" and name == "Alternate PlasmaGun":
		shot_node.current_weapon.current_ammo -= expent * shot_node.ammo_cost_reduction
	elif shot_node.current_weapon.name == "BlastLauncher" and name == "Alternate BlastLauncher":
		shot_node.current_weapon.current_ammo -= expent * shot_node.ammo_cost_reduction
	elif shot_node.current_weapon.name == "BoundBlaster" and name == "Alternate BoundBlaster":
		shot_node.current_weapon.current_ammo -= expent * shot_node.ammo_cost_reduction
	elif shot_node.current_weapon.name == "IceGattling" and name == "Alternate IceGattling":
		shot_node.current_weapon.current_ammo -= expent * shot_node.ammo_cost_reduction
	elif shot_node.current_weapon.name == "FlameBurner" and name == "Alternate FlameBurner":
		shot_node.current_weapon.current_ammo -= expent * shot_node.ammo_cost_reduction

func has_ammo() -> bool:
	if shot_node.current_weapon.name == "RayGun" and name == "RayGun":
		return raygun_currently_alive < max_shots_alive
	elif shot_node.current_weapon.name == "SpiralMagnum" and name == "SpiralMagnum":
		return spiralmagnum_currently_alive < max_shots_alive
	elif shot_node.current_weapon.name == "BlackArrow" and name == "BlackArrow":
		return blackarrow_currently_alive < max_shots_alive
	elif shot_node.current_weapon.name == "PlasmaGun" and name == "PlasmaGun":
		return plasmagun_currently_alive < max_shots_alive
	elif shot_node.current_weapon.name == "BlastLauncher" and name == "BlastLauncher":
		return blastlauncher_currently_alive < max_shots_alive
	elif shot_node.current_weapon.name == "BoundBlaster" and name == "BoundBlaster":
		return boundblaster_currently_alive < max_shots_alive
	elif shot_node.current_weapon.name == "IceGattling" and name == "IceGattling":
		return icegattling_currently_alive < max_shots_alive
	elif shot_node.current_weapon.name == "FlameBurner" and name == "FlameBurner":
		return flameburner_currently_alive < max_shots_alive

	elif shot_node.current_weapon.name == "RayGun" and name == "Alternate RayGun":
		return shot_node.current_weapon.get_ammo() > 0 and raygun_alternate_currently_alive < max_shots_alive
	elif shot_node.current_weapon.name == "SpiralMagnum" and name == "Alternate SpiralMagnum":
		return shot_node.current_weapon.get_ammo() > 0 and spiralmagnum_alternate_currently_alive < max_shots_alive
	elif shot_node.current_weapon.name == "BlackArrow" and name == "Alternate BlackArrow":
		return shot_node.current_weapon.get_ammo() > 0 and blackarrow_alternate_currently_alive < max_shots_alive
	elif shot_node.current_weapon.name == "PlasmaGun" and name == "Alternate PlasmaGun":
		return shot_node.current_weapon.get_ammo() > 0 and plasmagun_alternate_currently_alive < max_shots_alive
	elif shot_node.current_weapon.name == "BlastLauncher" and name == "Alternate BlastLauncher":
		return shot_node.current_weapon.get_ammo() > 0 and blastlauncher_alternate_currently_alive < max_shots_alive
	elif shot_node.current_weapon.name == "BoundBlaster" and name == "Alternate BoundBlaster":
		return shot_node.current_weapon.get_ammo() > 0 and boundblaster_alternate_currently_alive < max_shots_alive
	elif shot_node.current_weapon.name == "IceGattling" and name == "Alternate IceGattling":
		return shot_node.current_weapon.get_ammo() > 0 and icegattling_alternate_currently_alive < max_shots_alive
	elif shot_node.current_weapon.name == "FlameBurner" and name == "Alternate FlameBurner":
		return shot_node.current_weapon.get_ammo() > 0 and flameburner_alternate_currently_alive < max_shots_alive
	return get_ammo() > 0 and shots_currently_alive < max_shots_alive

func fire(_charge_level: = 0) -> void :
	add_projectile_to_scene(0)
	reduce_ammo(ammo_per_shot)
	Event.emit_signal("shot", self)

func add_projectile_to_scene(charge_level: int):
	var shot_direction_node = character.get_node("ShotDirection")
	var _shot
	_shot = shots[charge_level].instance()
	var horizontal_dir = character.get_facing_direction()
	var vertical_dir = - 1
	if Input.is_action_pressed("move_up"):
		vertical_dir = - 1
	elif Input.is_action_pressed("move_down"):
		vertical_dir = 1
	character.get_node("offset manager").get_offset()
	shot_direction_node.projectile_speed_control(_shot, bullet_speed, horizontal_dir, vertical_dir)
	get_tree().current_scene.add_child(_shot, true)
	position_shot(_shot)
	connect_shot_event(_shot)
	_shot.damage = projectile_damage
	_shot.damage_to_bosses = projectile_damage_to_bosses
	_shot.damage_to_weakness = projectile_damage_to_weakness
	return _shot

func connect_shot_event(_shot):
	if shot_node.current_weapon.name == "RayGun" and name == "RayGun":
		_shot.connect("projectile_started", self, "on_raygun_created")
		_shot.connect("projectile_end", self, "on_raygun_end")
	elif shot_node.current_weapon.name == "SpiralMagnum" and name == "SpiralMagnum":
		_shot.connect("projectile_started", self, "on_spiralmagnum_created")
		_shot.connect("projectile_end", self, "on_spiralmagnum_end")
	elif shot_node.current_weapon.name == "BlackArrow" and name == "BlackArrow":
		_shot.connect("projectile_started", self, "on_blackarrow_created")
		_shot.connect("projectile_end", self, "on_blackarrow_end")
	elif shot_node.current_weapon.name == "PlasmaGun" and name == "PlasmaGun":
		_shot.connect("projectile_started", self, "on_plasmagun_created")
		_shot.connect("projectile_end", self, "on_plasmagun_end")
	elif shot_node.current_weapon.name == "BlastLauncher" and name == "BlastLauncher":
		_shot.connect("projectile_started", self, "on_blastlauncher_created")
		_shot.connect("projectile_end", self, "on_blastlauncher_end")
	elif shot_node.current_weapon.name == "BoundBlaster" and name == "BoundBlaster":
		_shot.connect("projectile_started", self, "on_boundblaster_created")
		_shot.connect("projectile_end", self, "on_boundblaster_end")
	elif shot_node.current_weapon.name == "IceGattling" and name == "IceGattling":
		_shot.connect("projectile_started", self, "on_icegattling_created")
		_shot.connect("projectile_end", self, "on_icegattling_end")
	elif shot_node.current_weapon.name == "FlameBurner" and name == "FlameBurner":
		_shot.connect("projectile_started", self, "on_flameburner_created")
		_shot.connect("projectile_end", self, "on_flameburner_end")
	
	elif shot_node.current_weapon.name == "Pistol" and name == "GigaCrash":
		_shot.connect("projectile_started", self, "on_shot_created")
		_shot.connect("projectile_end", self, "on_shot_end")

	elif shot_node.current_weapon.name == "RayGun" and name == "Alternate RayGun":
		_shot.connect("projectile_started", self, "on_alternate_raygun_created")
		_shot.connect("projectile_end", self, "on_alternate_raygun_end")
	elif shot_node.current_weapon.name == "SpiralMagnum" and name == "Alternate SpiralMagnum":
		_shot.connect("projectile_started", self, "on_alternate_spiralmagnum_created")
		_shot.connect("projectile_end", self, "on_alternate_spiralmagnum_end")
	elif shot_node.current_weapon.name == "BlackArrow" and name == "Alternate BlackArrow":
		_shot.connect("projectile_started", self, "on_alternate_blackarrow_created")
		_shot.connect("projectile_end", self, "on_alternate_blackarrow_end")
	elif shot_node.current_weapon.name == "PlasmaGun" and name == "Alternate PlasmaGun":
		_shot.connect("projectile_started", self, "on_alternate_plasmagun_created")
		_shot.connect("projectile_end", self, "on_alternate_plasmagun_end")
	elif shot_node.current_weapon.name == "BlastLauncher" and name == "Alternate BlastLauncher":
		_shot.connect("projectile_started", self, "on_alternate_blastlauncher_created")
		_shot.connect("projectile_end", self, "on_alternate_blastlauncher_end")
	elif shot_node.current_weapon.name == "BoundBlaster" and name == "Alternate BoundBlaster":
		_shot.connect("projectile_started", self, "on_alternate_boundblaster_created")
		_shot.connect("projectile_end", self, "on_alternate_boundblaster_end")
	elif shot_node.current_weapon.name == "IceGattling" and name == "Alternate IceGattling":
		_shot.connect("projectile_started", self, "on_alternate_icegattling_created")
		_shot.connect("projectile_end", self, "on_alternate_icegattling_end")
	elif shot_node.current_weapon.name == "FlameBurner" and name == "Alternate FlameBurner":
		_shot.connect("projectile_started", self, "on_alternate_flameburner_created")
		_shot.connect("projectile_end", self, "on_alternate_flameburner_end")

func connect_charged_shot_event(_shot):
	_shot.connect("projectile_started", self, "on_charged_shot_created")
	_shot.connect("projectile_end", self, "on_charged_shot_end")

func position_shot(shot) -> void :
	shot.global_position = character.global_position
	shot.projectile_setup(character.get_facing_direction(), character.shot_position.position)

func on_shot_created():
	shots_currently_alive += 1
func on_shot_end(_shot):
	shots_currently_alive -= 1

func on_charged_shot_created():
	charged_shots_currently_alive += 1
func on_charged_shot_end(_shot):
	charged_shots_currently_alive -= 1

func on_raygun_created():
	raygun_currently_alive += 1
func on_raygun_end(_shot):
	raygun_currently_alive -= 1

func on_spiralmagnum_created():
	spiralmagnum_currently_alive += 1
func on_spiralmagnum_end(_shot):
	spiralmagnum_currently_alive -= 1

func on_blackarrow_created():
	blackarrow_currently_alive += 1
func on_blackarrow_end(_shot):
	blackarrow_currently_alive -= 1

func on_plasmagun_created():
	plasmagun_currently_alive += 1
func on_plasmagun_end(_shot):
	plasmagun_currently_alive -= 1

func on_blastlauncher_created():
	blastlauncher_currently_alive += 1
func on_blastlauncher_end(_shot):
	blastlauncher_currently_alive -= 1

func on_boundblaster_created():
	boundblaster_currently_alive += 1
func on_boundblaster_end(_shot):
	boundblaster_currently_alive -= 1

func on_icegattling_created():
	icegattling_currently_alive += 1
func on_icegattling_end(_shot):
	icegattling_currently_alive -= 1

func on_flameburner_created():
	flameburner_currently_alive += 1
func on_flameburner_end(_shot):
	flameburner_currently_alive -= 1


func on_alternate_raygun_created():
	raygun_alternate_currently_alive += 1
func on_alternate_raygun_end(_shot):
	raygun_alternate_currently_alive -= 1

func on_alternate_spiralmagnum_created():
	spiralmagnum_alternate_currently_alive += 1
func on_alternate_spiralmagnum_end(_shot):
	spiralmagnum_alternate_currently_alive -= 1

func on_alternate_blackarrow_created():
	blackarrow_alternate_currently_alive += 1
func on_alternate_blackarrow_end(_shot):
	blackarrow_alternate_currently_alive -= 1

func on_alternate_plasmagun_created():
	plasmagun_alternate_currently_alive += 1
func on_alternate_plasmagun_end(_shot):
	plasmagun_alternate_currently_alive -= 1

func on_alternate_blastlauncher_created():
	blastlauncher_alternate_currently_alive += 1
func on_alternate_blastlauncher_end(_shot):
	blastlauncher_alternate_currently_alive -= 1

func on_alternate_boundblaster_created():
	boundblaster_alternate_currently_alive += 1
func on_alternate_boundblaster_end(_shot):
	boundblaster_alternate_currently_alive -= 1

func on_alternate_icegattling_created():
	icegattling_alternate_currently_alive += 1
func on_alternate_icegattling_end(_shot):
	icegattling_alternate_currently_alive -= 1

func on_alternate_flameburner_created():
	flameburner_alternate_currently_alive += 1
func on_alternate_flameburner_end(_shot):
	flameburner_alternate_currently_alive -= 1

func recharge_ammo(value: = ammo_per_shot):
	current_ammo = current_ammo + value
	if current_ammo > max_ammo:
		current_ammo = max_ammo

func increase_ammo(value) -> float:
	var excess_value: = 0.0
	current_ammo += value
	if current_ammo > max_ammo:
		excess_value = max_ammo - current_ammo
	current_ammo = clamp(current_ammo, 0.0, max_ammo)
	return excess_value

func expent_ammo(_weapon, emitter):
	if emitter != self:
		current_ammo = current_ammo - ammo_per_shot
