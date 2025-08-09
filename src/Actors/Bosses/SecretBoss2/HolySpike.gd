extends Node2D
onready var animated_sprite: AnimatedSprite = $animatedSprite
onready var remains_particles: Particles2D = $remains_particles
onready var damage: Node2D = $DamageOnTouch
var direction := 1
var count := 63
var active = false
var start_time := 0.4
onready var right_vray: RayCast2D = $vertical_rayr
onready var left_vray: RayCast2D = $vertical_rayl
onready var right_hray: RayCast2D = $horizontal_rayr
onready var left_hray: RayCast2D = $horizontal_rayl
onready var shatter_sfx: AudioStreamPlayer2D = $shatter
onready var start_sfx: AudioStreamPlayer2D = $start_sfx

var expiring := false

func _ready() -> void:
	animated_sprite.play("prepare")
	Tools.timer(0.032,"prepare_next_spike",self)
	Tools.timer(start_time,"start",self)
	Event.connect("first_secret2_death",self,"queue_free")


func prepare_next_spike():
	if not animated_sprite.visible or expiring:
		return
	if count > 0:
		count -= 1
		if direction == 1:
			spawn_next(right_vray,right_hray)
		else:
			spawn_next(left_vray,left_hray)
	right_hray.enabled = false
	left_hray.enabled = false
	right_vray.enabled = false
	left_vray.enabled = false

func spawn_next(vertical_ray :RayCast2D, horizontal_ray : RayCast2D):
	var spawn_pos : Vector2
	var rotate := rotation_degrees
	var colliding := false
	
	if horizontal_ray.is_colliding():
		spawn_pos = horizontal_ray.get_collision_point()
		rotate += 90.0 * -direction
		colliding = true
		
	elif vertical_ray.is_colliding():
		spawn_pos = vertical_ray.get_collision_point()
		colliding = true

	
	if colliding:
		var next_spike = duplicate()
		next_spike.rotation_degrees = rotate
		next_spike.count = count
		next_spike.start_time = start_time + 0.05
		next_spike.direction = direction
		get_parent().call_deferred("add_child",next_spike)
		next_spike.global_position = spawn_pos

func start():
	if not expiring:
		animated_sprite.play("start")
		start_sfx.play_r()
		Tools.timer(0.13,"idle",self)
	
func idle():
	if animated_sprite.visible and not expiring:
		animated_sprite.play("idle")
		activate()
		Tools.timer(2.0,"expire",self)

func expire():
	expiring = true
	if active:
		deactivate()
		animated_sprite.play("expire")
	Tools.timer(0.5,"queue_free",self)
	

func activate():
	active = true
	damage.activate()

func deactivate():
	active = false
	damage.deactivate()
	
func _on_area2D_body_entered(body: Node) -> void:
	if "SqueezeBomb" in body.name:
		deactivate()
		shatter()


func shatter():
	animated_sprite.visible = false
	if animated_sprite.animation != "prepare" and animated_sprite.animation != "expire" :
		shatter_sfx.play_r()
		remains_particles.emitting = true
	rotation_degrees = 0
	Tools.timer(1.25,"queue_free",self)
