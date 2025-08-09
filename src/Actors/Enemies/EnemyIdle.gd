extends Movement
class_name EnemyIdle

onready var animatedSprite = get_parent().get_node("animatedSprite")
var current_animation := ""
var finished_animation := "'"
export var should_turn := true

func _ready() -> void:
	if active:
		animatedSprite.connect("animation_finished",self,"on_finished_animation")

func _StartCondition() -> bool:
	return character.animatedSprite.visible

func _Setup() -> void:
	current_animation = animatedSprite.animation
	if should_turn:
		turn_and_face_player()
	character.set_horizontal_speed(0)
	character.position.x = round(character.position.x)

func _Update(_delta):
	process_gravity(_delta)
	if timer > 0.4 and current_animation != "idle":
		play_animation_once("idle")
		 
	if "_end" in current_animation or "_land" in current_animation:
		if current_animation == finished_animation:
			play_animation_once("idle")
			finished_animation = "'"

func _EndCondition() -> bool:
	return false
	
func play_animation_on_initialize():
	pass

func on_finished_animation():
	if executing:
		finished_animation = animatedSprite.animation

func turn_and_face_player():
	if GameManager.get_player_position().x > character.global_position.x:
		set_direction(1)
	else:
		set_direction(-1)
