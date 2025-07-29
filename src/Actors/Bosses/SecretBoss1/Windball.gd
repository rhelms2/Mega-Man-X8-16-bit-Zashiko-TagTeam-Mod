extends Node2D

var duration: = 0.85

var fired := false
export var windshot : PackedScene
onready var tween := TweenController.new(self,false)
onready var particles: Particles2D = $particles2D3
onready var particles2: Particles2D = $particles2D4
onready var punch: AudioStreamPlayer2D = $punch

onready var start: Particles2D = $start

func _ready() -> void:
	start()

func start():
	start.emitting = true
	particles2.emitting = true
	particles.emitting = true
	tween.attribute("modulate", Color(0.75, 0.75, 0.75), 0.25)
	tween.add_attribute("modulate", Color.white, duration)
	tween.add_callback("doubleshot")

func doubleshot():
	if fired:
		return
	punch.play_rp()
	fired = true
	var wind = windshot.instance()
	var wind2 = windshot.instance()
	get_tree().current_scene.call_deferred("add_child", wind)
	wind.global_position = global_position
	wind.set_direction(1)
	get_tree().current_scene.call_deferred("add_child", wind2)
	wind2.global_position = global_position
	wind2.set_direction( - 1)
	wind.rotation_degrees = rotation_degrees
	wind2.rotation_degrees = rotation_degrees
	visible = false
	Tools.timer(1, "queue_free", self)


func _on_area2D_body_entered(_body: Node) -> void:
	tween.reset()
	doubleshot()
	pass # Replace with function body.
