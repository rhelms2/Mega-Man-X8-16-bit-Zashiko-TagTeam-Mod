extends Movement
class_name WallSlide

export var start_delay := 0.16
export var block_timer := 0.0

onready var particles = character.get_node("animatedSprite").get_node("WallSlide Particles")

var horizontal_speed = 90
var wallgrab_direction := 0

func _Setup() -> void:
	character.emit_signal("wallslide")
	character.set_direction(- get_pressed_direction())
	wallgrab_direction =  get_pressed_direction()

func _Update(_delta: float) -> void:
	character.set_horizontal_speed(horizontal_speed * wallgrab_direction)
	if delay_has_expired():
		emit_particles(particles,true)
		character.set_vertical_speed(jump_velocity)

func _StartCondition() -> bool:
	if not character.is_on_floor() and not block_timer > 0: 
		if character.is_colliding_with_wall() != 0:
			if character.get_vertical_speed() > 0:
				if get_pressed_direction() == character.is_colliding_with_wall():
					return true
	return false

func _EndCondition() -> bool:
	if character.is_on_floor():
		Log("Floor detected")
		return true
	
	if not character.is_in_reach_for_walljump():
		Log("No wall detected")
		block_timer = 0.01
		return true
	
	if get_pressed_direction() != character.is_in_reach_for_walljump():
		Log("Not pressing towards wall")
		return true

	if get_pressed_direction() == 0:
		Log("Not pressing")
		return true
	
	return false

func _physics_process(delta: float) -> void:
	if block_timer > 0:
		block_timer += delta
		if block_timer > 0.15:
			block_timer = 0

func _Interrupt():
	if character.get_vertical_speed() > 0:
		character.set_vertical_speed(40)
	character.set_horizontal_speed(0)
	emit_particles(particles,false)

func delay_has_expired() -> bool:
	return timer > start_delay
	
func should_execute_on_hold() -> bool:
	return true
