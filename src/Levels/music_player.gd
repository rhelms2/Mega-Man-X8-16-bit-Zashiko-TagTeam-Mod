extends AudioStreamPlayer
class_name MusicPlayer

export  var debug_logs: bool = false
export  var stop_song_on_dialogue: bool = true
export  var boss_intro: AudioStream
export  var boss_song: AudioStream
export  var angry_boss_intro: AudioStream
export  var angry_boss_song: AudioStream
export  var stage_clear_song: AudioStream
export  var capsule_song: AudioStream
export  var stage_intro: AudioStream
export  var stage_song: AudioStream
export  var miniboss_intro: AudioStream
export  var miniboss_song: AudioStream
export  var play_angry_boss_theme: bool = true
export  var stage_alt_intro: AudioStream = preload("res://src/Sounds/OST - Metal Valley 1 - Intro.ogg")
export  var stage_alt_loop: AudioStream = preload("res://src/Sounds/OST - Metal Valley 1 - Loop.ogg")

onready var mmx1_boss_intro: AudioStream = preload("res://System/BossMusic/mmx1_intro.ogg")
onready var mmx1_boss_song: AudioStream = preload("res://System/BossMusic/mmx1_loop.ogg")
onready var mmx1_angry_boss_intro: AudioStream = preload("res://System/BossMusic/mmx1_angry_intro.ogg")
onready var mmx1_angry_boss_song: AudioStream = preload("res://System/BossMusic/mmx1_angry_loop.ogg")
onready var mmx2_boss_intro: AudioStream = preload("res://System/BossMusic/mmx2_bossintro.ogg")
onready var mmx2_boss_song: AudioStream = preload("res://System/BossMusic/mmx2_loop.ogg")
onready var mmx2_angry_boss_intro: AudioStream = preload("res://System/BossMusic/mmx2_angry_intro.ogg")
onready var mmx2_angry_boss_song: AudioStream = preload("res://System/BossMusic/mmx2_angry_loop.ogg")
onready var mmx3_boss_intro: AudioStream = preload("res://System/BossMusic/mmx3_bossintro.ogg")
onready var mmx3_boss_song: AudioStream = preload("res://System/BossMusic/mmx3_loop.ogg")
onready var mmx3_angry_boss_intro: AudioStream = preload("res://System/BossMusic/mmx3_angry_intro.ogg")
onready var mmx3_angry_boss_song: AudioStream = preload("res://System/BossMusic/mmx3_angry_loop.ogg")
onready var mmx4_boss_intro: AudioStream = preload("res://System/BossMusic/mmx4_loop.ogg")
onready var mmx4_boss_song: AudioStream = preload("res://System/BossMusic/mmx4_loop.ogg")
onready var mmx4_angry_boss_intro: AudioStream = preload("res://System/BossMusic/mmx4_angry_intro.ogg")
onready var mmx4_angry_boss_song: AudioStream = preload("res://System/BossMusic/mmx4_angry_loop.ogg")
onready var mmx5_boss_intro: AudioStream = preload("res://System/BossMusic/mmx5_intro.ogg")
onready var mmx5_boss_song: AudioStream = preload("res://System/BossMusic/mmx5_loop.ogg")
onready var mmx5_angry_boss_intro: AudioStream = preload("res://System/BossMusic/mmx5_angry_intro.ogg")
onready var mmx5_angry_boss_song: AudioStream = preload("res://System/BossMusic/mmx5_angry_loop.ogg")
onready var mmx6_boss_intro: AudioStream = preload("res://System/BossMusic/mmx6_intro.ogg")
onready var mmx6_boss_song: AudioStream = preload("res://System/BossMusic/mmx6_loop.ogg")
onready var mmx6_angry_boss_intro: AudioStream = preload("res://System/BossMusic/mmx6_angry_intro.ogg")
onready var mmx6_angry_boss_song: AudioStream = preload("res://System/BossMusic/mmx6_angry_loop.ogg")
onready var mmx7_boss_intro: AudioStream = preload("res://System/BossMusic/mmx7_intro.ogg")
onready var mmx7_boss_song: AudioStream = preload("res://System/BossMusic/mmx7_loop.ogg")
onready var mmx7_angry_boss_intro: AudioStream = preload("res://System/BossMusic/mmx7_angry_intro.ogg")
onready var mmx7_angry_boss_song: AudioStream = preload("res://System/BossMusic/mmx7_angry_loop.ogg")
onready var vile_boss_intro: AudioStream = preload("res://System/BossMusic/vile_intro.ogg")
onready var vile_boss_song: AudioStream = preload("res://System/BossMusic/vile_loop.ogg")
onready var finalsigma_boss_intro: AudioStream = preload("res://System/BossMusic/final_sigma_intro.ogg")
onready var finalsigma_boss_song: AudioStream = preload("res://System/BossMusic/final_sigma_loop.ogg")

