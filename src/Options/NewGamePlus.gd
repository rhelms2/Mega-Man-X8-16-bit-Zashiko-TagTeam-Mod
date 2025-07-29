extends X8TextureButton
class_name NewGamePlusButton

export  var default_label: String = "NEWGAME_OPTION"
export  var confirmation: String = "NEWGAME_CONFIRM"

onready var text: Label = $text

var times_pressed: int = 0
var flashed: bool = false


func _ready() -> void :
	text.text = default_label
	Event.connect("translation_updated", self, "on_update")
	Savefile.connect("loaded", self, "on_loaded")
	on_loaded()

func on_loaded() -> void :
	self.visible = false
	if GlobalVariables.exists("seraph_lumine_defeated"):
		var _deafeted = GlobalVariables.get("seraph_lumine_defeated")
		self.visible = _deafeted

func on_update() -> void :
	text.text = tr(default_label)
	pass

func on_press() -> void :
	times_pressed += 1
	if times_pressed == 1:
		if not flashed:
			strong_flash()
			flashed = true
			menu.play_equip_sound()
		text.text = confirmation
	if times_pressed >= 2:
		menu.play_cancel_sound()
		strong_flash()
		yield(get_tree().create_timer(0.1), "timeout")
		action()

func action() -> void :
	GameManager.remove_collectible_from_savedata("finished_intro")
	
	GameManager.remove_collectible_from_savedata("panda_weapon")
	GameManager.remove_collectible_from_savedata("sunflower_weapon")
	GameManager.remove_collectible_from_savedata("trilobyte_weapon")
	GameManager.remove_collectible_from_savedata("manowar_weapon")
	GameManager.remove_collectible_from_savedata("yeti_weapon")
	GameManager.remove_collectible_from_savedata("rooster_weapon")
	GameManager.remove_collectible_from_savedata("antonion_weapon")
	GameManager.remove_collectible_from_savedata("mantis_weapon")
	
	GameManager.remove_collectible_from_savedata("life_up_panda")
	GameManager.remove_collectible_from_savedata("life_up_sunflower")
	GameManager.remove_collectible_from_savedata("life_up_trilobyte")
	GameManager.remove_collectible_from_savedata("life_up_manowar")
	GameManager.remove_collectible_from_savedata("life_up_yeti")
	GameManager.remove_collectible_from_savedata("life_up_rooster")
	GameManager.remove_collectible_from_savedata("life_up_antonion")
	GameManager.remove_collectible_from_savedata("life_up_mantis")
	
	GameManager.remove_collectible_from_savedata("subtank_trilobyte")
	GameManager.remove_collectible_from_savedata("subtank_sunflower")
	GameManager.remove_collectible_from_savedata("subtank_yeti")
	GameManager.remove_collectible_from_savedata("subtank_rooster")
	
	GameManager.remove_collectible_from_savedata("zero_defeated")



















	GlobalVariables.erase("IGT_NoahsPark")
	
	GlobalVariables.erase("pitch_black_energized")
	GlobalVariables.erase("player_lives")
	GlobalVariables.erase("subtank_rooster")
	GlobalVariables.erase("subtank_sunflower")
	GlobalVariables.erase("subtank_trilobyte")
	GlobalVariables.erase("subtank_yeti")
	GlobalVariables.erase("defeated_antonion_vile")
	GlobalVariables.erase("defeated_panda_vile")
	GlobalVariables.erase("vile3_defeated")
	GlobalVariables.erase("vile_palace_defeated")
	GlobalVariables.erase("copy_sigma_defeated")
	GlobalVariables.erase("seraph_lumine_defeated")
	
	GlobalVariables.erase("red_defeated")
	
	GlobalVariables.erase("serenade_defeated")



	BossRNG.rng.seed = 0
	
	GatewayManager.reset_bosses()
	
	if Savefile.newgame_plus < 100:
		Savefile.newgame_plus += 1
	CharacterManager.game_mode_set = false
	if CharacterManager.game_mode < 3:
		CharacterManager.game_mode += 1
	Savefile.save(Savefile.save_slot)
	CharacterManager._save()
	GameManager.go_to_intro()
	GameManager._ready()

func _on_focus_exited() -> void :
	._on_focus_exited()
	flashed = false
	times_pressed = 0
	text.text = tr(default_label)
