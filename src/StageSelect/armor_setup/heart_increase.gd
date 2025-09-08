extends X8OptionButton

onready var heart_enabler = get_parent()
onready var pick = $"../../../../pick"

export var increase_amt: int = 1

func on_press():
	pick.play()
	CharacterManager.set_player_equipped_hearts(heart_enabler.character, heart_enabler.num_equipped+increase_amt)
	heart_enabler.refresh_equipped_hearts()
