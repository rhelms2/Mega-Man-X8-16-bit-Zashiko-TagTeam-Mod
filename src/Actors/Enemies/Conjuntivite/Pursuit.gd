extends GrabAttack
onready var electric: AudioStreamPlayer2D = $electric
onready var pursuit: AudioStreamPlayer2D = $pursuit

onready var animator := $"../animatedSprite"
onready var thundersparks: AnimatedSprite = $"../thundersparks"
onready var grab_area := $GrabArea

func _ready() -> void:
# warning-ignore:return_value_discarded
	grab_area.connect("touch_target",self,"apply_stuck_state")

func _Setup() -> void:
	attack_stage = 0
	mashes_pressed = 0
	grabbed_player = false
	pursuit.play()
	if not is_facing_player():
		play_animation_once("turn")

func _Interrupt() -> void:
	._Interrupt()
	animator.set_speed_scale(1)
	thundersparks.set_speed_scale(1)
	if GameManager.player.ride:
		return
	if grabbed_player:
		GameManager.player.stop_forced_movement()

func BANDAID_fix_freeze_anim_bug():
	animatedSprite.playing = true
	thundersparks.playing = true
	

func _Update(_delta) -> void:
	BANDAID_fix_freeze_anim_bug()
	
	if attack_stage == 0 and timer > 0.35 or attack_stage == 0 and has_finished_animation("turn") :
		var target_direction = Tools.get_player_angle(global_position)
		
		animator.set_speed_scale(3)
		play_animation_once("idle")
		update_direction(target_direction)
		force_movement_regardless_of_direction(horizontal_velocity * target_direction.x) #equivalente a set_horizontal_speed
		set_vertical_speed(horizontal_velocity * target_direction.y)
		if is_player_nearby_horizontally(32) and is_player_nearby_vertically(32):
			next_attack_stage()
			thundersparks.set_speed_scale(8)
			play_animation_once("active")
			animator.set_speed_scale(1)
			force_movement(0)
			set_vertical_speed(0)
		elif not is_player_nearby_horizontally(204) or not is_player_nearby_vertically(204):
			EndAbility()
	
	elif attack_stage == 1:
			grab_area.activate()
			electric.play()
			next_attack_stage_on_next_frame()
	
	if attack_stage == 2:
		if grabbed_player:
			turn_and_face_player()
			manage_mashing()
			if mashed_enough():
				GameManager.player.stop_forced_movement()
				GameManager.player.damage(3,get_parent())# warning-ignore:return_value_discarded
				play_animation_once("idle")
				next_attack_stage_on_next_frame()
				thundersparks.set_speed_scale(1)
		elif timer > 1:
			EndAbility()
				
	if attack_stage == 3 and timer > 3:
		EndAbility()

func update_direction(target : Vector2) -> void:
	if target.x > 0:
		set_direction(1)
	else:
		set_direction(-1)
