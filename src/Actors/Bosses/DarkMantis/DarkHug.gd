extends GrabAttack
onready var grab_area: Node2D = $GrabArea
onready var drain: AudioStreamPlayer2D = $drain

var munch_timer := 0.0
var munched_times := 0
onready var dash_smoke: Particles2D = $dash_smoke
onready var dash: AudioStreamPlayer2D = $dash

func _ready() -> void:
# warning-ignore:return_value_discarded
	grab_area.connect("touch_target",self,"apply_stuck_state")

func _Setup() -> void:
	._Setup()
	grab_area.handle_direction()
	grabbed_player = false
	mashes_pressed = 0
	munch_timer = 0
	munched_times = 0

func _Update(_delta):
	if attack_stage == 0 and timer > 0.5:
		dash_smoke.emitting = true
		play_animation_once("hug_dash")
		dash.play()
		force_movement(get_horizontal_velocity())
		next_attack_stage_on_next_frame()
	
	elif attack_stage == 1:
		if is_player_nearby_horizontally(48) and is_player_nearby_vertically(48):
			force_movement(0)
			play_animation_once("hug_grab")
			dash_smoke.emitting = false
			next_attack_stage()
		elif timer > 0.75 or is_colliding_with_wall():
			force_movement(0)
			play_animation_once("hug_grab")
			dash_smoke.emitting = false
			next_attack_stage()
	
	elif attack_stage == 2 and timer > 0.064:
		grab_area.activate()
		next_attack_stage_on_next_frame()
	
	elif attack_stage == 3:
		if grabbed_player:
			play_animation_once("hug_munch")
			suck_life(_delta)
			manage_mashing()
			if mashed_enough():
				GameManager.player.stop_forced_movement()
				if munched_times > 0:
					GameManager.player.damage(0,get_parent())# warning-ignore:return_value_discarded
				else:
					GameManager.player.damage(1,get_parent())
				next_attack_stage_on_next_frame()
		else:
			next_attack_stage()
	
	elif attack_stage == 4:
		play_animation_once("hug_end")
		if has_finished_last_animation():
			play_animation_once("idle")
			EndAbility()
	
	#extra
	elif attack_stage == 5: 
		play_animation_once("intro")
		if timer > 1:
			play_animation_once("desperation_prepare")
			next_attack_stage_on_next_frame()
	elif attack_stage == 6 and has_finished_last_animation():
		play_animation_once("desperation_loop")
		if timer > 1:
			EndAbility()
		
func _Interrupt() -> void:
	dash_smoke.emitting = false
	GameManager.player.stop_forced_movement()

func suck_life(delta) -> void:
	munch_timer += delta
	if GameManager.player.current_health <= 0:
		go_to_attack_stage(5)
		return
	if munch_timer > 0.5:
		munch_timer = 0
		drain.play()
		character.recover_health(5)
		GameManager.player.reduce_health(1)
		GameManager.player.animatedSprite.set_frame(0)
		munched_times += 1

func set_player_state_and_animation() -> void:
	GameManager.player.force_movement()
	GameManager.player.play_animation("damage")
	GameManager.player.animatedSprite.set_frame(10)
	GameManager.player.grabbed = true

func reposition_player() -> void:
	var tween := get_tree().create_tween()
# warning-ignore:return_value_discarded
	tween.tween_property(GameManager.player, "global_position", get_safe_player_grab_position(),translate_duration).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_QUAD)

