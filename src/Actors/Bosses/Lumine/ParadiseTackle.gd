extends AttackAbility

onready var space: Node = $"../Space"
onready var tween: = TweenController.new(self, false)
onready var move_feathers: Particles2D = $"../animatedSprite/move_feathers"
onready var woosh: AudioStreamPlayer2D = $woosh
onready var flap: AudioStreamPlayer2D = $flap
onready var debug_visual: Sprite = $"../DamageOnTouch/debug_visual"
onready var charge: AudioStreamPlayer2D = $charge

const travel_speed: = 1500

func _Setup():
	define_range()
	go_to_nearest_position_besides_player()
	play_animation("backwards_start")
	flap.play_rp()
	turn_and_face_player()

func _Update(_delta: float) -> void :
	if attack_stage == 0 and has_finished_last_animation():
		play_animation("backwards")
		next_attack_stage()
	
	elif attack_stage == 2:
		set_height_based_on_player_position()
		show_warning_visuals()
		next_attack_stage()
		
	elif attack_stage == 3 and timer > 0.35:
		play_animation("forward")
		screenshake()
		force_movement(travel_speed)
		woosh.play_rp()
		move_feathers.emitting = true
		next_attack_stage()
		
	elif attack_stage == 4 and timer > 0.35:
		var pos = GameManager.camera.get_camera_screen_center()
		pos.x += 280 * get_facing_direction()
		turn_and_face_player()
		character.global_position = Vector2(pos.x, GameManager.get_player_position().y - 16)
		force_movement(0)
		set_height_based_on_player_position()
		show_warning_visuals()
		next_attack_stage()
		
	elif attack_stage == 5 and timer > 0.35:
		screenshake()
		force_movement(travel_speed)
		woosh.play_rp()
		next_attack_stage()
	
	elif attack_stage == 6 and timer > 0.35:
		force_movement(0)
		var pos = GameManager.camera.get_camera_screen_center()
		pos.x += 280 * get_facing_direction()
		show_warning_visuals()
		turn_and_face_player()
		character.global_position = Vector2(pos.x, pos.y + 38)
		next_attack_stage()
		
	elif attack_stage == 7 and timer > 0.35:
		screenshake()
		force_movement(travel_speed * 0.8)
		woosh.play_rp()
		next_attack_stage()
		
	elif attack_stage == 8 and timer > 0.15:
		play_animation("forward_end")
		Tools.timer_p(0.2, "screenshake", self, 0.8)
		move_feathers.emitting = false
		decay_speed(0.5, 0.65)
		flap.play_rp()
		next_attack_stage()
	
	elif attack_stage == 9 and has_finished_last_animation():
		EndAbility()

var player_height: = 0.0
var prohibited_range: = Vector2.ZERO

func set_height_based_on_player_position():
	player_height = GameManager.get_player_position().y
	define_range()
	if is_in_undodgable_range():
		player_height = get_closest_dodgable_position(player_height)
	
	character.global_position.y = player_height

func define_range():
	var bottom = space.get_bottom()
	prohibited_range = Vector2(bottom + 6, bottom + 40)

func is_in_undodgable_range() -> bool:
	return player_height > prohibited_range.x and player_height < prohibited_range.y




func get_closest_dodgable_position(height: float) -> float:
	var allowable_pos = Vector2(space.get_bottom(), space.get_bottom()) + Vector2(6, 40)
	var h_delta_up = Tools.distance(height, allowable_pos.x)
	var h_delta_down = Tools.distance(height, allowable_pos.y)
	
	if h_delta_up < h_delta_down:
		return allowable_pos.x
		
	return allowable_pos.y

func show_warning_visuals():
	debug_visual.visible = true
	charge.play_rp()
	debug_visual.scale.y = 0.0
	debug_visual.modulate.a = 0.8
	debug_visual.self_modulate = Color.white
	tween.attribute("scale:y", 1.0, 0.15, debug_visual)
	tween.add_attribute("modulate:a", 0.0, 0.5, debug_visual)
	tween.attribute("self_modulate", Color.white, 0.15, debug_visual)
	tween.add_attribute("self_modulate", Color.orange, 0.4, debug_visual)
	tween.add_attribute("self_modulate", Color.red, 0.1, debug_visual)
	tween.add_callback("stop_prepare_sound")

func stop_prepare_sound():
	charge.stop()

func _Interrupt():
	tween.reset()
	move_feathers.emitting = false
	debug_visual.visible = false
	._Interrupt()

func go_to_nearest_position_besides_player() -> void :
	var pos = GameManager.camera.get_camera_screen_center()
	pos.x += 280 * - get_player_direction_relative()
	pos.y = GameManager.get_player_position().y - 16
	var travel_duration = 0.95
	tween.create(Tween.EASE_IN_OUT, Tween.TRANS_SINE)
	tween.add_attribute("global_position", pos, travel_duration, character)
	tween.add_wait(0.35)
	tween.add_callback("next_attack_stage")
	tween.add_callback("turn_and_face_player")
