extends Node2D

onready var tween: = TweenController.new(self, false)
onready var polygon_2d: Polygon2D = $polygon2D
onready var fire_loop: AudioStreamPlayer2D = $fire_loop

export  var ice_platform: PackedScene
const duration: = 22
const final_height: = 145.0
var elapsed_time: = 0.0

func _ready() -> void :
	Event.connect("teleport_rooster", self, "activate_in_1")
	Event.connect("gateway_crystal_get", self, "on_crystal_get")

func on_crystal_get(boss_crystal_name):
	if boss_crystal_name == "rooster":
		Tools.timer(1, "queue_free", self)

func activate_in_1():
	Tools.timer(0.1, "activate", self)
	fire_loop.play()
	
func activate():
	Event.emit_signal("screenshake", 2.0)
	start_movement()

func restart():
	elapsed_time += tween.get_last().get_total_elapsed_time()
	tween.reset()
	start_movement(duration - elapsed_time)
	modulate = Color(2, 2, 2, 1)
	tween.add_attribute("modulate", Color.white, 0.1)

func start_movement(_duration: = duration):
	tween.create(Tween.EASE_OUT_IN, Tween.TRANS_LINEAR)
	tween.set_parallel()
	tween.add_attribute("position:y", final_height, _duration)
	tween.add_attribute("scale:y", final_height, _duration, polygon_2d)
	

func _on_icehit(projectile) -> void :
	var platform = ice_platform.instance()
	var correct_position = projectile.global_position
	call_deferred("add_child", platform)
	platform.set_deferred("global_position", correct_position)
	restart()
