extends ChargedBuster
onready var sprite: AnimatedSprite = $animatedSprite
onready var particles: Particles2D = $particles2D


func go_up(speed) -> void:
	set_vertical_speed(-speed/2)
func go_down(speed) -> void:
	set_vertical_speed(speed/2)
func go_right(speed) -> void:
	set_horizontal_speed(speed/2)
func go_left(speed) -> void:
	set_horizontal_speed(-speed/2)
	
func update_facing_direction() -> void:
	if animatedSprite.visible:
		if direction.x < 0:
			facing_right = false;
		elif direction.x > 0:
			facing_right = true;
		if get_vertical_speed() < 0 and get_horizontal_speed() > 0: #^ ->
			rotation_degrees = -45.0
			particles.rotation_degrees = -45.0
		elif get_vertical_speed() < 0 and get_horizontal_speed() < 0: #^ <-
			rotation_degrees = -135.0
			particles.rotation_degrees = -135.0
		elif get_vertical_speed() > 0 and get_horizontal_speed() > 0: #V ->
			rotation_degrees = 45.0
			particles.rotation_degrees = 45.0
		elif get_vertical_speed() > 0 and get_horizontal_speed() < 0: #V <-
			rotation_degrees = 135.0
			particles.rotation_degrees = 135.0
		
			
	pass
