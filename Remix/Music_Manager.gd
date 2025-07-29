extends Node

onready var level = get_parent()
onready var music_player = level.get_node_or_null("Music Player")


onready var boss_intro_save = music_player.boss_intro
onready var boss_loop_save = music_player.boss_song
onready var angry_boss_intro_save = music_player.angry_boss_intro
onready var angry_boss_loop_save = music_player.angry_boss_song
onready var stage_intro_save = music_player.stage_intro
onready var stage_loop_save = music_player.stage_song
onready var miniboss_intro_save = music_player.miniboss_intro
onready var miniboss_loop_save = music_player.miniboss_song
onready var capsule_loop_save = music_player.capsule_song
onready var stage_clear_save = music_player.stage_clear_song


onready var _maverickintro: AudioStream = preload("res://Remix/Songs/Maverick Intro.ogg")
onready var _weaponget: AudioStream = preload("res://Remix/Songs/Weapon Get.ogg")
onready var _stageclear: AudioStream = preload("res://Remix/Songs/Stage Clear.ogg")
onready var _titlescreen: AudioStream = preload("res://Remix/Songs/Title Screen.ogg")


onready var _boss_intro: AudioStream = preload("res://Remix/Songs/Boss Battle - Intro.ogg")
onready var _boss_loop: AudioStream = preload("res://Remix/Songs/Boss Battle - Loop.ogg")
onready var _bossangry_intro: AudioStream = preload("res://Remix/Songs/Boss Battle - Intro.ogg")
onready var _bossangry_loop: AudioStream = preload("res://Remix/Songs/Boss Battle - Loop.ogg")

onready var _vile_intro: AudioStream = preload("res://Remix/Songs/Vile Battle 1 - Intro.ogg")
onready var _vile_loop: AudioStream = preload("res://Remix/Songs/Vile Battle 1 - Loop.ogg")

onready var _copysigma_intro: AudioStream = preload("res://Remix/Songs/Copy Sigma Battle - Intro.ogg")
onready var _copysigma_loop: AudioStream = preload("res://Remix/Songs/Copy Sigma Battle - Loop.ogg")

onready var _lumine1_loop: AudioStream = preload("res://Remix/Songs/Lumine Battle 1 - Loop.ogg")
onready var _lumine2_intro: AudioStream = preload("res://Remix/Songs/Lumine Battle 2 - Intro.ogg")
onready var _lumine2_loop: AudioStream = preload("res://Remix/Songs/Lumine Battle 2 - Loop.ogg")
onready var _lumineending_loop: AudioStream = preload("res://Remix/Songs/Lumine Ending - Loop.ogg")


onready var _noahspark_intro: AudioStream = preload("res://Remix/Songs/Noahs Park - Intro.ogg")
onready var _noahspark_loop: AudioStream = preload("res://Remix/Songs/Noahs Park - Loop.ogg")


onready var _boosterforest_intro: AudioStream = preload("res://Remix/Songs/Booster Forest - Intro.ogg")
onready var _boosterforest_loop: AudioStream = preload("res://Remix/Songs/Booster Forest - Loop.ogg")
onready var _ridearmor_intro: AudioStream = preload("res://Remix/Songs/Ride Armor - Intro.ogg")
onready var _ridearmor_loop: AudioStream = preload("res://Remix/Songs/Ride Armor - Loop.ogg")


onready var _centralwhite_intro: AudioStream = preload("res://Remix/Songs/Central White - Intro.ogg")
onready var _centralwhite_loop: AudioStream = preload("res://Remix/Songs/Central White - Loop.ogg")


onready var _inferno_loop: AudioStream = preload("res://Remix/Songs/Inferno - Loop.ogg")


onready var _metalvalley_intro: AudioStream = preload("res://Remix/Songs/Metal Valley - Intro.ogg")
onready var _metalvalley_loop: AudioStream = preload("res://Remix/Songs/Metal Valley - Loop.ogg")


onready var _primrose_loop: AudioStream = preload("res://Remix/Songs/Primrose - Loop.ogg")


onready var _troiabase_intro: AudioStream = preload("res://Remix/Songs/Troia Base 1 - Intro.ogg")
onready var _troiabase_loop: AudioStream = preload("res://Remix/Songs/Troia Base 1 - Loop.ogg")
onready var _troiabase2_intro: AudioStream = preload("res://Remix/Songs/Troia Base 2 - Intro.ogg")
onready var _troiabase2_loop: AudioStream = preload("res://Remix/Songs/Troia Base 2 - Loop.ogg")


onready var _jakobelevator_intro: AudioStream = preload("res://Remix/Songs/Jakob - Intro.ogg")
onready var _jakobelevator_loop: AudioStream = preload("res://Remix/Songs/Jakob - Loop.ogg")


onready var _sigmapalace_intro: AudioStream = preload("res://Remix/Songs/Sigma Palace - Intro.ogg")
onready var _sigmapalace_loop: AudioStream = preload("res://Remix/Songs/Sigma Palace - Loop.ogg")


