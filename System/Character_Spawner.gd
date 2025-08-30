extends Node

export (PackedScene) var player


const teleport_to_vile: bool = false
var teleport_to_boss: bool = CharacterManager.teleport_to_boss
var spawn_ride_armor: bool = false


var _musicmanager_script: Script = preload("res://Remix/Music_Manager.gd")



var _start_cutscene_script: Script = preload("res://src/Levels/NoahsPark/StartCutscene.gd")
var _intro_dialogue: Resource = preload("res://src/DialogSystem/Dialogs/Stages/Intro_Dialogue.tres")


var ridearmor: PackedScene = preload("res://src/Actors/Props/RideArmor/RideArmor.tscn")


var _infinite_scroll: PackedScene = preload("res://Axl_mod/Levels/CentralWhite/CollapsingRepeating.tscn")
var _teleport_light_script: Script = preload("res://src/Levels/CentralWhite/teleport_light.gd")
var _teleport_light_material: Material = preload("res://Axl_mod/Levels/CentralWhite/teleport_light.tres")


var _lightsource_script: Script = preload("res://src/Levels/PitchBlack/X_Lightsource.gd")


var _rotator_script: Script = preload("res://src/Levels/Primrose/rotator.gd")
var _InvulnerabilityOnTeleport_script: Script = preload("res://src/Levels/Primrose/invulnerability_on_rotation.gd")


var _combo_section_script: Script = preload("res://src/Levels/TroiaBase/ComboSection.gd")
var _visual_ranking_object: PackedScene = preload("res://src/Levels/TroiaBase/ComboSystem/VisualRanking.tscn")
var _visual_ranking_script: Script = preload("res://src/Levels/TroiaBase/ComboSystem/VisualRanking.gd")

signal level_initialized


# TeamMod stuff
var player_instance
var team_members: Array = []
var tm_index: int = 0

	# Called when Event signal "character_switch" is emitted
	# Changes the current player to the next team member
func on_character_switch() -> void :
	if team_members.size() > 1:
		Event.emit_signal("weapon_select_buster")
		
		GameManager.pause("CharacterSwitch")
		GameManager.player.pause_mode = PAUSE_MODE_PROCESS

		player_instance.is_current_player = false
		GameManager.inactive_player = player_instance
		
		player_instance.emit_signal("character_switch_out")

		tm_index = (tm_index + 1) % CharacterManager.max_team_size

		player_instance = team_members[tm_index]
		CharacterManager.set_player_character(player_instance.name)
		if player_instance != null:
			player_instance.is_current_player = true
			GameManager.set_player(player_instance)
			GameManager.player.pause_mode = PAUSE_MODE_PROCESS
			player_instance.activate()
			player_instance.active = true
			player_instance.show()
			player_instance.emit_signal("character_switch_in")
			Event.emit_signal("refresh_hud")
			
####

