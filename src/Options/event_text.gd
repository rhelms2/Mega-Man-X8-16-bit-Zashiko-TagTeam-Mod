extends Label

func _ready() -> void :
	if CharacterManager.EVENT_MESSAGE != "":
		text = CharacterManager.EVENT_MESSAGE
	else:
		text = ""
