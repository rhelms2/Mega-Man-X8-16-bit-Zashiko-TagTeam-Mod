extends Area2D
onready var sky_limit: ParallaxLayer = $"../Scenery/parallaxBackground/sky_limit"
onready var inner_tower: ParallaxLayer = $"../Scenery/parallaxBackground/inner_tower"
onready var start: ParallaxLayer = $"../Scenery/parallaxBackground/start"
onready var mid_sky: ParallaxLayer = $"../Scenery/parallaxBackground/mid_sky"


func _on_body_entered(_body: Node) -> void :
	mid_sky.visible = false
	start.visible = false
	sky_limit.visible = true
	inner_tower.visible = false
	pass
