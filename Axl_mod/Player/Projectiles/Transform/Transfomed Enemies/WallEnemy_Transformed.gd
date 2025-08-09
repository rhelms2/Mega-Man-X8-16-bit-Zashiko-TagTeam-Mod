extends AttackAbility
class_name WallEnemyTransformed

var idle_message: bool = false

func _ready() -> void :
	animatedSprite.connect("animation_finished", self, "_on_animation_finished")
	
func _on_animation_finished():
	if animatedSprite.animation == "fall":
		play_animation_once("idle")
	
func _StartCondition() -> bool:
	if not character.is_on_floor():
		if character.is_on_wall():
			return true
	return false

func _EndCondition() -> bool:
	if not character.is_on_wall():
		return true

	return false
	
func _Setup() -> void :
	character.set_horizontal_speed(0)
	character.set_vertical_speed(0)

func _Update(delta: float) -> void :
	if not idle_message:
		idle_message = true
		
		var _wall_dir = - character._is_colliding_with_wall()
		character.rotation = deg2rad(90 * _wall_dir)

	character.set_horizontal_speed(0)
	character.set_vertical_speed(0)

func _Interrupt() -> void :
	idle_message = false
	
func _on_animatedSprite_animation_finished() -> void :
	pass

