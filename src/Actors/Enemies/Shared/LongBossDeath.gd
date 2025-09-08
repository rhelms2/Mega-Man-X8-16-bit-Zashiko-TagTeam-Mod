extends BossDeath


func _Setup():
	._Setup()
	if "X" in CharacterManager.alive_team:
		GameManager.add_collectible_to_savedata("ultima_head")
		GameManager.add_collectible_to_savedata("ultima_body")
		GameManager.add_collectible_to_savedata("ultima_arms")
		GameManager.add_collectible_to_savedata("ultima_legs")
		Achievements.unlock("COLLECTULTIMATEX")
		Savefile.save(Savefile.save_slot)
		CharacterManager._save()
