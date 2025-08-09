extends SimplePlayerProjectile

export  var explosion: PackedScene
const destroyer: = true
onready var tween = TweenController.new(self, false)

func _Setup() -> void :
	var _initial_speed: = 0.0
	if is_instance_valid(creator):
		_initial_speed = creator.get_horizontal_speed()
	var max_speed = 540 * get_facing_direction()
	position.x += 32 * get_facing_direction()
	tween.method("set_horizontal_speed", 0.0, max_speed, 1.75)
	tween.set_ease_out()


func _OnDeflect() -> void :
	explode()

func _OnHit(_remaining_hp) -> void :
	explode()

func _Update(_delta: float) -> void :
	if timer > 0.2:
		if is_on_floor() or is_on_wall() or get_position_delta() == 0:
			explode()
	update_traveled_distance()

var last_position: = Vector2.ZERO
func update_traveled_distance() -> void :
	last_position = global_position
func get_position_delta() -> float:
	return abs(last_position.x - global_position.x)

func explode() -> void :
	instantiate(explosion)
	destroy()
	
func instantiate(scene: PackedScene) -> Node2D:
	var instance = scene.instance()
	get_tree().current_scene.get_node("Objects").call_deferred("add_child", instance, true)
	instance.set_global_position(global_position)
	instance.set_creator(creator)
	instance.call_deferred("initialize", get_facing_direction())
	return instance
