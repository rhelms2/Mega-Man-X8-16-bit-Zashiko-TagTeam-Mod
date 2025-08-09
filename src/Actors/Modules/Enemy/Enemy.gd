extends AbilityUser
class_name Enemy

export  var spawn_at_start: bool = false
export  var spawn_direction: int = - 1
export  var things_to_hide_on_death: Array
export  var damage_to_enemies: float = 1
export  var damage_to_bosses: float = 1
export  var damage_to_weakness: float = 1

onready var area2D: Area2D = get_node("area2D")
onready var damage: = get_node("Damage")

var shield
var area_collider: CollisionShape2D

signal shield_hit
signal guard_break
signal external_event
signal got_hit
signal combo_hit(weapon)
signal crushed
signal damage_target
signal spawned_child(child, should_despawn)


func _ready() -> void :
	listen("zero_health", self, "_on_zero_health_hide_things")
	set_collision_bit()
	Tools.timer_p(0.1, "spawner_set_direction", self, spawn_direction)

func set_collision_bit() -> void :
	set_collision_layer_bit(3, true)
	
func set_direction_on_ready() -> void :
	set_direction( - 1)
	update_facing_direction()

func get_pressed_axis() -> int:
	return 0

func _process(_delta: float) -> void :
	update_facing_direction()

func crush() -> void :
	current_health = 0
	emit_signal("crushed")

func process_zero_health() -> void :
	if not has_health():
		if not emitted_zero_health:
			emit_zero_health_signal()

func _on_zero_health_hide_things() -> void :
	for nodepath in things_to_hide_on_death:
		get_node(nodepath).visible = false

func is_colliding_with_wall(wallcheck_distance: = 8, vertical_correction: = 8) -> int:
	if raycast(Vector2(global_position.x + wallcheck_distance, global_position.y + vertical_correction)):
		return 1
	elif raycast(Vector2(global_position.x - wallcheck_distance, global_position.y + vertical_correction)):
		return - 1
	return 0

func raycast(target_position: Vector2) -> Dictionary:
	var space_state = get_world_2d().direct_space_state
	return space_state.intersect_ray(global_position, target_position, [self], collision_mask)

func interrupt_all_moves() -> void :
	for move in executing_moves:
		move.EndAbility()

func has_shield() -> bool:
	if shield != null:
		return shield.active
	else:
		return false

func get_shield() -> Node2D:
	return shield

func direct_hit(value) -> void :
	damage.direct_hit(value)

func on_external_event() -> void :
	emit_signal("external_event")

func got_combo_hit(inflicter) -> void :
	emit_signal("combo_hit", inflicter)

func emit_spawned_child(spawn, should_despawn: bool = true) -> void :
	emit_signal("spawned_child", spawn, should_despawn)

func get_collider_area() -> CollisionShape2D:
	if not area_collider:
		area_collider = get_node_or_null("collisionShape2D")
	return area_collider

func get_visibility_notifier() -> VisibilityNotifier2D:
	var v = get_node_or_null("visibilityNotifier2D")
	return v

func _on_GravityPassage_opened() -> void :
	current_health = 0
