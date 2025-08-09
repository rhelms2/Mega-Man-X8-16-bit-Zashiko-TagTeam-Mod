extends Accelerate
class_name BikeDash

onready var particles = get_parent().get_node("animatedSprite").get_node("particles2D")

func play_animation_on_initialize() -> void:
	play_animation(animation)

func _ready() -> void:
	if active:
		# warning-ignore:return_value_discarded
		character.get_node("animatedSprite").connect("animation_finished", self, "_on_animatedSprite_animation_finished")

func _StartCondition() -> bool:
	if character.is_on_floor():
		if character.is_colliding_with_wall() != 0:
			if character.is_colliding_with_wall() == character.get_facing_direction():
				return false
		
		if get_pressed_direction() != 0: 
			if character.get_facing_direction() == get_pressed_direction():
				return true
		else:
			return true
	return false

func _Setup():
	emit_particles(particles)
	set_actual_speed(horizontal_velocity * character.get_facing_direction() )
	set_camera_offset(64,1.5)
	#update_bonus_horizontal_only_conveyor()

func _Interrupt():
	emit_particles(particles,false)
	#print('BikeLog: interrupting dash, vspeed= ' + str(character.velocity.y))

func process_gravity(_delta:float, _gravity := default_gravity, _s = "null") -> void:
	#if not character.get_vertical_speed() < 0:
	.process_gravity(_delta)

func process_speed():
	if abs(get_actual_speed()) < horizontal_velocity:
		add_actual_speed(horizontal_velocity * delta * character.get_facing_direction() * 1.5)
	
func _EndCondition() -> bool:
	if not character.is_on_floor():
		return true
	if character.is_colliding_with_wall() != 0:
		if character.is_colliding_with_wall() == character.get_facing_direction():
			return true
	return false
	
func play_sound_on_initialize():
	if sound:
		play_sound(sound, false)

func _on_animatedSprite_animation_finished() -> void:
	if executing:
		if (character.get_animation() == "boost_start"):
			character.play_animation("boost")

func should_execute_on_hold() -> bool:
	return false
