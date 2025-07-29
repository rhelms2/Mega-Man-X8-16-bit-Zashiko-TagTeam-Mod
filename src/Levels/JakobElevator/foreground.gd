extends ParallaxLayer

onready var tween: TweenController = TweenController.new(self, false)
onready var mid_sky: ParallaxLayer = $"../../Scenery/parallaxBackground/mid_sky"


func _on_mid_sky_visibility_changed() -> void :
	if mid_sky.visible:
		tween.reset()
		tween.attribute("modulate:a", 1, 1.0)
	else:
		tween.reset()
		tween.attribute("modulate:a", 0, 1.0)


func _on_SecretPortal_teleport_start() -> void :
	visible = false
