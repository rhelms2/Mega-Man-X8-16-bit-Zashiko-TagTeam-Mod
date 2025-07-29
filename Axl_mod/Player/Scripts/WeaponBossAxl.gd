extends WeaponAxl
class_name WeaponBossAxl

export  var weapon: Resource
export  var _sprites_weapon: SpriteFrames
export  var _sprites_weapon_B: SpriteFrames

onready var _gattling_1: Resource = preload("res://Axl_mod/Player/Sprites/ice_gattling/ice_gattling_1.tres")
onready var _gattling_2: Resource = preload("res://Axl_mod/Player/Sprites/ice_gattling/ice_gattling_2.tres")
onready var _gattling_3: Resource = preload("res://Axl_mod/Player/Sprites/ice_gattling/ice_gattling_3.tres")
onready var _gattling_4: Resource = preload("res://Axl_mod/Player/Sprites/ice_gattling/ice_gattling_4.tres")

var _gattling_sprites: int = 1


func _ready() -> void :
	._ready()
	

func on_lemon_shot_created(emitter, _shot):
	if emitter != self:
		pass
		

func add_projectile_to_scene(charge_level) -> void :
	var shot = .add_projectile_to_scene(charge_level)
	Event.emit_signal("shot_lemon", self, shot)

func connect_charged_shot_event(_shot):
	_shot.connect("projectile_started", self, "on_charged_shot_created")
	_shot.connect("projectile_end", self, "on_charged_shot_end")
	if _shot.has_method("set_creator"):
		_shot.set_creator(arm_cannon.character)
	if _shot.has_method("initialize"):
		_shot.call_deferred("initialize", arm_cannon.character.get_facing_direction())
	
func should_unlock(collectible: String) -> bool:
	return collectible == weapon.collectible
