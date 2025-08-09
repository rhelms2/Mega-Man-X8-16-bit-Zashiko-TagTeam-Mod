extends SaberZeroX8Wall


func hitbox_and_position() -> void :
	hitbox_damage = damage
	hitbox_damage_boss = damage_boss
	hitbox_damage_weakness = damage_weakness
	if animatedSprite.frame >= 2 and animatedSprite.frame < 4:
		hitbox_upleft = Vector2(0, - 20)
		hitbox_downright = Vector2(35, 17)
		spawn_hitbox(hitbox_upleft, hitbox_downright)
	reset_hitbox()

func should_add_saber_combo() -> bool:
	return false
