extends Node2D

onready var tween := TweenController.new(self,false)
onready var rays = get_children()
var damage_colliders : Array
signal finished_rotation

func _ready() -> void:
	for ray in rays:
		damage_colliders.append(ray.get_node("damage"))

func rotate_to(final_rotation, duration := 1.0) -> void:
	tween.create(Tween.EASE_OUT,Tween.TRANS_SINE)
	tween.add_attribute("rotation_degrees",final_rotation,duration)
	tween.add_callback("on_rotation_finish")

func on_rotation_finish() -> void:
	emit_signal("finished_rotation")

func prepare():
	visible = true
	for ray in rays:
		ray.play("ready")

func activate():
	for ray in rays:
		ray.play("fire")
	
	for collider in damage_colliders:
		collider.activate()
