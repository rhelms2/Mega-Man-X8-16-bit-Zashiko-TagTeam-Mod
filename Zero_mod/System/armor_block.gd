extends Node
class_name ZeroBlocking

export  var active: bool = false
export  var character_name: String = ""
export  var difficulty_minumum: int = 0
export  var need_all_weapons: bool = true
export  var need_all_zero_weapons: bool = false
export  var savefile_unlockable: bool = true
export  var collectible: String = ""
export  var block_if_collected: bool = true
export  var permanent_unlock: String = ""

onready var blocking_wall: CollisionShape2D = $collisionShape2D

var unlocked: bool = true

func _ready() -> void :
	if active:
		Event.connect("alarm", self, "_on_block_event")
		Event.connect("pitch_black_energized", self, "_on_block_event")
		call_deferred("block_wall")

func block_wall() -> void :
	if block_if_collected:
		if savefile_unlockable:
			if collectible != "":
				if collectible in GameManager.collectibles:
					unlocked = false
		else:
			if permanent_unlock != "":
				if permanent_unlock in CharacterManager:
					if CharacterManager.get(permanent_unlock) == true:
						unlocked = false
	
	if character_name != "":
		if not character_name in CharacterManager.team:
			unlocked = false
	
	if need_all_weapons and not got_all_boss_weapons():
		unlocked = false
	
	if need_all_zero_weapons and not got_all_zero_weapons():
		unlocked = false
	
	if CharacterManager.game_mode < difficulty_minumum:
		unlocked = false

	blocking_wall.disabled = unlocked

func _on_block_event() -> void :
	blocking_wall.set_deferred("disabled", false)

func got_all_boss_weapons() -> bool:
	var unlocked_weapons = 0
	for item in GameManager.collectibles:
		if "_weapon" in item and not "boss_weapon" in item:
			unlocked_weapons += 1
	if unlocked_weapons >= 8:
		return true
	return false

func got_all_zero_weapons() -> bool:
	var unlocked_weapons = 0
	for item in GameManager.collectibles:
		if "_zero" in item and not "seen_zero" in item:
			unlocked_weapons += 1
			
	if unlocked_weapons >= 5:
		return true
	return false
