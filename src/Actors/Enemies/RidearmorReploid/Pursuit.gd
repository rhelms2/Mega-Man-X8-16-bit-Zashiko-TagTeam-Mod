extends AttackAbility

const pursuit_timeout := 1.0
var escape_timer := 0.0

export var nearby_distance : Vector2
onready var wallcheck: RayCast2D = $PunchHitbox/area2D/collisionShape2D/wallcheck
signal grounded
signal walled
signal player_nearby

func _Update(delta) -> void:
	process_gravity(delta)

	if is_player_far_away():
		escape_timer += delta
		if escape_timer > pursuit_timeout:
			EndAbility()
			return
	else:
		escape_timer = 0

	if has_reached_player():
		emit_signal("player_nearby")
	if character.is_on_floor():
		emit_signal("grounded")
		if wallcheck.is_colliding():
			emit_signal("walled")

func _Interrupt() -> void:
	play_animation("recover")
	force_movement(0)

func has_reached_player() -> bool:
	return is_player_nearby_horizontally(nearby_distance.x) \
	   and is_player_nearby_vertically(nearby_distance.y)

func is_player_far_away() -> bool:
	return not is_player_nearby_horizontally(300.0) \
		   or not is_player_nearby_vertically(100.0)
