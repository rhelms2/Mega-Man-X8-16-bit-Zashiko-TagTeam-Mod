extends GenericIntro

var starting_pos : Vector2
var entered_ready_animation := false
export var intro_jump_height := 40
onready var particles = $"Snow Explosion"
onready var jump_particles = $"Jump"
onready var land_particles = $"Land"
onready var jump = $jump
onready var land = $land
onready var arms = $arms

func _ready() -> void:
	prepare_for_intro()

func prepare_for_intro() -> void:
	animatedSprite.visible = true
	animatedSprite.modulate = Color(1,1,1,0)

func _Setup():
	._Setup()
	Event.emit_signal("screenshake", 2)

func _Update(delta):
	if attack_stage == 0 and timer > 1:
		turn_and_face_player()
		next_attack_stage_on_next_frame()

	elif attack_stage == 1:
		make_visible()
		set_vertical_speed(-350)
		turn_player_towards_boss()
		toggle_emit(jump_particles, true)
		toggle_emit(particles, true)
		Event.emit_signal("screenshake", 2)
		starting_pos = character.global_position
		jump.play()
		next_attack_stage_on_next_frame()

	elif attack_stage == 2:
		if character.global_position.y < starting_pos.y - intro_jump_height:
			next_attack_stage_on_next_frame()
	
	elif attack_stage == 3:
		process_gravity(delta)
		if timer > 0.2:
			play_animation_once("intro_fall")
		if character.is_on_floor():
			Event.emit_signal("screenshake", 2)
			toggle_emit(land_particles, true)
			land.play()
			next_attack_stage_on_next_frame()

	elif attack_stage == 4:
		play_animation_once("intro_land")
		if timer > 2:
			start_dialog_or_go_to_attack_stage(6)

	elif attack_stage == 5:
		play_animation_once("idle")
		if seen_dialog():
			next_attack_stage_on_next_frame()
	
	elif attack_stage == 6:
		play_animation_once("intro_ready")
		Event.emit_signal("play_boss_music")
		next_attack_stage_on_next_frame()

	elif attack_stage == 7 and timer > 0.55:
		if timer > 0.65 and not entered_ready_animation: #timer > 0.68 and timer < 0.71:
			entered_ready_animation = true
			Event.emit_signal("screenshake", 2)
			Event.emit_signal("boss_health_appear", character)
			arms.play()
			
		if has_finished_last_animation() and timer > 2.5:
			next_attack_stage_on_next_frame()
			
	
	elif attack_stage == 8:
		play_animation_once("intro_end")
		next_attack_stage_on_next_frame()

	elif attack_stage == 9:
		if has_finished_last_animation():
			EndAbility()

