extends GenericProjectile
class_name DirtProjectile

onready var hit_particle: Sprite = $"Hit Particle"
var hit_ground := false
onready var audio : AudioStreamPlayer2D = $audioStreamPlayer2D

export var speed : Vector2

func _Setup() -> void:
	set_horizontal_speed(speed.x * facing_direction)
	set_vertical_speed(speed.y)
	

func _Update(delta) -> void:
	process_gravity(delta)
	
	if is_on_floor() and not hit_ground:
		explode()
	if hit_ground and timer > 1:
		destroy()

func explode() -> void:
	hit_particle.emit()
	disable_visuals()
	deactivate()
	reset_timer()
	audio.play()

func _OnHit(_target_remaining_HP)-> void:
	explode() 
