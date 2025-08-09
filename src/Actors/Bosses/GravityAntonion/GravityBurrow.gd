extends AttackAbility
onready var damage: Node2D = $"../Damage"
onready var damage_on_touch: Node2D = $"../DamageOnTouch"
onready var collision: Particles2D = $collision
onready var burrow: Particles2D = $burrow
onready var burrow_2: Particles2D = $burrow2
onready var burrow_sfx: AudioStreamPlayer2D = $burrow3
onready var jump: AudioStreamPlayer2D = $jump
onready var land: AudioStreamPlayer2D = $land

func _Update(delta) -> void:
	process_gravity(delta)
	if attack_stage == 0 and character.is_on_floor():
		turn_and_face_player()
		play_animation("burrow_prepare")
		next_attack_stage()
		
	
	elif attack_stage == 1 and has_finished_last_animation():
		play_animation("burrow")
		burrow_sfx.play()
		burrow.emitting = true
		burrow_2.emitting = true
		activate_invulnerability()
		Tools.timer(0.4,"deactivate_contact_damage",self)
		next_attack_stage()
	
	elif attack_stage == 2 and has_finished_last_animation():
		burrow.emitting = false
		burrow_2.emitting = false
		character.global_position.x = GameManager.get_player_position().x
		next_attack_stage()

	elif attack_stage == 3 and timer > 0.25:
		collision.emitting = true
		jump.play()
		turn_and_face_player()
		play_animation("jump")
		activate_contact_damage()
		deactivate_invulnerability()
		next_attack_stage_on_next_frame()
		
	elif attack_stage == 4:
		set_vertical_speed(-470.0)
		next_attack_stage()
	
	elif attack_stage == 5 and timer > 0.5 and get_vertical_speed() > 0:
		play_animation("fall")
		next_attack_stage()
	
	elif attack_stage == 6 and character.is_on_floor():
		play_animation("land")
		land.play()
		next_attack_stage()
	
	elif attack_stage == 7 and has_finished_last_animation():
		EndAbility()

func deactivate_contact_damage() -> void:
	if executing:
		damage_on_touch.deactivate()

func activate_contact_damage() -> void:
	damage_on_touch.activate()

func activate_invulnerability() -> void:
	character.add_invulnerability("burrow")
	damage.can_get_hit = false

func deactivate_invulnerability() -> void:
	character.remove_invulnerability("burrow")
	damage.can_get_hit = true


func _Interrupt() -> void:
	deactivate_invulnerability()
	activate_contact_damage()
	burrow.emitting = false
	burrow_2.emitting = false
