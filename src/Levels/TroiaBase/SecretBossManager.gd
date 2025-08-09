extends Node

var s_rank_sections: Array

signal unlock_secrets

onready var start_portal: Node2D = $"../StartPortal"
onready var start_entrance: AnimatedSprite = $"../StartEntrance"

onready var secret_door: StaticBody2D = $"../SecretDoor"
onready var entrance_camera: Area2D = $"../../Limits/secret_room_entrance"

onready var entrance_boss_1: AnimatedSprite = $"../Entrance"
onready var portal_boss_1: Node2D = $"../Portal"

onready var entrance_2: AnimatedSprite = $"../Entrance2"
onready var portal_2: Node2D = $"../Portal2"
onready var yellow_particles: Particles2D = $"../Entrance2/particles2D"

onready var entrance_3: AnimatedSprite = $"../Entrance3"
onready var portal_3: Node2D = $"../Portal3"
onready var particles: Particles2D = $"../Entrance3/particles2D"

var unlocking_secret = 0

func on_got_rank_a(section_name: String):
	if section_name == "Section1":
		unlocking_secret += 1
	pass
	
func on_got_rank_b(_section_name: String):
	pass
	
func on_got_rank_c(section_name: String):
	if section_name == "Section2":
		unlocking_secret += 1
	pass
	
func on_got_rank_d(_section_name: String):
	pass
	
func on_got_rank_e(section_name: String):
	if section_name == "Section3":
		unlocking_secret += 1
		if unlocking_secret >= 3:
			pass
	pass

func _ready() -> void :
	
	Event.connect("got_rank_s", self, "on_got_rank_s")
	Event.connect("got_rank_a", self, "on_got_rank_a")
	Event.connect("got_rank_b", self, "on_got_rank_b")
	Event.connect("got_rank_c", self, "on_got_rank_c")
	Event.connect("got_rank_d", self, "on_got_rank_d")
	Event.connect("got_rank_e", self, "on_got_rank_e")
	
	if GlobalVariables.get("RankSSS"):
		Tools.timer(0.1, "unlock", self)

func on_got_rank_s(section_name: String):
	if not section_name in s_rank_sections:
		s_rank_sections.append(section_name)

	if is_able_to_open_door():
		unlock()

func is_able_to_open_door() -> bool:
	return s_rank_sections.size() == 3

func enable_boss_based_on_collectibles():
	enable_boss_1()
	
	if CharacterManager.game_mode < 0:
		enable_boss_3()
		enable_boss_2()
		return
		
	if is_naked():
		enable_boss_3()
		yellow_particles.emitting = true
	else:
		enable_boss_2()
		enable_particles()
		

func unlock():
	emit_signal("unlock_secrets")
	Event.emit_signal("got_rank_sss")
	Achievements.unlock("SUNFLOWERGOTSSSRANK")
	GlobalVariables.set("RankSSS", true)
	
	entrance_camera.enable()
	if is_instance_valid(secret_door):
		secret_door.queue_free()
	enable_start_teleport()
	
	enable_boss_based_on_collectibles()

func enable_start_teleport():
	start_entrance.visible = true
	start_entrance.animation = "default"
	start_portal.activate()

func enable_boss_1():
	
	entrance_boss_1.animation = "default"
	portal_boss_1.activate()

func enable_boss_2():
	entrance_2.animation = "default"
	portal_2.activate()
	

func enable_boss_3():
	
	entrance_3.animation = "default"
	portal_3.activate()

func enable_particles():
	
	particles.emitting = true
	pass

func got_all_weapons() -> bool:
	var unlocked_weapons = 0
	for item in GameManager.collectibles:
		if "_weapon" in item and not "boss_weapon" in item:
			unlocked_weapons += 1
	if unlocked_weapons >= 8:
		return true
	return false

func is_naked() -> bool:
	if is_instance_valid(GameManager.player):
		return not GameManager.player.using_upgrades
	return false
