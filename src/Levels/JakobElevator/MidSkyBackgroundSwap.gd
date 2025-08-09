extends Area2D
onready var sky_limit: ParallaxLayer = $"../Scenery/parallaxBackground/sky_limit"
onready var inner_tower: ParallaxLayer = $"../Scenery/parallaxBackground/inner_tower"
onready var start: ParallaxLayer = $"../Scenery/parallaxBackground/start"
onready var mid_sky: ParallaxLayer = $"../Scenery/parallaxBackground/mid_sky"
onready var foreground: ParallaxLayer = $"../parallaxBackground2/foreground"
onready var tween: = TweenController.new(self, false)

func _on_body_entered(_body: Node) -> void :
	mid_sky.visible = true
	start.visible = false
	sky_limit.visible = false
	inner_tower.visible = false
	pass


func _on_StartPortal_teleported() -> void :
	mid_sky.visible = true
	start.visible = false
	sky_limit.visible = false
	inner_tower.visible = false
