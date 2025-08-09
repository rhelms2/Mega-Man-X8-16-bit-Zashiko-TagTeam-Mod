extends SimplePlayerProjectile

export  var wall: PackedScene

func _Update(delta: float) -> void :
	._Update(delta)
	set_horizontal_speed(100 * get_facing_direction())
	process_gravity(delta)
	if is_on_floor():
		wall_hit()

func wall_hit() -> void :
	create_wall()
	destroy()

func create_wall() -> void :
	var _d = instantiate_projectile()
	
func instantiate_projectile() -> Node2D:
	var projectile = wall.instance()
	get_parent().call_deferred("add_child", projectile, true)
	projectile.set_global_position(global_position)
	projectile.set_creator(creator)
	projectile.call_deferred("initialize", creator.get_facing_direction())
	return projectile
