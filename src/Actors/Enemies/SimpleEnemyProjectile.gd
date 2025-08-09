extends GenericProjectile
class_name MissileClaw

export var speed := 160.0
var return_direction : Vector2

func _Setup() -> void:
	creator.get_parent().listen("zero_health",self,"on_death")

func _Update(_delta) -> void:
	if attack_stage == 0:
		set_horizontal_speed(speed * get_direction() * 2)
	elif attack_stage == 1:
		disable_visuals()
		set_horizontal_speed(0)
		set_return_position()
		next_attack_stage()
	elif attack_stage == 2 and timer > 0.5:
		enable_visuals()
		next_attack_stage()
	elif attack_stage == 3:
		return_direction = (creator.global_position - global_position).normalized()
		set_horizontal_speed(speed * 1.25 * return_direction.x)
		set_vertical_speed(speed * 1.25 * return_direction.y )
	
	if attack_stage == -1: # King Crab death
		if timer > 10:
			destroy()

func _OnHit(_target_remaining_HP) -> void:
	pass

func on_death() -> void:
	attack_stage = -1
	set_horizontal_speed(0)
	set_vertical_speed(0)
	animatedSprite.material = creator.get_parent().animatedSprite.material

func _OnScreenExit() -> void:
	Log("Exited Screen")
	next_attack_stage()

func handle_off_screen(_d) -> void:
	pass

func disable_visuals():
	Log("Disabling Visuals")
	$animatedSprite.visible = false

func set_return_position() -> void:
	if GameManager.get_player_position().x > creator.global_position.x:
		global_position.x = GameManager.camera.get_camera_screen_center().x + 112 + 128
		global_position.y = GameManager.get_player_position().y
	else:
		return_direction = (GameManager.get_player_position() - global_position).normalized()
		global_position.y = GameManager.get_player_position().y + 32 * return_direction.y
		
	
