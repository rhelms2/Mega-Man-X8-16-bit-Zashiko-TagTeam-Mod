extends IdleZero

onready var animatedSprite = get_parent().get_node("animatedSprite")
onready var fanshield = get_parent().get_node("FanShield")


func _on_animatedSprite_animation_finished() -> void :
	if executing:
		if character.is_low_health():
			character.play_animation("weak")
		else:
			character.play_animation("idle")
			
		if character.get_animation() == "saber_recover":
			character.set_animation("recover")
		
		if character.saber_node.current_weapon.name == "B-Fan":
			fanshield.activate()
			character.play_animation("idle")

func is_playing_recover() -> bool:
	return character.get_animation() == "recover"

func is_shooting() -> bool:
	return character.get_animation_layer().resource_name == "pointing_cannon"
