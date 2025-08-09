extends Node2D

onready var smoke: AnimatedSprite = $smoke

export var explosion : PackedScene


func _ready() -> void:
	define_random_visuals()

	Tools.timer(0.1,"start",self)
	if randf() > 0.5:
		Tools.timer(0.25,"sequence",self)
	else:
		Tools.timer(0.25,"alternate_sequence",self)
	Tools.timer(3.0,"queue_free",self)
	Event.connect("first_secret2_death",self,"queue_free")


func start():
	smoke.self_modulate.a = 0
	create_tween().tween_property(smoke,"self_modulate:a",1.0,.5)
	smoke.frame = 0
	
func sequence():
	create_explosion(Vector2(0,0))
	var delay = rand_range(0.0,0.5)
	Tools.timer_p(0.25 + delay/2,"create_explosion",self,Vector2(-10,-10))
	Tools.timer_p(0.5 + delay,"create_explosion",self,Vector2(10,10))
	Tools.timer_p(0.75 + delay,"create_explosion",self,Vector2(-20,20))
	Tools.timer_p(1.0 + delay/2,"create_explosion",self,Vector2(20,-20))
	
func alternate_sequence():
	create_explosion(Vector2(-15,20))
	var delay = rand_range(0.15,0.4)
	Tools.timer_p(0.25 + delay/2,"create_explosion",self,Vector2(20,0))
	Tools.timer_p(0.5 + delay,"create_explosion",self,Vector2(5,-15))
	Tools.timer_p(0.75 + delay/2,"create_explosion",self,Vector2(-15,-20))
	Tools.timer_p(1.0 + delay,"create_explosion",self,Vector2(20,20))

func create_explosion(pos : Vector2):
	var instance = explosion.instance()
	call_deferred("add_child",instance)
	instance.position = pos
	instance.rotation_degrees = -rotation_degrees

func define_random_visuals():
	if randf() > 0.5:
		smoke.flip_h = true
	if randf() > 0.5:
		smoke.flip_v = true
	if randf() > 0.5:
		rotation_degrees = 90
	if randf() > 0.5:
		rotation_degrees = -90
