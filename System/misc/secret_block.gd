extends Node

export  var collectible: String = "defeated"
export  var portal_collectible: String = "seen"
export  var startportal_enabled: bool = true
export  var platform_enabled: bool = true

onready var blocking_wall: CollisionShape2D = $collisionShape2D
onready var platform: = $Platform
onready var start_portal: Node2D = $StartPortal
onready var start_entrance: AnimatedSprite = $StartEntrance

var x_armors: Array = [
	"hermes_head", 
	"hermes_arms", 
	"hermes_body", 
	"hermes_legs", 
	"icarus_head", 
	"icarus_arms", 
	"icarus_body", 
	"icarus_legs", 
	]

func _ready() -> void :
	Event.connect("block_secret", self, "_on_block_event")
	call_deferred("unblock_wall")

func unblock_wall() -> void :




	if check_for_x_armors() and CharacterManager.player_character == "X" or GameManager.is_collectible_in_savedata(collectible):
		
		blocking_wall.disabled = true
		if platform_enabled:
			platform.disabled = false
			platform.visible = true
		if GameManager.is_collectible_in_savedata(portal_collectible):
			
			activate_start_portal()
			






func activate_start_portal() -> void :
	if startportal_enabled:
		start_entrance.visible = true
		start_entrance.animation = "default"
		start_portal.activate()

func check_for_no_armor() -> bool:
	if is_instance_valid(GameManager.player):
		var armor: Array = GameManager.player.current_armor
		if armor == ["no_head", "no_body", "no_arms", "no_legs"]:
			return true
	return false

func _on_block_event() -> void :
	blocking_wall.set_deferred("disabled", false)
	if platform_enabled:
		platform.set_deferred("disabled", true)
		platform.set_deferred("visible", false)

func got_all_weapons() -> bool:
	var unlocked_weapons: int = 0
	for item in GameManager.collectibles:
		if "_weapon" in item and not "boss_weapon" in item:
			unlocked_weapons += 1
	if unlocked_weapons >= 8:
		return true
	return false

func check_for_x_armors() -> bool:
	var total_items = 0.0
	var collected_items = 0.0
	for item in x_armors:
		total_items += 1
		if item in GameManager.collectibles:
			collected_items += 1
	if total_items == collected_items:
		return true
	return false
