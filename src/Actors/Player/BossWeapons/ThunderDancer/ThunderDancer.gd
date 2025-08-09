extends SimplePlayerProjectile

export  var collision_projectile: PackedScene
export  var lines: Array
var target: Node2D
var buster: Node2D
onready var tracker: Area2D = $tracker
onready var line: Line2D = $line


const duration: = 0.25


func _Setup() -> void :
	if tracker:
		tracker.scale.x = get_facing_direction()
		line.texture = lines[randi() %lines.size()]
		if GameManager.is_player_in_scene():
			buster = GameManager.player.get_node("Shot Position")

func _Update(_delta: float) -> void :
	if timer > 0.017 and not ending:
		target = tracker.get_closest_target()
		if target:
			line.visible = true
			set_target_position_to_lineend()
			fade_line()
			if "Lamp" in target.name:
				target.energize()
		ending = true
		animatedSprite.frame = 0
	if ending and timer > duration:
		destroy()

func _OnHit(_target_remaining_HP) -> void :
	pass
	
func set_target_position_to_lineend() -> void :
	if target:
		var lineend_pos = to_local(get_exact_point_of_intersection(target)) + Vector2(rand_range( - 2, 2), rand_range( - 2, 2))
		line.points[1] = lineend_pos

		instantiate(collision_projectile, lineend_pos)


func instantiate(scene: PackedScene, pos: Vector2) -> Node2D:
	var instance = scene.instance()
	add_child(instance, true)
	instance.set_creator(creator)
	instance.call_deferred("initialize", creator.get_facing_direction())
	instance.set_position(pos)
	return instance


func set_buster_position_to_linestart() -> void :
	if GameManager.is_player_in_scene():
		line.points[0] = to_local(GameManager.get_player_position() + buster.position * GameManager.get_player_facing_direction())
	
func fade_line() -> void :
	line.modulate = Color(2, 2, 2, 3.5)
	var t = create_tween()
	t.tween_property(line, "modulate", Color(0, 0.75, 0.75, 0.5), duration / 2)
	t.tween_property(line, "modulate", Color(0, 0, 0, 0), duration / 2)

func get_exact_point_of_intersection(_target) -> Vector2:
	if _target is Enemy:
		var r = get_limits(_target.get_collider_area())
		if r:
			var intersection: = Vector2.ZERO
			intersection.x = clamp(global_position.x, r.position.x - r.size.x, r.position.x + r.size.x)
			intersection.y = clamp(global_position.y, r.position.y - r.size.y, r.position.y + r.size.y)
			return intersection
	return _target.global_position

func get_limits(collider):
	if not collider or not collider is CollisionShape2D:
		return false

	var rect: Rect2 = Rect2(collider.global_position, collider.shape.extents)

	return rect
