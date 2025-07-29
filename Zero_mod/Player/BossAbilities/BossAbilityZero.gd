extends Node
class_name BossAbilityZero

const max_ammo: float = 28.0

export  var active: bool = false
export  var can_buffer: bool = true
export  var weapon: Resource
export  var current_ammo: float = 28.0

onready var character: Character = get_parent().get_parent()
onready var animatedSprite: = character.get_node("animatedSprite")


func _ready() -> void :
	call_deferred("set_ability")

func set_ability() -> void :
	if active:
		return

func should_unlock(collectible: String) -> bool:
	return collectible == weapon.collectible
