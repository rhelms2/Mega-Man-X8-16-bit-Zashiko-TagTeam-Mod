extends SimpleProjectile
class_name WaspProjectile

export var direction : Vector2

func _Setup():
	set_horizontal_speed(speed * direction.x)
	set_vertical_speed(speed * direction.y)
