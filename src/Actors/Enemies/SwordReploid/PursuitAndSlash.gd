extends AttackAbility
onready var slash: Node2D = $SlashHitbox

func on_nearby_player() -> void :
	force_movement(0)
	play_animation_once("slash_prepare")
	if has_finished_last_animation():
		slash.activate()
		play_animation_once("slash_recover")
		next_attack_stage_on_next_frame()

func _Update(_delta: float) -> void :
	._Update(_delta)

	if attack_stage == 5 and has_finished_last_animation():
		EndAbility()

func turn_and_face_player() -> void :
	.turn_and_face_player()
	slash.handle_direction()
