extends NewAbility
class_name DoorPassThrough

const travel_speed: int = 20
const travel_distance: int = 21

onready var tween: TweenController = TweenController.new(self)
onready var direction: float = get_parent().scale.x

var player


func _Setup() -> void :
	player = GameManager.player
	player.force_movement()
	if should_move_vertically():
		player.disable_collision()
		move_vertically()
	if should_freeze_player_animation():
		freeze_player_animation()

func should_freeze_player_animation() -> bool:
	var animator = GameManager.player.animatedSprite
	if animator.frame == 0:
		return animator.animation == "jump" or animator.animation == "slide"
	return false

func freeze_player_animation() -> void :
	GameManager.player.animatedSprite.playing = false

func unfreeze_player_animation() -> void :
	GameManager.player.animatedSprite.playing = true

func should_move_vertically() -> bool:
	var player_position = GameManager.get_player_position().y
	var limits: = Vector2(global_position.y - 10, global_position.y + 10)
	return not Tools.is_between(player_position, limits.x, limits.y)

func _Update(delta: float) -> void :
	player.move_x(travel_speed * direction * delta)

func move_vertically() -> void :
	tween.attribute("global_position:y", global_position.y + 6, 1.5, player)

func _EndCondition() -> bool:
	return has_passed_through() or timer > 2

func has_passed_through() -> bool:
	if direction == 1:
		return GameManager.get_player_position().x > get_final_position()
	else:
		return GameManager.get_player_position().x < get_final_position()

func get_final_position() -> float:
	return global_position.x + (travel_distance * direction)

func _Interrupt() -> void :
	player.set_x(get_final_position())
	player.enable_collision()
	unfreeze_player_animation()
