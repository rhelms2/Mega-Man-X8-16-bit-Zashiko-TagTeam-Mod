extends AttackAbility
export (PackedScene) var projectile
onready var cannon: AnimatedSprite = $"../animatedSprite/animatedSprite"
onready var shot_sound: AudioStreamPlayer2D = $shot_sound
onready var rotate: AudioStreamPlayer2D = $rotate

var target_dir : Vector2

var tween : SceneTreeTween
var tween2 : SceneTreeTween

func _Setup() -> void:
	attack_stage = 0
	tween2 = create_tween()
	do_tween2(-4)
	

func do_tween2 (y_difference : float) -> void:
	var final_pos = Vector2(character.position.x,character.position.y + y_difference)
	
# warning-ignore:return_value_discarded
	tween2.tween_property(character, "position", final_pos, 1).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN_OUT)
	
func correct_cannon_rotation() -> void:
	target_dir = Tools.get_player_angle(global_position)
	var difference = target_dir.angle() - cannon.rotation
	if difference < -3:
		cannon.rotation = cannon.rotation - 6
	elif difference > 3:
		cannon.rotation = cannon.rotation + 6

func _Update(_delta) -> void:
	animatedSprite.playing = true
	if attack_stage == 0:
		play_animation_once("arm")
		correct_cannon_rotation()
		rotate.play()
		tween = create_tween()
# warning-ignore:return_value_discarded
		tween.tween_property(cannon, "rotation", target_dir.angle(), 0.65).set_trans(Tween.TRANS_BACK)
		next_attack_stage()

	elif attack_stage ==1 and has_finished_last_animation():
		play_animation_once("aim")
		if timer > 0.65:
			next_attack_stage()
	
	if attack_stage == 2:
		if timer > 0.1:
			next_attack_stage()
		
	elif attack_stage == 3:
		play_animation_once("shot")
		shot_sound.play()
		var shot = instantiate(projectile)
		shot.initialize(1)
		shot.set_creator(self)
		shot.set_horizontal_speed( 200 * target_dir.x)
		shot.set_vertical_speed( 200 * target_dir.y)
		timer = 0
		next_attack_stage()
	
	elif attack_stage == 4 and has_finished_last_animation():
		play_animation_once("disarm")
		tween2 = create_tween()
		do_tween2(4)
		next_attack_stage()
		
	elif attack_stage == 5 and has_finished_last_animation():
		play_animation_once("idle")
		next_attack_stage()
		
	elif attack_stage == 6 and timer > 1:
		EndAbility()