var fade_in: bool = false
var fade_out: bool = false
var slow_fade_out: bool = false
var fast_fade_out: bool = false
var volume: float = - 6.0
var capsule: bool = false
var next_song_after_fade: Dictionary
var queued_song: AudioStream
var next_song_in: float = 0.0


func Log(_message) -> void :
	if debug_logs:
		
		pass

var stage_music_changes: Array = [
	"BoosterForest", 
	"CentralWhite", 
	"Dynasty", 
	"Inferno", 
	"MetalValley", 
	"PitchBlack", 
	"TroiaBase", 
	"Primrose", 
	]

func check_for_weapons() -> bool:
	var unlocked_weapons = 0
	for weapon in GameManager.collectibles:
		if "_weapon" in weapon and not "boss_weapon" in weapon:
			unlocked_weapons += 1
	return unlocked_weapons

func check_for_stages() -> int:
	if Configurations.exists("BossBattleTheme"):
		var theme_option = Configurations.get("BossBattleTheme")
		for stage in stage_music_changes:
			if get_parent().name in stage:
				return theme_option
	return 0

func set_music_to_boss_beaten(value: int) -> void :
	
	
	match value:
		0:
			boss_intro = mmx1_boss_intro
			boss_song = mmx1_boss_song
			angry_boss_intro = mmx1_angry_boss_intro
			angry_boss_song = mmx1_angry_boss_song
		1:
			boss_intro = mmx2_boss_intro
			boss_song = mmx2_boss_song
			angry_boss_intro = mmx2_angry_boss_intro
			angry_boss_song = mmx2_angry_boss_song
		2:
			boss_intro = mmx3_boss_intro
			boss_song = mmx3_boss_song
			angry_boss_intro = mmx3_angry_boss_intro
			angry_boss_song = mmx3_angry_boss_song
		3:
			boss_intro = mmx4_boss_intro
			boss_song = mmx4_boss_song
			angry_boss_intro = mmx4_angry_boss_intro
			angry_boss_song = mmx4_angry_boss_song
		4:
			boss_intro = mmx5_boss_intro
			boss_song = mmx5_boss_song
			angry_boss_intro = mmx5_angry_boss_intro
			angry_boss_song = mmx5_angry_boss_song
		5:
			boss_intro = mmx6_boss_intro
			boss_song = mmx6_boss_song
			angry_boss_intro = mmx6_angry_boss_intro
			angry_boss_song = mmx6_angry_boss_song
		6:
			boss_intro = mmx7_boss_intro
			boss_song = mmx7_boss_song
			angry_boss_intro = mmx7_angry_boss_intro
			angry_boss_song = mmx7_angry_boss_song
	
	boss_song.loop = true
	angry_boss_song.loop = true

func play_different_song_on_difficulty(stage) -> void :
	if CharacterManager.game_mode > 1:
		if "JakobElevator" in stage:
			boss_intro = vile_boss_intro
			boss_song = vile_boss_song
			angry_boss_intro = vile_boss_intro
			angry_boss_song = vile_boss_song

		elif "SigmaPalace" in stage:
			boss_intro = finalsigma_boss_intro
			boss_song = finalsigma_boss_song
			angry_boss_intro = finalsigma_boss_intro
			angry_boss_song = finalsigma_boss_song
			
		boss_song.loop = true
		angry_boss_song.loop = true

func _ready() -> void :
	Event.listen("cutscene_start", self, "start_fade_out")
	Event.listen("end_cutscene_start", self, "start_fade_out")
	Event.listen("boss_door_open", self, "start_fade_out")
	Event.listen("capsule_open", self, "capsule_fade_out_and_song")
	Event.listen("capsule_dialogue_end", self, "start_fade_in")
	Event.listen("player_death", self, "start_slow_fade_out")
	Event.listen("play_miniboss_music", self, "play_miniboss_song")
	Event.listen("play_boss_music", self, "play_boss_song")
	Event.listen("play_angry_boss_music", self, "play_angry_boss_song")
	Event.listen("stage_clear", self, "play_stage_clear_song")
	Event.listen("play_stage_song", self, "play_stage_song")
	Event.listen("play_stage_alt_song", self, "play_stage_alt_song")
	Event.listen("music_changed", self, "play_korrekt_boss_music")
	
	GameManager.music_player = self
	
	if not stage_song and stream:
		stage_song = stream
	play_korrekt_boss_music()

