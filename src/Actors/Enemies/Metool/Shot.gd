extends AttackAbility
export (PackedScene) var projectile
onready var shot_sound: AudioStreamPlayer2D = $shot_sound

func _Update(_delta) -> void:
	if attack_stage == 0 and has_finished_last_animation():
		turn_and_face_player()
		play_animation_once("shot")
		shot_sound.play()
		shoot_towards_player(projectile)
		next_attack_stage_on_next_frame()
	elif attack_stage == 1 and has_finished_last_animation():
		play_animation_once("idle")
		next_attack_stage_on_next_frame()
	elif attack_stage == 2 and timer > 0.5:
		EndAbility()
