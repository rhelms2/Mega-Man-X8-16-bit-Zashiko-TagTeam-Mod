extends NewAbility

var jump_speed := 300
var horz_speed := 100
var bounce_direction := -1
var max_bounces := 4
var current_bounce := 1
var reset_cooldown:= 0.16
var reset_timer:= 0.2

onready var bounce: AudioStreamPlayer2D = $bounce
onready var physics = Physics.new(get_parent())
onready var stage = AbilityStage.new(self)

signal bounce

func _Setup() -> void:
	reset_bounce()
	
func reset_bounce() -> void:
	if reset_timer > reset_cooldown:
		current_bounce = 1
		bounce_vertically()
		physics.set_horizontal_speed_toward_direction(horz_speed,bounce_direction)
		timer = 0
		bounce.play_rp(0.05,1.25)
		reset_timer = 0
		emit_signal("bounce")
	
func _Update(delta) -> void:
	physics.process_gravity(delta)
	reset_timer += delta
	if timer > 0.1:
		if physics.is_on_floor():
			if not has_over_bounced():
				bounce_vertically()
				decay_horizontally()
				timer = 0
			else:
				EndAbility()
		elif physics.is_on_wall():
			bounce_horizontally()
			timer = 0
				#stage.next()

func has_over_bounced() -> bool:
	return current_bounce >= max_bounces

func bounce_vertically() -> void:
	physics.set_vertical_speed(-jump_speed/current_bounce)
	current_bounce += 1
	bounce.play_rp(0.05,1.25)

func bounce_horizontally() -> void:
	bounce_direction = -bounce_direction
	physics.set_horizontal_speed_toward_direction(horz_speed,bounce_direction)
	bounce.play_rp(0.05,1.25)
	
func decay_horizontally() -> void:
	physics.set_horizontal_speed(physics.get_horizontal_speed()/current_bounce)

func _Interrupt() -> void:
	physics.set_horizontal_speed(0)
	bounce.play_rp(0.05,1.25)
	

func _EndCondition() -> bool:
	return timer > 1 and physics.is_on_floor()

func _on_guard_broken(projectile) -> void:
	set_bounce_direction(projectile)
	execute_or_reset_bounce()

func _on_TriloArmor_spawned(projectile) -> void:
	set_bounce_direction(projectile)
	execute_or_reset_bounce()

func set_bounce_direction(projectile) -> void:
	if projectile.global_position.x > character.global_position.x:
		bounce_direction = -1
	else:
		bounce_direction = 1

func _on_player_detected() -> void:
	if is_executing():
		if GameManager.get_player_position().y > global_position.y + 8:
			bounce_direction = GameManager.get_player_facing_direction()
			reset_bounce()
			
func _on_dash_detected() -> void:
	bounce_direction = GameManager.get_player_facing_direction()
	execute_or_reset_bounce()

func execute_or_reset_bounce() -> void:
	if not is_executing():
		_on_signal()
	else:
		reset_bounce()

func _on_jump_detected() -> void:
	if is_executing():
		reset_bounce()


