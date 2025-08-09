extends ParallaxLayer

onready var sigmapalace_map: Node2D = $"../../sigmapalace_map"
onready var hole_fillers: CollisionShape2D = $"../../hole_blocker/collisionShape2D"
onready var final_clouds: Node2D = $"../../FinalClouds"
onready var foreground: ParallaxLayer = $"../../../parallaxBackground2/foreground"
onready var final_platform: Node2D = $"../../final_platform"

onready var tween: = TweenController.new(self, false)

func _ready() -> void :
	Event.connect("lumine_went_seraph", self, "activate")
	Event.connect("lumine_desperation", self, "start_dark_mode")

func activate():
	visible = true
	foreground.visible = false
	final_clouds.visible = true
	tween.attribute("modulate:a", 1, 1, final_clouds)
	sigmapalace_map.visible = false
	hole_fillers.disabled = true
	final_platform.visible = true

func start_dark_mode():
	tween.attribute("modulate", Color(1.5, 1.5, 1.5, 1), 0.25)
	tween.add_attribute("modulate", Color(0.1, 0.1, 0.7, 1), 1.0)
	tween.attribute("modulate", Color(0.1, 0.1, 0.9, 1), 1.75, final_clouds)
	tween.attribute("modulate", Color(0.5, 0.5, 0.9, 1), 1.75, final_platform)
