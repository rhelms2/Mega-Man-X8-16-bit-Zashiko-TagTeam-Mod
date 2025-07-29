extends BossWeaponAxl

onready var ray: RayCast2D = $"animatedSprite/ray"
onready var line: Line2D = $"animatedSprite/line"
onready var collision: AnimatedSprite = $"animatedSprite/collision"

onready var collision_shape: CollisionShape2D = $collisionShape2D

var timer: float = 0.0

var max_length: float = 500.0
var speed: float = 10000.0
var current_length: float = 0.0

func _ready() -> void :
	._ready()

func _physics_process(delta: float) -> void :
	timer += delta
	if timer > 0.5:
		destroy()
		
	if current_length < max_length:
		var increment = speed * delta
		current_length += increment
		var space_state = get_world_2d().direct_space_state
		var from_pos = global_position
		var to_pos = global_position + Vector2(current_length, 0).rotated(global_rotation)
		var result = space_state.intersect_ray(from_pos, to_pos, [self], 1)
		if result:
			var hit_pos = result.position
			current_length = (hit_pos - global_position).length()
			update_laser_length(current_length)
			return
		else:
			update_laser_length(current_length)
	else:
		update_laser_length(max_length)

func update_laser_length(length):
	var rect_shape = collision_shape.shape as RectangleShape2D
	rect_shape.extents.x = length / 2
	collision_shape.position.x = length / 2
	animatedSprite.position.x = length / 2
	var tex_width = animatedSprite.frames.get_frame(animatedSprite.animation, 0).get_size().x
	animatedSprite.scale.x = length / tex_width

func deactivate() -> void :
	active = false
	call_deferred("disable_damage")
	remove_from_group("Player Projectile")

func hit(target) -> void :
	target.damage(damage, self)

func leave(_target) -> void :
	pass

func deflect(_body) -> void :
	pass

func launch_setup(direction, _launcher_velocity: float = 0.0) -> void :
	if get_facing_direction() > 0:
		get_node("animatedSprite").rotation = deg2rad(0)
	else:
		get_node("animatedSprite").rotation = deg2rad(180)
	animatedSprite.scale.x = get_facing_direction()
	animatedSprite.scale.y = get_facing_direction()
	set_horizontal_speed(horizontal_velocity)
	set_vertical_speed(vertical_velocity)
	set_rotation(Vector2(get_horizontal_speed(), get_vertical_speed()).angle())
	set_horizontal_speed(0)
	set_vertical_speed(0)
	current_length = 0
	update_laser_length(current_length)
