extends Node
class_name ZeroWeapon

export  var active: bool = false

export  var weapon: Resource
export  var max_ammo: float = 28.0
export  var ammo_per_shot: float = 0.0

var current_ammo: float = 28.0


func _ready() -> void :



	pass

func should_unlock(collectible: String) -> bool:
	return collectible == weapon.collectible