func _ready() -> void :
	teleport_to_boss = CharacterManager.teleport_to_boss
	
	if self.name == "NoahsPark":
		var node: Node = Node.new()
		node.set_name("StartCutscene")
		node.set_script(_start_cutscene_script)
		node.dialogue = _intro_dialogue
		add_child(node)

	Event.listen("character_switch", self, "on_character_switch")
	CharacterManager.set_player_character(CharacterManager.current_team[0])
	player = CharacterManager.get_player_character_object(CharacterManager.player_character)
	player_instance = player.instance()
	player_instance.is_current_player = true
	add_child(player_instance)
	player_instance.position = $CharacterPosition.position
	team_members.append(player_instance)

	if CharacterManager.current_team.size() > 1:

		for i in range(1, CharacterManager.current_team.size()):
			var tm_instance = CharacterManager.get_player_character_object(CharacterManager.current_team[i]).instance()
			tm_instance.position = player_instance.position
			tm_instance.deactivate()
			tm_instance.hide()
			add_child(tm_instance)
			team_members.append(tm_instance)
			GameManager.inactive_player = tm_instance

	else:
		CharacterManager.both_alive = false

	GameManager.team = team_members



	if "NoahsPark" in self.name:
		if teleport_to_boss:
			player_instance.position = Vector2(8424, 279)
			spawn_ride_armor(Vector2(8524, 279))
		spawn_ride_armor_at_start()







	if self.name == "BoosterForest":
		spawn_ride_armor = true
		if teleport_to_vile:
			player_instance.position = Vector2(7546, - 312)
		if teleport_to_boss:
			player_instance.position = Vector2(13714, - 1109)
			spawn_ride_armor(Vector2(13648, - 1112))
		spawn_ride_armor(Vector2(1835, 101))


	if self.name == "CentralWhite":
		if teleport_to_boss:
			player_instance.position = Vector2(3474, - 1306)
			spawn_ride_armor(Vector2(3574, - 1306))
		spawn_ride_armor_at_start()
		
		

		var _scroll_instance = _infinite_scroll.instance()
		get_node("Scenery").add_child(_scroll_instance)
		_scroll_instance.position = Vector2(11472, - 206)
		
		var node = Sprite.new()
		node.set_name("teleport_light")
		node.texture = load("res://src/Effects/Textures/blue_screen.png")
		node.centered = true
		node.position = Vector2(0, 0)
		node.scale = Vector2(200, 100)
		node.z_index = 100
		node.z_as_relative = false
		node.material = _teleport_light_material
		node.set_script(_teleport_light_script)
		get_node("StateCamera").add_child(node)


	if self.name == "Dynasty":
		if teleport_to_boss:
			player_instance.position = Vector2(14427, - 3015)
			spawn_ride_armor(Vector2(14527, - 3015))
		spawn_ride_armor_at_start()


	if self.name == "Inferno":
		if teleport_to_boss:
			player_instance.position = Vector2(7099, 4099)
			
			
			
			spawn_ride_armor(Vector2(7199, 4099))
		spawn_ride_armor(Vector2(700, 1880))
		
	
		var lava_wall = $Objects / LavaWall
		if CharacterManager.game_mode == 1:
			if is_instance_valid(lava_wall):
				lava_wall.speed = 130
		if CharacterManager.game_mode == 2:
			if is_instance_valid(lava_wall):
				lava_wall.speed = 140
		if CharacterManager.game_mode >= 3:
			if is_instance_valid(lava_wall):
				lava_wall.speed = 160
				
		if CharacterManager.game_mode < 0:
			if is_instance_valid(lava_wall):
				lava_wall.speed = 100
	
			var spikes = [
				$Objects / Spikes / SpikeRowSS3, 
				$Objects / Spikes / SpikeRowS5, 
				$Objects / Spikes / SpikeRowS6, 
				$Objects / Spikes / SpikeRowSS4, 
				$Objects / Spikes / SpikeRowS3, 
				$Objects / Spikes / SpikeRowSSS2, 
				$Objects / Spikes / SpikeRowSSS3, 
			]
			for spike in spikes:
				if is_instance_valid(spike):
					spike.queue_free()
		

	if self.name == "MetalValley":
		if teleport_to_boss:
			
			player_instance.position = Vector2( - 488, 631)
			spawn_ride_armor(Vector2( - 388, 631))
			var GiantMechanoloid = get_node("Enemies/GiantMechaniloid")
			GiantMechanoloid.destroy()
		spawn_ride_armor_at_start()


	if self.name == "PitchBlack":
		if teleport_to_boss:
			player_instance.position = Vector2(6293, 2396)
			
			
			
			spawn_ride_armor(Vector2(6393, 2396))
		spawn_ride_armor_at_start()
		
		for p in team_members:
			var node = Light2D.new()
			node.set_name("light")
			node.texture = load("res://src/Levels/PitchBlack/light.png")
			node.energy = 0.35
			node.mode = Light2D.MODE_ADD
			node.range_layer_min = - 2
			node.range_layer_max = - 1
			node.position = Vector2(0, 0)
			node.scale = Vector2(1.5, 1)
			node.z_index = 277
			node.set_script(_lightsource_script)
			p.add_child(node)
		
		if CharacterManager.game_mode < 0:
			var deathshocks = [
				$Objects / DeathShock2
			]
			for deathshock in deathshocks:
				if is_instance_valid(deathshock):
					deathshock.queue_free()
	

	if self.name == "Primrose":
		if teleport_to_vile:
			player_instance.position = Vector2(2654, 1241)
		if teleport_to_boss:
			player_instance.position = Vector2(7448, 884)
			spawn_ride_armor(Vector2(7548, 884))
		spawn_ride_armor_at_start()
		
		
		for p in team_members:
			var node = Node.new()
			node.set_name("rotator")
			node.set_script(_rotator_script)
			p.add_child(node)
			
			node = Node.new()
			node.set_name("InvulnerabilityOnTeleport")
			node.set_script(_InvulnerabilityOnTeleport_script)
			p.add_child(node)


	if self.name == "TroiaBase":
		if teleport_to_boss:
			player_instance.position = Vector2(12824, - 838)
			spawn_ride_armor(Vector2(12924, - 838))
			
			
		spawn_ride_armor_at_start()
		
		for p in team_members:
		
			var combo_label = Label.new()
			combo_label.set_name("combo_label")
			combo_label.margin_left = 9
			combo_label.margin_top = - 88
			combo_label.margin_right = 49
			combo_label.margin_bottom = - 74
			combo_label.rect_position = Vector2(9, - 88)
			combo_label.rect_size = Vector2(40, 24)
			combo_label.visible = false
			p.add_child(combo_label)
		
		
		var visual_ranking_instance = _visual_ranking_object.instance()
		visual_ranking_instance.name = "VisualRanking"
		visual_ranking_instance.position = Vector2(156, - 67)
		visual_ranking_instance.z_index = 100
		visual_ranking_instance.visible = true
		visual_ranking_instance.set_script(_visual_ranking_script)
		get_node("StateCamera").add_child(visual_ranking_instance)

		
		var _section1 = $"./Objects/Section1"
		_section1.set_script(_combo_section_script)
		_section1.s_time_limit = 40.0
		_section1.s_ranking = 100.0
		_section1.a_ranking = 70.0
		_section1.b_ranking = 50.0
		_section1.c_ranking = 25.0
		_section1.d_ranking = 10.0
		_section1._ready()
		var _section2 = $"./Objects/Section2"
		_section2.set_script(_combo_section_script)
		_section2.s_time_limit = 35.0
		_section2.s_ranking = 50.0
		_section2.a_ranking = 40.0
		_section2.b_ranking = 30.0
		_section2.c_ranking = 20.0
		_section2.d_ranking = 10.0
		_section2._ready()
		var _section3 = $"./Objects/Section3"
		_section3.set_script(_combo_section_script)
		_section3.s_time_limit = 45.0
		_section3.s_ranking = 105.0
		_section3.a_ranking = 70.0
		_section3.b_ranking = 50.0
		_section3.c_ranking = 30.0
		_section3.d_ranking = 10.0
		_section3._ready()
		if CharacterManager.game_mode < 0:
			_section1.combo_decrease_damage = 15
			_section1.combo_increase_kill = 5
			_section1.decay_divider = 3
			_section1.s_time_limit = 60.0
			_section1.s_ranking = 100.0
			_section1.a_ranking = 70.0
			_section1.b_ranking = 50.0
			_section1.c_ranking = 25.0
			_section1.d_ranking = 10.0
			
			_section2.combo_decrease_damage = 15
			_section2.combo_increase_kill = 5
			_section2.decay_divider = 3
			_section2.s_time_limit = 50.0
			_section2.s_ranking = 50.0
			_section2.a_ranking = 40.0
			_section2.b_ranking = 30.0
			_section2.c_ranking = 20.0
			_section2.d_ranking = 10.0
			
			_section3.combo_decrease_damage = 15
			_section3.combo_increase_kill = 5
			_section3.decay_divider = 3
			_section3.s_time_limit = 70.0
			_section3.s_ranking = 105.0
			_section3.a_ranking = 70.0
			_section3.b_ranking = 50.0
			_section3.c_ranking = 30.0
			_section3.d_ranking = 10.0
			
		
		if CharacterManager.game_mode < 0:
			var spikes = [
				$Objects / Section3 / spikes, 
				$Objects / Section3 / spikes2, 
				$Objects / Section3 / spikes3, 
				$Objects / Section3 / spikes4, 
				$Objects / Section3 / spikes5
			]
			var names_to_remove = ["spikes2", "spikes3", "spikes5"]
			for spike in spikes:
				if spike.name in names_to_remove:
					if is_instance_valid(spike):
						spike.queue_free()


	if self.name == "JakobElevator":
		if teleport_to_boss:
			player_instance.position = Vector2(2214, - 3768)
			spawn_ride_armor(Vector2(2314, - 3768))
		spawn_ride_armor_at_start()
		
		
		if CharacterManager.game_mode >= 0:
			var invisible_floor = $Scenery / invisiblefloor
			invisible_floor.queue_free()


	if self.name == "Gateway":
		spawn_ride_armor_at_start()
		for p in team_members:
			var node = Light2D.new()
			node.set_name("light")
			node.texture = load("res://src/Levels/PitchBlack/light.png")
			node.energy = 0.35
			node.mode = Light2D.MODE_ADD
			node.range_z_min = - 1024
			node.range_z_max = 1024
			node.range_layer_min = - 2
			node.range_layer_max = - 1
			node.position = Vector2(0, 0)
			node.scale = Vector2(1.5, 1)
			node.z_index = 277
			node.set_script(_lightsource_script)
			p.add_child(node)
			
			node = Node.new()
			node.set_name("InvulnerabilityOnTeleport")
			node.set_script(_InvulnerabilityOnTeleport_script)
			p.add_child(node)


	if self.name == "SigmaPalace":
		if teleport_to_vile:
			player_instance.position = Vector2(3786, - 232)
		if teleport_to_boss:
			player_instance.position = Vector2(7066, - 1034)
			spawn_ride_armor(Vector2(7166, - 1034))
		spawn_ride_armor_at_start()
		
		if CharacterManager.game_mode < 0:
		
			var spikes = [
				$Objects / InstantDeathDealers / spikes5, 
				$Objects / InstantDeathDealers / spikes7, 
				$Objects / InstantDeathDealers / spikes9, 
				$Objects / InstantDeathDealers / spikes10, 
				$Objects / InstantDeathDealers / spikes13, 
			]
			for spike in spikes:
				if is_instance_valid(spike):
					spike.queue_free()


	if CharacterManager.touch_controls_enabled():
		
		var _touch_control_script = load("res://Axl_mod/system/Android/TouchControl.gd")
		var node = Node.new()
		node.set_name("TouchControl")
		node.set_script(_touch_control_script)
		add_child(node)


	emit_signal("level_initialized")
	

func spawn_ride_armor_at_start() -> void :
	if spawn_ride_armor:
		var ridearmor_instance = ridearmor.instance()
		get_node("Objects").add_child(ridearmor_instance)
		ridearmor_instance.position = Vector2($CharacterPosition.position.x + 100, $CharacterPosition.position.y)

func spawn_ride_armor(_position: Vector2) -> void :
	if spawn_ride_armor:
		var ridearmor_instance = ridearmor.instance()
		get_node("Objects").add_child(ridearmor_instance)
		ridearmor_instance.position = _position

