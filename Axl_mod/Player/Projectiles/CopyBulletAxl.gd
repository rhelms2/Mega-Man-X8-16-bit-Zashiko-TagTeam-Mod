extends WeaponShot
class_name CopyBullet

const copy_item: PackedScene = preload("res://Axl_mod/Objects/Pickups/AxlCopyItem.tscn")

onready var start_particle = get_node("Start Particle")
onready var Copy_List = [
	"Drone", 
	"MetoolQueatira", 
	"Turret", 
	"FlameThrower"
]

var emitted_start_particle: bool = false
var hit_time: float = 0.0
var timer: float = 0.0
var rotation_speed: int = 15


func rotate_bullet() -> void :
	var rotate_dir = get_facing_direction()
	var _rotate_speed = 5 * rand_range(0, 2)
	animatedSprite.rotation_degrees += rotate_dir * _rotate_speed

func _physics_process(delta: float) -> void :
	if active:
		rotate_bullet()
		if has_hit_scenery():
			on_wall_hit()
			return
	else:
		timer += delta
		if timer > 1:
			destroy()
		return
	process_hittime(delta)
	
func on_wall_hit() -> void :
	emit_hit_particle()
	deactivate()
	disable_damage()
	
func deactivate() -> void :
	active = false
	disable_projectile_visual()
	call_deferred("disable_damage")
	remove_from_group("Player Projectile")

func references_setup(direction) -> void :
	set_direction(direction)
	animatedSprite.scale.x = direction
	update_facing_direction()
	$animatedSprite.set_frame(int(rand_range(0, 2)))
	original_pitch = audio.pitch_scale

func process_hittime(delta: float) -> void :
	if hit_time > 0:
		hit_time += delta
	if hit_time > time_outside_screen / 3:
		disable_particle_visual()

func instance_copy_item(enemy) -> void :
	var item = copy_item.instance()
	get_parent().get_parent().add_child(item)
	item.global_position = Vector2(round(global_position.x), round(global_position.y))
	item.velocity.y = - 200
	item.copiedenemy = enemy.name
	

func hit(target) -> void :
	if active:
		hit_time = 0.01
		countdown_to_destruction = 0.01
		target.damage(damage, self)
		if target.get_parent() is Enemy:
			Event.emit_signal("hit_enemy_with_copy")







		
		emit_hit_particle()
		disable_projectile_visual()
		call_deferred("disable_damage")
		remove_from_group("Player Projectile")
		active = false

func leave(_target) -> void :
	pass

func deflect(_body) -> void :
	.deflect(_body)
	$deflect_particle.emit(facing_direction)

func launch_setup(_direction, _launcher_velocity: float = 0.0) -> void :
	if get_facing_direction() > 0:
		get_node("animatedSprite").rotation = deg2rad(0)
	else:
		get_node("animatedSprite").rotation = deg2rad(180)
	animatedSprite.scale.x = get_facing_direction()
	animatedSprite.scale.y = get_facing_direction()
	set_horizontal_speed(horizontal_velocity)
	set_vertical_speed(vertical_velocity)
	set_rotation(Vector2(get_horizontal_speed(), get_vertical_speed()).angle())
		
func emit_start_particle() -> void :
	if not emitted_start_particle:
		start_particle.global_position = global_position
		start_particle.emit()
		emitted_start_particle = true

func disable_damage() -> void :
	$collisionShape2D.disabled = true
