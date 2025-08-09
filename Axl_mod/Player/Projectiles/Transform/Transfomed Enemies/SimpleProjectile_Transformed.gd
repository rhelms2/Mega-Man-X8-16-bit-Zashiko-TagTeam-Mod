extends GenericProjectile
class_name SimpleProjectileTransformed
onready var hitparticle: Sprite = $"Hit Particle"

export  var speed: = 160.0
var emitted: = false

func _Setup():
	set_horizontal_speed(speed * get_direction())
	
func _OnHit(_target_remaining_HP) -> void :
	if not emitted:
		disable_visuals()
		deactivate()
		hitparticle.emit()
		emitted = true
