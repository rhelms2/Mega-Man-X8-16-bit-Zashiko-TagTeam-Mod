extends TractorAttackIdle

onready var ray: RayCast2D = $"../animatedSprite/ray"
onready var line: Line2D = $"../animatedSprite/line"
onready var collider: Area2D = $"../area2D"
onready var collision: AnimatedSprite = $"../animatedSprite/collision"

var hit_position: float = 0.0


func _Setup() -> void :
	pass

func _Update(_delta: float) -> void :
	if ray.is_colliding():
		hit_position = global_position.x - ray.get_collision_point().x
		line.points[1].x = abs(hit_position)
		collider.scale.x = -hit_position
		collision.position.x = abs(hit_position)
	else:
		hit_position = global_position.x + 400
		line.points[1].x = abs(hit_position)
		collider.scale.x = hit_position
		collision.position.x = abs(hit_position)
		

func check_for_event_errors() -> void:
	pass #no need for event
