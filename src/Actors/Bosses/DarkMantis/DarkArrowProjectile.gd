extends GenericProjectile

onready var hit_particle: Sprite = $"Hit Particle"
var hit_ground := false
const bypass_shield := true
onready var audio : AudioStreamPlayer2D = $audioStreamPlayer2D

signal hit_ground

export var speed : Vector2

func _Setup() -> void:
	set_horizontal_speed(speed.x * facing_direction)
	set_vertical_speed(speed.y)

func deactivate() -> void:
	.deactivate()
	emit_signal("hit_ground")
	modulate = Color(1,1,1,0.35)
	set_horizontal_speed(0)
	set_vertical_speed(0)
	var tween = get_tree().create_tween()
	tween.tween_property(self,"modulate",Color(0,0,1,0),2)
	tween.tween_callback(self,"destroy")

func _Update(delta) -> void:
	process_gravity(delta)
	
	if is_on_floor() or is_on_wall():
		deactivate()
	else:
		set_rotation(Vector2(get_horizontal_speed(),get_vertical_speed()).angle())

func set_direction(new_direction):
	Log("Seting direction: " + str (new_direction) )
	facing_direction = new_direction
	#animatedSprite.scale.x = new_direction

func explode() -> void:
	pass

func _OnHit(_target_remaining_HP)-> void:
	pass
