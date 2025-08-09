extends ChargedBuster

export  var continue_shot: PackedScene = preload("res://X_mod/UltimateX/Player/Projectiles/Ultimate_Continue.tscn")

onready var sprite: AnimatedSprite = $animatedSprite
onready var particles: Particles2D = $particles2D
onready var collision_shape: CollisionShape2D = $collisionShape2D
onready var ray: RayCast2D = $rayCast2D


func _physics_process(_delta: float) -> void :
	pass

func references_setup(direction) -> void :
	set_direction(direction)
	animatedSprite.scale.x = direction
	$particles2D.scale.x = direction
	update_facing_direction()
	$animatedSprite.set_frame(int(rand_range(0, 8)))
	original_pitch = audio.pitch_scale

func process_hittime(_delta: float) -> void :
	pass

func hit(target) -> void :
	target.damage(damage, self)
	spawn_damage_ball(target, true)

func spawn_damage_ball(target, _add_target):
	var damage_ball = continue_shot.instance()
	var hit_position = collision_shape.global_position + ((target.global_position - collision_shape.global_position) / 2)
	


	
	get_tree().current_scene.get_node("Objects").call_deferred("add_child", damage_ball, true)
	damage_ball.set_global_position(hit_position)
	damage_ball.call_deferred("initialize", get_facing_direction())





func leave(_target) -> void :
	pass

func deflect(_body) -> void :
	spawn_damage_ball(_body, false)

func launch_setup(direction: int, _launcher_velocity: float = 0.0) -> void :
	set_horizontal_speed(horizontal_velocity * direction)

func disable_damage() -> void :
	pass

func go_up(speed) -> void :
	set_vertical_speed( - speed / 2)
func go_down(speed) -> void :
	set_vertical_speed(speed / 2)
func go_right(speed) -> void :
	set_horizontal_speed(speed / 2)
func go_left(speed) -> void :
	set_horizontal_speed( - speed / 2)

func update_facing_direction() -> void :
	if animatedSprite.visible:
		if direction.x < 0:
			facing_right = false;
		elif direction.x > 0:
			facing_right = true;
		if get_vertical_speed() < 0 and get_horizontal_speed() > 0:
			rotation_degrees = - 45.0
			particles.rotation_degrees = - 45.0
		elif get_vertical_speed() < 0 and get_horizontal_speed() < 0:
			rotation_degrees = - 135.0
			particles.rotation_degrees = - 135.0
		elif get_vertical_speed() > 0 and get_horizontal_speed() > 0:
			rotation_degrees = 45.0
			particles.rotation_degrees = 45.0
		elif get_vertical_speed() > 0 and get_horizontal_speed() < 0:
			rotation_degrees = 135.0
			particles.rotation_degrees = 135.0
	pass
