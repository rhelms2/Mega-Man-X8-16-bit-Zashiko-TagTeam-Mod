extends EnemyIdle
class_name BossIdle
onready var boss_ai: Node2D = $"../BossAI"

export var calculate_gravity := true

func _StartCondition() -> bool:
	return boss_ai.active and character.animatedSprite.visible

func _Setup() -> void:
	if should_turn:
		turn_and_face_player()
	character.set_horizontal_speed(0)
	character.position.x = round(character.position.x)
	play_animation_once("idle")

func process_gravity(_delta:float, gravity := default_gravity):
	if calculate_gravity:
		.process_gravity(_delta,gravity)
