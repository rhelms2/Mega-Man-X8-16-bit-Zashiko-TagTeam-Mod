extends X8TextureButton
class_name ConfirmButton

export  var default_label: String = "CLEARSAVE_OPTION"
export  var confirmation: String = "CLEARSAVE_CONFIRM"

onready var text: Label = $text

var times_pressed: int = 0
var flashed: bool = false


func _ready() -> void :
	text.text = tr(default_label)
	Event.connect("translation_updated", self, "on_update")

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
		text.text = tr(confirmation)
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
	GameManager.remove_collectible_from_savedata("zero_seen")
	GameManager.remove_collectible_from_savedata("seen_zero")
	GameManager.remove_collectible_from_savedata("z_saber_zero")
	GameManager.remove_collectible_from_savedata("b_fan_zero")
	GameManager.remove_collectible_from_savedata("d_glaive_zero")
	GameManager.remove_collectible_from_savedata("k_knuckle_zero")
	GameManager.remove_collectible_from_savedata("t_breaker_zero")
	GameManager.remove_collectible_from_savedata("icarus_head")
	GameManager.remove_collectible_from_savedata("icarus_body")
	GameManager.remove_collectible_from_savedata("icarus_arms")
	GameManager.remove_collectible_from_savedata("icarus_legs")
	GameManager.remove_collectible_from_savedata("hermes_head")
	GameManager.remove_collectible_from_savedata("hermes_body")
	GameManager.remove_collectible_from_savedata("hermes_arms")
	GameManager.remove_collectible_from_savedata("hermes_legs")
	GameManager.remove_collectible_from_savedata("ultima_head")
	GameManager.remove_collectible_from_savedata("ultima_body")
	GameManager.remove_collectible_from_savedata("ultima_arms")
	GameManager.remove_collectible_from_savedata("ultima_legs")
	GameManager.remove_collectible_from_savedata("black_zero_armor")
	GameManager.remove_collectible_from_savedata("white_axl_armor")
	GameManager.collectibles = []

	GlobalVariables.erase("IGT_NoahsPark")
	GlobalVariables.erase("igt")
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
	GlobalVariables.erase("red_seen")
	GlobalVariables.erase("red_defeated")
	GlobalVariables.erase("serenade_seen")
	GlobalVariables.erase("serenade_defeated")
	GlobalVariables.erase("RankSSS")
	GlobalVariables.variables = {}
	Savefile.newgame_plus = 0

	BossRNG.rng.seed = 0
	
	GatewayManager.reset_bosses()
	IGT.set_time(0.0)
	IGT.reset()
	CharacterManager.game_mode_set = false
	CharacterManager.game_mode = 0
	Savefile.save(Savefile.save_slot)
	CharacterManager._save()
	GameManager.go_to_intro()
	GameManager._ready()

func _on_focus_exited() -> void :
	._on_focus_exited()
	flashed = false
	times_pressed = 0
	text.text = tr(default_label)