func play_korrekt_boss_music() -> void :
	if check_for_stages() != 0:
		if check_for_stages() == 9:
			set_music_to_boss_beaten(check_for_weapons())
		else:
			set_music_to_boss_beaten(check_for_stages() - 1)
			
	play_different_song_on_difficulty(get_parent().name)

func play_alternate_stage_music() -> void :
	stage_intro = stage_alt_intro
	stage_song = stage_alt_loop
	next_song_after_fade = {
		"intro": stage_alt_intro, 
		"loop": stage_alt_loop
	}
	fade_out = true
	slow_fade_out = false

func capsule_fade_out_and_song() -> void :
	start_fade_out()
	capsule = true

func start_fade_out() -> void :
	fade_out = true
	fade_in = false
	capsule = false

func start_fade_in() -> void :
	fade_out = false
	slow_fade_out = false
	fade_in = true
	capsule = false

func start_slow_fade_out() -> void :
	slow_fade_out = true
	fade_in = false
	capsule = false

func play_stage_song() -> void :
	volume_db = volume
	queue_loop_if_needed(stage_intro, stage_song)
	fade_out = false
	slow_fade_out = false
	play()

func play_stage_song_regardless_of_volume() -> void :
	queue_loop_if_needed(stage_intro, stage_song)
	fade_out = false
	slow_fade_out = false
	play()

func play_angry_boss_song() -> void :
	if play_angry_boss_theme:
		if stream == angry_boss_intro:
			return
		elif stream == angry_boss_song:
			return
		queue_loop_if_needed(angry_boss_intro, angry_boss_song)
		fade_out = false
		volume_db = volume
		play()

func play_stage_clear_song() -> void :
	stream = stage_clear_song
	fade_out = false
	slow_fade_out = false
	volume_db = volume
	play()

func play_boss_song() -> void :
	queue_loop_if_needed(boss_intro, boss_song)
	fade_out = false
	slow_fade_out = false
	volume_db = volume
	play()

func queue_loop_if_needed(intro, loop) -> void :
	if intro:
		stream = intro
		next_song_in = intro.get_length()
		queued_song = loop
	else:
		stream = loop

func play_song(song: AudioStream, intro = false) -> void :
	start_fade_in()
	if intro and stream == intro:
		return
	elif stream == song:
		return
	queue_loop_if_needed(intro, song)
	play()

func reset_fade_out() -> void :
	fade_out = false
	slow_fade_out = false
	volume_db = volume

func play_song_wo_fadein(song: AudioStream, intro = false) -> void :
	reset_fade_out()
	if intro and stream == intro:
		return
	elif stream == song:
		return
	queue_loop_if_needed(intro, song)
	play()

func is_stream(song, intro = false) -> bool:
	return stream == song or stream == intro

func is_playing_boss_song() -> bool:
	return stream == boss_intro or stream == boss_song

func is_playing_miniboss_song() -> bool:
	return stream == miniboss_intro or stream == miniboss_song

func _physics_process(_delta: float) -> void :
	if queued_song and get_playback_position() >= next_song_in:
		stream = queued_song
		play()
		queued_song = null

func _process(_delta: float) -> void :
	if fade_out:
		volume_db = lerp(volume_db, - 80, _delta / 4)
		if capsule == true and volume_db <= - 25:
			play_song(capsule_song)
		elif volume_db <= - 40 and next_song_after_fade:
			var intro = next_song_after_fade.get("intro", null)
			var loop = next_song_after_fade.get("loop", null)
			play_song(loop, intro)
			next_song_after_fade = {}
			fade_out = false
	elif slow_fade_out:
		volume_db = lerp(volume_db, - 80, _delta / 8)
		
	elif fade_in:
		volume_db = lerp(volume_db, volume, _delta * 4)
		
	if fast_fade_out:
		volume_db = lerp(volume_db, - 80, _delta * 0.33)

func play_miniboss_song() -> void :
	volume_db = volume
	queue_loop_if_needed(miniboss_intro, miniboss_song)
	fade_out = false
	slow_fade_out = false
	play()