func set_music_remix(_boss_intro, _boss_song, _angry_intro, _angry_song, _stage_intro, _stage_song, _miniboss_intro, _miniboss_song, _capsule_song, _clear_song):
	if Configurations.exists("SongRemix"):
		if Configurations.get("SongRemix"):
			music_player.boss_intro = _boss_intro
			music_player.boss_song = _boss_song
			if music_player.boss_song != null:
				music_player.boss_song.loop = true
			music_player.angry_boss_intro = _angry_intro
			music_player.angry_boss_song = _angry_song
			if music_player.angry_boss_song != null:
				music_player.angry_boss_song.loop = true
			music_player.stage_intro = _stage_intro
			music_player.stage_song = _stage_song
			if music_player.stage_song != null:
				music_player.stage_song.loop = true
			music_player.miniboss_intro = _miniboss_intro
			music_player.miniboss_song = _miniboss_song
			if music_player.miniboss_song != null:
				music_player.miniboss_song.loop = true
			music_player.capsule_song = _capsule_song
			if music_player.capsule_song != null:
				music_player.capsule_song.loop = true
			music_player.stage_clear_song = _clear_song

func _ready() -> void :
	Event.listen("music_changed", self, "change_music")
	change_music()

func change_music() -> void :
	if Configurations.exists("SongRemix"):
		if Configurations.get("SongRemix"):
			set_music()
		else:
			reset_music()
		
		
func reset_music() -> void :
			set_music_remix(
				boss_intro_save, 
				boss_loop_save, 
				angry_boss_intro_save, 
				angry_boss_loop_save, 
				stage_intro_save, 
				stage_loop_save, 
				miniboss_intro_save, 
				miniboss_loop_save, 
				capsule_loop_save, 
				stage_clear_save
			)
			

func set_music() -> void :
	if music_player != null:

		if "NoahsPark" in level.name:
			set_music_remix(
				_boss_intro, 
				_boss_loop, 
				_bossangry_intro, 
				_bossangry_loop, 
				_noahspark_intro, 
				_noahspark_loop, 
				_vile_intro, 
				_vile_loop, 
				capsule_loop_save, 
				_stageclear
			)


		if level.name == "BoosterForest":
			set_music_remix(
				_boss_intro, 
				_boss_loop, 
				_bossangry_intro, 
				_bossangry_loop, 
				_boosterforest_intro, 
				_boosterforest_loop, 
				_vile_intro, 
				_vile_loop, 
				capsule_loop_save, 
				_stageclear
			)


		if level.name == "CentralWhite":
			set_music_remix(
				_boss_intro, 
				_boss_loop, 
				_bossangry_intro, 
				_bossangry_loop, 
				_centralwhite_intro, 
				_centralwhite_loop, 
				_vile_intro, 
				_vile_loop, 
				capsule_loop_save, 
				_stageclear
			)


		if level.name == "Dynasty":
			pass


		if level.name == "Inferno":
			set_music_remix(
				_boss_intro, 
				_boss_loop, 
				_bossangry_intro, 
				_bossangry_loop, 
				load(""), 
				_inferno_loop, 
				_vile_intro, 
				_vile_loop, 
				capsule_loop_save, 
				_stageclear
			)


		if level.name == "MetalValley":
			set_music_remix(
				_boss_intro, 
				_boss_loop, 
				_bossangry_intro, 
				_bossangry_loop, 
				_metalvalley_intro, 
				_metalvalley_loop, 
				_vile_intro, 
				_vile_loop, 
				capsule_loop_save, 
				_stageclear
			)


		if level.name == "PitchBlack":
			pass


		if level.name == "Primrose":
			set_music_remix(
				_boss_intro, 
				_boss_loop, 
				_bossangry_intro, 
				_bossangry_loop, 
				load(""), 
				_primrose_loop, 
				_vile_intro, 
				_vile_loop, 
				capsule_loop_save, 
				_stageclear
			)


		if level.name == "TroiaBase":
			set_music_remix(
				_boss_intro, 
				_boss_loop, 
				_bossangry_intro, 
				_bossangry_loop, 
				_troiabase_intro, 
				_troiabase_loop, 
				_vile_intro, 
				_vile_loop, 
				capsule_loop_save, 
				_stageclear
			)


		if level.name == "JakobElevator":
			set_music_remix(
				_vile_intro, 
				_vile_loop, 
				_bossangry_intro, 
				_bossangry_loop, 
				_jakobelevator_intro, 
				_jakobelevator_loop, 
				_vile_intro, 
				_vile_loop, 
				capsule_loop_save, 
				_stageclear
			)


		if level.name == "Gateway":
			pass


		if level.name == "SigmaPalace":
			set_music_remix(
				_boss_intro, 
				_boss_loop, 
				_bossangry_intro, 
				_bossangry_loop, 
				_sigmapalace_intro, 
				_sigmapalace_loop, 
				_vile_intro, 
				_vile_loop, 
				capsule_loop_save, 
				_stageclear
			)
