extends Node2D
onready var collider: CollisionShape2D = $staticBody2D / collisionShape2D
onready var tween: = TweenController.new(self, false)

func _ready() -> void :
	deactivate()
	Event.connect("gateway_boss_spawned", self, "on_spawn")
	Event.connect("gateway_boss_defeated", self, "on_defeat")
	
func on_spawn(boss_name):
	if boss_name == "sunflower":
		activate()
		
func on_defeat(boss_name):
	if boss_name == "sunflower":
		deactivate()

func activate() -> void :
	visible = true
	collider.set_deferred("disabled", false)
	tween.create()
	tween.set_loops()
	tween.add_attribute("modulate:a", 0.4, 0.5)
	tween.add_attribute("modulate:a", 0.1, 0.5)

func deactivate() -> void :
	visible = false
	collider.set_deferred("disabled", true)
	tween.reset()
