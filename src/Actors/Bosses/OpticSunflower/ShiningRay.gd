extends AttackAbility

export var shining_ray : PackedScene
onready var prepare: AudioStreamPlayer2D = $prepare
onready var space: Node = $"../Space"

func _Setup() -> void:
	turn_and_face_player()
	play_animation("attack1_prepare")

func _Update(delta) -> void:
	process_gravity(delta)
	
	if attack_stage == 0 and has_finished_last_animation():
		play_animation("attack1")
		prepare.play()
		var s = instantiate(shining_ray)
		var pos = space.center
		pos.y += 16
		s.global_position.y -= 8
		decide_rotate_direction(s)
		Tools.tween(s,"global_position",pos,0.5,Tween.EASE_OUT,Tween.TRANS_SINE)
		next_attack_stage()
	
	elif attack_stage == 1 and timer > 0.5:
		play_animation("attack1_end")
		next_attack_stage()
	
	elif attack_stage == 2 and has_finished_last_animation():
		EndAbility()

func decide_rotate_direction(s) -> void:
	if get_facing_direction() < 0:
		s.rotation_order = Vector2(-90,-450)
