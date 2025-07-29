extends BossWeaponAxl
class_name BlastLauncher

const max_bounces: int = 3
const destroyer: bool = true

export  var explosion: PackedScene

var last_speed: Vector2
var bounces: int = 0
var last_bounce: float = 0.0
var ending: bool = false
var timer: float = 0.0
var creator: Node2D


func hit(target) -> void :
	if active:
		active = false
		target.damage(damage, self)
		explode()
		disable_projectile_visual()
		remove_from_group("Player Projectile")

func leave(_target) -> void :
	pass

func deflect(_body) -> void :
	explode()

func launch_setup(_direction, _launcher_velocity: float = 0.0) -> void :
	if get_facing_direction() > 0:
		get_node("animatedSprite").rotation = deg2rad(0)
	else:
		get_node("animatedSprite").rotation = deg2rad(180)
	set_horizontal_speed(horizontal_velocity)
	set_vertical_speed(vertical_velocity)

func disable_damage() -> void :
	$collisionShape2D.set_deferred("disabled",true)

func _physics_process(delta: float) -> void :
	if not ending:
		process_gravity(delta, 700)
		if has_hit_scenery():
			explode()
	set_rotation(Vector2(get_horizontal_speed(), get_vertical_speed()).angle())
	last_speed = Vector2(get_horizontal_speed(), get_vertical_speed())
	if ending:
		destroy()

func explode() -> void :
	set_vertical_speed(0)
	set_horizontal_speed(0)
	instantiate(explosion)
	disable_visuals()
	particle_visual.emitting = false
	ending = true

func instantiate(scene: PackedScene) -> Node2D:
	var instance = scene.instance()
	get_tree().current_scene.get_node("Objects").call_deferred("add_child", instance, true)
	instance.set_global_position(global_position)
	instance.set_creator(creator)
	instance.call_deferred("initialize", get_facing_direction())
	return instance
