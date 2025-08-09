extends Movement
class_name FallEnemyTransformed

var idle_message: bool = false

func _ready() -> void :
	character.get_node("animatedSprite").connect("animation_finished", self, "_on_animatedSprite_animation_finished")
	
func _StartCondition() -> bool:
	if not character.is_on_floor() and not character.is_colliding_with_wall() != 0:
		return true

	return false

func _EndCondition() -> bool:
	if character.is_on_floor():
		return true

	return false
	
func _Setup() -> void :
	
	pass

func _Update(delta: float) -> void :
	process_gravity(delta)
	character.animatedSprite.animation = "fall"
	if not idle_message:
		idle_message = true


	character.set_direction(get_pressed_direction())
	update_bonus_horizontal_only_conveyor()

func _Interrupt() -> void :
	idle_message = false
	
func _on_animatedSprite_animation_finished() -> void :
	pass

