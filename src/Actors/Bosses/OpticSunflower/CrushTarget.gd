extends Node2D

var pursuit_speed := 120.0
var h_speed := 0.0
var v_speed := 0.0
onready var animated_sprite: AnimatedSprite = $animatedSprite

signal fire(pos)

func _ready() -> void:
	Tools.tween(animated_sprite,"speed_scale",2,2.0)
	Tools.timer(2.0,"fire",self)

func fire() -> void:
	emit_signal("fire",global_position)
	queue_free()

func _physics_process(delta: float) -> void:
	global_position.x += h_speed * delta
	global_position.y += v_speed * delta
	if is_distant_enough():
		var target_angle = get_angle_to(GameManager.get_player_position())
		var normalized_angle = Vector2(cos(target_angle),sin(target_angle))
		h_speed = (normalized_angle.x * pursuit_speed)
		v_speed = (normalized_angle.y * pursuit_speed)
	else:
		h_speed = (0)
		v_speed = (0)
		
func is_distant_enough() -> bool:
	var distance := global_position.distance_to(GameManager.get_player_position())
	return distance > 8.0
