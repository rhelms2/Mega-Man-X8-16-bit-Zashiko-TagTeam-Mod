extends Sprite


func _ready() -> void :
	Tools.timer(0.1, "check_for_armor", self)
	pass

func check_for_armor():
	if CharacterManager.current_player_character == "X":
		for item in GameManager.current_armor:
			if "hermes" in item:
				return
			elif "icarus" in item:
				return
	

	queue_free()
