extends Node2D

var h_speed := 100.0
var v_speed := 100.0
onready var front_shield: AnimatedSprite = $front_shield
onready var back_shield: AnimatedSprite = $back_shield

signal expired

func _ready() -> void:
	Tools.timer(7.0,"fade",self)

func _physics_process(delta: float) -> void:
	global_position.x += h_speed * delta
	global_position.y += v_speed * delta
	
	process_coliision()
	
func process_coliision(collision_layer := 1):
	if h_speed < 0 and Tools.raycast(self,Vector2(-24,0),null,collision_layer):
		h_speed *= -1
	elif h_speed > 0 and Tools.raycast(self,Vector2(24,0),null,collision_layer):
		h_speed *= -1
	if v_speed < 0 and Tools.raycast(self,Vector2(0,-24),null,collision_layer):
		v_speed *= -1
	elif v_speed > 0 and Tools.raycast(self,Vector2(0,24),null,collision_layer):
		v_speed *= -1


func fade() -> void:
	emit_signal("expired")
	Tools.tween(front_shield,"modulate",Color(0,1,0,0),0.25)
	Tools.tween(back_shield,"modulate",Color(0,1,0,0),0.25)
	Tools.timer(0.3,"queue_free",self)

func _on_inflict_damage() -> void:
	set_physics_process(false)
	h_speed = 0
	v_speed = 0
	front_shield.play("expand")
	back_shield.play("expand")
	Tools.timer(1.0,"queue_free",self)
