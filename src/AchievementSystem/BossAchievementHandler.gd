extends Node
class_name BossAchievementHandler

const busters: = [
	"Lemon", 
	"Medium", 
	"Charged Buster", 
	"Laser Buster", 
	"Triple Buster", 
	"Aux Buster", 
	"JumpDamage", 
	"Axl Bullet", 
	"Copy Bullet", 
	"Saber"
]

export  var defeated_any: bool = true
export  var perfect_kill: bool = true
export  var gigacrush_kill: bool = true
export  var _desperation: NodePath
export  var no_damage: Resource
export  var buster_only: Resource
export  var naked: Resource
export  var defeated: Resource

onready var desperation: = get_node_or_null(_desperation)

var active: bool = false
var taken_damage: bool = false
var damaged_by_special_weapon: bool = false
var has_upgrades: bool = false
var using_desperation: bool = false
var last_hit: String = "none"


func _ready() -> void :
	connect_node("Intro", "ability_end", "start")
	Event.connect("xdrive", self, "on_xdrive")

func start(_d = null) -> void :
	active = true
	GameManager.player.connect("received_damage", self, "damage_check")
	connect_node("Damage", "got_hit", "buster_check")
	connect_node("BossDeath", "screen_flash", "fire_achievements")
	connect_desperation()
	
	upgrade_check()

func connect_node(nodename: String, _signal: String, method: String):
	var node = get_node_or_null("../" + nodename)
	if node != null:
		node.connect(_signal, self, method)
	else:
		push_error("Achievements: " + get_parent().name + "\'s " + nodename + " not found.")

func connect_desperation() -> void :
	if desperation != null:
		desperation.connect("ability_start", self, "on_desperation")
		desperation.connect("ability_end", self, "on_desperation_end")

func on_desperation(_d = null) -> void :
	using_desperation = true
	
func on_desperation_end(_d = null) -> void :
	using_desperation = false

func on_xdrive() -> void :
	if using_desperation:
		Achievements.unlock("XDRIVEDODGE")

func fire_achievements():
	upgrade_check()
	
	if defeated_any:
		pass
		
	if has_achievement_for(no_damage) and not taken_damage:
		Achievements.unlock(no_damage.get_id())
	
	if has_achievement_for(buster_only) and not damaged_by_special_weapon:
		Achievements.unlock(buster_only.get_id())
	
	if has_achievement_for(naked) and not has_upgrades:
		Achievements.unlock(naked.get_id())

	if perfect_kill:
		if not taken_damage and not damaged_by_special_weapon and not has_upgrades:
			Achievements.unlock("PERFECTKILL")
	
	if gigacrush_kill:
		if last_hit == "GigaCrashCharged":
			Achievements.unlock("GIGACRUSHKILL")
	
	if has_achievement_for(defeated):
		Achievements.unlock(defeated.get_id())
	
func damage_check() -> void :
	if not taken_damage:
		taken_damage = true
		

func upgrade_check() -> void :
	has_upgrades = GameManager.player.using_upgrades
	if has_upgrades:
		
		pass

func buster_check(inflicter) -> void :
	
	last_hit = inflicter.name
	for allowed_inflicter in busters:
		if allowed_inflicter in inflicter.name:
			return
	damaged_by_special_weapon = true
	

func has_achievement_for(element: Resource) -> bool:
	return element != null
