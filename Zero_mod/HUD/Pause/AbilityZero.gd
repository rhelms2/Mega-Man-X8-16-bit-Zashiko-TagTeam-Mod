extends X8TextureButton

export  var weapon_resource: Resource

onready var abilitiy_title = get_parent().get_parent().get_node("Title")
onready var ability_desc = get_parent().get_parent().get_node("Desc")
onready var deactivated_sprite = get_node("deactivated")

var zero_shot_node


func _ready():
	var _s = menu.connect("pause_starting", self, "on_start")
	call_deferred("handle_weapons", false)

func on_start():
	pass

func _on_focus_entered():
	._on_focus_entered()
	abilitiy_title.text = tr(weapon_resource.title)
	ability_desc.text = tr(weapon_resource.description)

func _on_focus_exited():
	._on_focus_exited()
	abilitiy_title.text = ""
	ability_desc.text = ""

func on_press():
	play_sound()
	handle_weapons(true)

func handle_weapons(switch):
	if is_instance_valid(GameManager.player):
		if GameManager.player.name == "Zero":
			zero_shot_node = GameManager.player.get_node("Shot")
			call_deferred("handle_tenshouha", switch)
			call_deferred("handle_juuhazan", switch)
			call_deferred("handle_rasetsusen", switch)
			call_deferred("handle_raikousen", switch)
			call_deferred("handle_youdantotsu", switch)
			call_deferred("handle_rekkyoudan", switch)
			call_deferred("handle_hyouryuushou", switch)
			call_deferred("handle_enkoujin", switch)
			Savefile.call_deferred("save", Savefile.save_slot)




func remove_all_deactivations():
	GameManager.remove_collectible_from_savedata("tenshouha_deactivated")
	GameManager.remove_collectible_from_savedata("juuhazan_deactivated")
	GameManager.remove_collectible_from_savedata("rasetsusen_deactivated")
	GameManager.remove_collectible_from_savedata("raikousen_deactivated")
	GameManager.remove_collectible_from_savedata("youdantotsu_deactivated")
	GameManager.remove_collectible_from_savedata("rekkyoudan_deactivated")
	GameManager.remove_collectible_from_savedata("hyouryuushou_deactivated")
	GameManager.remove_collectible_from_savedata("enkoujin_deactivated")

func handle_tenshouha(switch):
	if self.name == "sunflower_weapon":
		if switch:
			CharacterManager.tenshouha_active = not CharacterManager.tenshouha_active
		if not zero_shot_node.get_node("Tenshouha").active:
			return
		if CharacterManager.tenshouha_active:
			GameManager.player.Tenshouha = true
			deactivated_sprite.hide()
			GameManager.remove_collectible_from_savedata("tenshouha_deactivated")
		else:
			GameManager.player.Tenshouha = false
			deactivated_sprite.show()
			GameManager.add_collectible_to_savedata("tenshouha_deactivated")

func handle_juuhazan(switch):
	if self.name == "antonion_weapon":
		if switch:
			CharacterManager.juuhazan_active = not CharacterManager.juuhazan_active
		if not zero_shot_node.get_node("Juuhazan").active:
			return
		if CharacterManager.juuhazan_active:
			GameManager.player.Juuhazan = true
			deactivated_sprite.hide()
			GameManager.remove_collectible_from_savedata("juuhazan_deactivated")
		else:
			GameManager.player.Juuhazan = false
			deactivated_sprite.show()
			GameManager.add_collectible_to_savedata("juuhazan_deactivated")

func handle_rasetsusen(switch):
	if self.name == "mantis_weapon":
		if switch:
			CharacterManager.rasetsusen_active = not CharacterManager.rasetsusen_active
		if not zero_shot_node.get_node("Rasetsusen").active:
			return
		if CharacterManager.rasetsusen_active:
			GameManager.player.Rasetsusen = true
			deactivated_sprite.hide()
			GameManager.remove_collectible_from_savedata("rasetsusen_deactivated")
		else:
			GameManager.player.Rasetsusen = false
			deactivated_sprite.show()
			GameManager.add_collectible_to_savedata("rasetsusen_deactivated")

func handle_raikousen(switch):
	if self.name == "manowar_weapon":
		if switch:
			CharacterManager.raikousen_active = not CharacterManager.raikousen_active
		if not zero_shot_node.get_node("Raikousen").active:
			return
		if CharacterManager.raikousen_active:
			GameManager.player.Raikousen = true
			deactivated_sprite.hide()
			GameManager.remove_collectible_from_savedata("raikousen_deactivated")
		else:
			GameManager.player.Raikousen = false
			deactivated_sprite.show()
			GameManager.add_collectible_to_savedata("raikousen_deactivated")

func handle_youdantotsu(switch):
	if self.name == "panda_weapon":
		if switch:
			CharacterManager.youdantotsu_active = not CharacterManager.youdantotsu_active
		if not zero_shot_node.get_node("Youdantotsu").active:
			return
		if CharacterManager.youdantotsu_active:
			GameManager.player.Youdantotsu = true
			deactivated_sprite.hide()
			GameManager.remove_collectible_from_savedata("youdantotsu_deactivated")
		else:
			GameManager.player.Youdantotsu = false
			deactivated_sprite.show()
			GameManager.add_collectible_to_savedata("youdantotsu_deactivated")

func handle_rekkyoudan(switch):
	if self.name == "trilobyte_weapon":
		var rekkyoudan = GameManager.player.get_node("Shot/Rekkyoudan")
		if rekkyoudan:
			if switch:
				CharacterManager.rekkyoudan_active = not CharacterManager.rekkyoudan_active
			if not zero_shot_node.get_node("Rekkyoudan").active:
				return
			if CharacterManager.rekkyoudan_active:
				rekkyoudan.set_ability()
				deactivated_sprite.hide()
				GameManager.remove_collectible_from_savedata("rekkyoudan_deactivated")
			else:
				CharacterManager.rekkyoudan_active = false
				rekkyoudan.unset_ability()
				deactivated_sprite.show()
				GameManager.add_collectible_to_savedata("rekkyoudan_deactivated")
			
			var _pause_HUD = menu.get_node("pause")
			var _lives_HUD = _pause_HUD.get_node("Lives")
			var _zero_icon = _lives_HUD.get_node("Zero_icon")
			CharacterManager.set_saberX8_colors(_zero_icon)

func handle_hyouryuushou(switch):
	if self.name == "yeti_weapon":
		if switch:
			CharacterManager.hyouryuushou_active = not CharacterManager.hyouryuushou_active
		if not zero_shot_node.get_node("Hyouryuushou").active:
			return
		if CharacterManager.hyouryuushou_active:
			GameManager.player.Hyouryuushou = true
			deactivated_sprite.hide()
			GameManager.remove_collectible_from_savedata("hyouryuushou_deactivated")
		else:
			GameManager.player.Hyouryuushou = false
			deactivated_sprite.show()
			GameManager.add_collectible_to_savedata("hyouryuushou_deactivated")

func handle_enkoujin(switch):
	if self.name == "rooster_weapon":
		if switch:
			CharacterManager.enkoujin_active = not CharacterManager.enkoujin_active
		if not zero_shot_node.get_node("Enkoujin").active:
			return
		if CharacterManager.enkoujin_active:
			GameManager.player.Enkoujin = true
			deactivated_sprite.hide()
			GameManager.remove_collectible_from_savedata("enkoujin_deactivated")
		else:
			GameManager.player.Enkoujin = false
			deactivated_sprite.show()
			GameManager.add_collectible_to_savedata("enkoujin_deactivated")
