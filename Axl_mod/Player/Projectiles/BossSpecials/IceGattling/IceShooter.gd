extends IceShooter

export  var ice_shards: PackedScene = preload("res://src/Actors/Bosses/AvalancheYeti/IceShardProjectile.tscn")
onready var parent: = get_parent()


func deactivate():
	for shard in created_shards:
		if is_instance_valid(shard):
			shard.emit_hit_particle()
			shard.disable_visual_and_mechanics()
	actual_snow.emitting = false
	active = false

func activate():
	if not active:
		active = true
		actual_snow.emitting = true
		adjust_snow_position()
		interval_between_shots = 1.0
		Tools.timer(interval_between_shots, "create_ice", self)

func get_next_pos() -> float:
	if last_pos + 1 > sequence.size() - 1:
		last_pos = - 1
	var pos = last_pos
	last_pos += 1
	return sequence[pos]

func adjust_snow_position() -> void :
	actual_snow.global_position.x = GameManager.camera.global_position.x
	actual_snow.global_position.y = GameManager.camera.global_position.y - 112

func create_ice() -> void :
	if active:
		fire(ice_shards, GameManager.camera.global_position, 1, Vector2(0, 60))
		Tools.timer(interval_between_shots, "create_ice", self)

func fire(projectile, _shot_position, _dir: int = 0, velocity_override: Vector2 = Vector2(0, 0)) -> void :
	var shot = projectile.instance()
	var direction
	if _dir != 0:
		direction = _dir
	else:
		direction = character.get_facing_direction()
	get_tree().current_scene.add_child(shot)
	var random_pos_x = GameManager.camera.global_position.x + (130 * get_next_pos())
	shot.global_position = Vector2(random_pos_x, parent.global_position.y + shot_creation_height)
	shot.z_index = z_index + 6
	if velocity_override.y != 0:
		shot.set_vertical_speed(velocity_override.y)
		
	shot.get_node("area2D").collision_layer = 1 << 2
	shot.get_node("area2D").collision_mask = 0
	shot.get_node("area2D/collisionShape2D").shape.extents = Vector2(20, 20)
	shot.get_node("DamageOnTouch").damage_group = "Enemies"
	shot.name = "IceGattling_Charged"
	shot.collision_layer = 1 << 2
	shot.collision_mask = 0
	shot.get_node("collisionShape2D").shape.extents = Vector2(20, 20)
	shot.remove_from_group("Enemies")
	shot.add_to_group("Player Projectile")
	created_shards.append(shot)

func remove_shard_from_list(shard) -> void :
	if shard in created_shards:
		created_shards.erase(shard)
