extends Node2D

const distance:= 28
const interval:= 0.1
export var damaging_explosion : PackedScene

func _ready() -> void:
	call_deferred("create_central_explosion")
	Tools.timer(interval,"create_middle_explosion",self)
	Tools.timer(interval * 2,"create_outer_explosion",self)
	Tools.timer(2.5,"queue_free",self)

func create_central_explosion()-> void:
	instantiate()

func create_middle_explosion()-> void:
	instantiate(global_position + Vector2(distance,0))
	instantiate(global_position + Vector2(-distance,0))
	instantiate(global_position + Vector2(0,distance))
	instantiate(global_position + Vector2(0,-distance))

func create_outer_explosion()-> void:
	var d = distance * 2
	instantiate(global_position + Vector2(d,0))
	instantiate(global_position + Vector2(-d,0))
	instantiate(global_position + Vector2(0,d))
	instantiate(global_position + Vector2(0,-d))

func instantiate(instance_position := global_position):
	var instance = damaging_explosion.instance()
	get_tree().current_scene.add_child(instance,true)
	instance.set_global_position(instance_position)
