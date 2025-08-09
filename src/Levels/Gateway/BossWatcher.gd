extends Node2D

export  var final_section_intro: AudioStream
export  var final_section_loop: AudioStream

onready var stage_intro: AudioStream = preload("res://src/Sounds/OST - Gateway - Intro.ogg")
onready var stage_loop: AudioStream = preload("res://src/Sounds/OST - Gateway - Loop.ogg")

onready var ready_effect: Sprite = $"../charge_circle2"

var beaten_bosses: Array
var crystals_ready: Array
var sprites: Array

signal ready_for_battle
signal prepare_for_sigma
signal remove_explosions


func _ready() -> void :
	Event.connect("gateway_crystal_get", self, "on_crystal_got")
	Event.connect("gateway_segment_cleared", self, "on_crystal_got")
	Event.connect("gateway_boss_defeated", self, "on_boss_defeated")
	Event.connect("gateway_final_section", self, "start_final_section")
	Tools.timer(0.1, "update_based_on_savedata", self)
	for child in get_children():
		if child is AnimatedSprite:
			sprites.append(child)
			child.visible = false
	
	call_deferred("on_skipgateway", "SkipGateway")
	
func fight_all_mavericks() -> void :
	Event.emit_signal("gateway_crystal_get", "sunflower")
	Event.emit_signal("gateway_crystal_get", "antonion")
	Event.emit_signal("gateway_crystal_get", "panda")
	Event.emit_signal("gateway_crystal_get", "trilobyte")
	Event.emit_signal("gateway_crystal_get", "mantis")
	Event.emit_signal("gateway_crystal_get", "yeti")
	Event.emit_signal("gateway_crystal_get", "manowar")
	Event.emit_signal("gateway_crystal_get", "rooster")

func connect_skip_gateway() -> void :
	Configurations.listen("value_changed", self, "on_skipgateway")

func on_skipgateway(key) -> void :
	if key == "SkipGateway":
		if Configurations.get("SkipGateway") == 1:
			GatewayManager.beaten_bosses = ["antonion", "sunflower", "trilobyte", "panda", "mantis", "manowar", "yeti", "rooster"]
			Tools.timer(0.1, "update_based_on_savedata", self)
			
			Event.emit_signal("gateway_skip")
		elif Configurations.get("SkipGateway") == 2:
			
			fight_all_mavericks()
		else:
			pass
			

func full_reset_gateway() -> void :
	beaten_bosses.clear()
	crystals_ready.clear()
	for child in get_children():
		if child is AnimatedSprite:
			sprites.append(child)
			child.visible = false
	GatewayManager.reset_bosses()
	GatewayManager.on_segments_reset()
	emit_signal("remove_explosions")
	Event.emit_signal("gateway_full_reset")
	GameManager.music_player.start_slow_fade_out()

func update_based_on_savedata() -> void :
	var bosses = 0
	for boss in GatewayManager.beaten_bosses:
		Event.emit_signal("gateway_boss_defeated", boss)
		bosses += 1
		
	if bosses < 8:
		for segment in GatewayManager.cleared_segments:
			Event.emit_signal("gateway_segment_cleared", segment)
	
	if has_defeated_all_bosses():
		GameManager.music_player.start_slow_fade_out()
		Tools.timer(2, "start_final_section", self)

func on_boss_defeated(boss_name) -> void :
	if not boss_name in beaten_bosses:
		beaten_bosses.append(boss_name)
	
	remove_ready_crystal(boss_name)
	if crystals_ready.size() < 2:
		Event.emit_signal("gateway_unlock_capsules")

func add_ready_crystal(boss_name) -> void :
	crystals_ready.append(boss_name)
	for sprite in sprites:
		if not sprite.visible:
			sprite.visible = true
			sprite.play(boss_name)
			break

func remove_ready_crystal(boss_name) -> void :
	crystals_ready.erase(boss_name)
	for sprite in sprites:
		if sprite.animation == boss_name:
			sprite.visible = false
			break

func on_crystal_got(boss_name) -> void :
	if not boss_name in crystals_ready:
		add_ready_crystal(boss_name)
	if has_enough_crystals():
		Event.emit_signal("gateway_lock_capsules")
		Tools.timer(0.5, "activate", ready_effect)
		emit_signal("ready_for_battle")

func has_enough_crystals() -> bool:
	if has_one_boss_left():
		return crystals_ready.size() >= 1
	else:
		return crystals_ready.size() >= 2

func has_one_boss_left() -> bool:
	return beaten_bosses.size() == 7

func has_defeated_all_bosses() -> bool:
	return beaten_bosses.size() == 8

func play_battle_song() -> void :
	GameManager.music_player.reset_fade_out()
	GameManager.music_player.play_angry_boss_song()

func _on_Door_open() -> void :
	if has_enough_crystals():
		GameManager.music_player.start_slow_fade_out()
	ready_effect.deactivate()

func _on_Door_finish() -> void :
	pass

func _on_bosses_defeated() -> void :
	GameManager.music_player.start_slow_fade_out()
	if not has_defeated_all_bosses():
		Tools.timer(6, "restart_stage_music", self)
	else:
		Tools.timer(6, "start_final_section", self)

func restart_stage_music():
	GameManager.music_player.play_stage_song_regardless_of_volume()
	GameManager.music_player.start_fade_in()

func _on_Door_closing_freeway() -> void :
	pass

func start_final_section() -> void :
	GameManager.music_player.play_song_wo_fadein(final_section_loop, final_section_intro)
	emit_signal("prepare_for_sigma")

func _on_Door_close() -> void :
	Tools.timer(4.7, "play_battle_song", self)
