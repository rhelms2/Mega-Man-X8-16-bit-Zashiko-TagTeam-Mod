extends SimplePlayerProjectile

export  var explosion: PackedScene

var last_speed: Vector2
var bounces: = 0
var last_bounce: = 0.0
const max_bounces: = 3
const destroyer: = true
onready var sound: AudioStreamPlayer2D = $sound
onready var particles_2d: Particles2D = $particles2D

func _Setup() -> void :
	var player_speed: = Vector2.ZERO
	if is_instance_valid(creator):
		player_speed.x = creator.get_horizontal_speed()
		var y_speed = creator.get_vertical_speed() / 3
		if y_speed < 0:
			player_speed.y = y_speed
	var projectile_speed = 200 * get_facing_direction()
	set_horizontal_speed(projectile_speed + player_speed.x / 2)
	set_vertical_speed(player_speed.y)

func set_direction(new_direction):
	Log("Seting direction: " + str(new_direction))
	facing_direction = new_direction

func _Update(delta: float) -> void :
	if not ending:
		if timer > 0.15:
			process_gravity(delta, 700)
		if is_on_floor() or is_on_wall() or is_on_ceiling():
			bounce()
		if bounces >= max_bounces:
			explode()
		
	set_rotation(Vector2(get_horizontal_speed(), get_vertical_speed()).angle())
	last_speed = Vector2(get_horizontal_speed(), get_vertical_speed())
	
	if ending and timer > 0.5:
		destroy()

func bounce() -> void :
	if timer > last_bounce + 0.017:
		last_speed = last_speed.bounce(get_slide_collision(0).normal)
		set_vertical_speed(last_speed.y / 1.5)
		set_horizontal_speed(last_speed.x / 2)
		bounces += 1
		last_bounce = timer
		if bounces < max_bounces:
			sound.play_rp()
	

func _OnDeflect() -> void :
	explode()

func _OnHit(_remaining_hp) -> void :
	explode()

func explode() -> void :
	set_vertical_speed(0)
	set_horizontal_speed(0)
	instantiate(explosion)
	disable_visuals()
	particles_2d.emitting = false
	ending = true
	
func instantiate(scene: PackedScene) -> Node2D:
	var instance = scene.instance()
	get_tree().current_scene.get_node("Objects").call_deferred("add_child", instance, true)
	instance.set_global_position(global_position)
	instance.set_creator(creator)
	instance.call_deferred("initialize", get_facing_direction())
	return instance
