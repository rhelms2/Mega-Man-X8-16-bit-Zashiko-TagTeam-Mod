extends LifeUp


func _ready() -> void :
	if CharacterManager.game_mode == 1:
		if check_subtanks() >= 2:
			queue_free()
	if CharacterManager.game_mode > 1:
		queue_free()

func _physics_process(delta: float) -> void :
	if timer > 0:
		timer += delta
		if timer > 1.5:
			if not $audioStreamPlayer2D.playing:
				timer = 0
				GameManager.unpause(name)
				GameManager.player.equip_subtank(collectible_name)
				GlobalVariables.set(collectible_name, 0)
				queue_free()

func process_increase_health(_delta: float) -> void :
	pass

func achievement_check() -> void :
	if check_subtanks() == 4:
		Achievements.unlock("COLLECTALLSUBTANKS")
	else:
		Savefile.save(Savefile.save_slot)

func check_subtanks():
	var subtanks = 0
	for collectible in GameManager.collectibles:
		if "subtank" in collectible:
			subtanks += 1
	return subtanks
