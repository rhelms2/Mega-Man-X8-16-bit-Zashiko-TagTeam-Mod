extends PizzaDeflect


func set_projectile() -> void :
	pass

func toggle_projectile_damage(_b: bool) -> void :
	pass

func hide_projectile() -> void :
	pass

func projectile_active() -> bool:
	return true

func unhide_projectile() -> void :
	pass

func _ready() -> void :
	pass

func retract_projectile() -> void :
	deactivate_touch_damage()
	play_animation_once("close")
