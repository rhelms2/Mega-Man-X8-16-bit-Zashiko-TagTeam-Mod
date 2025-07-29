extends ParallaxBackground


func _on_16_area_entered(area: Area2D) -> void :
	scroll_limit_begin.y = - 1

func _on_4_area_entered(area: Area2D) -> void :
	scroll_limit_begin.y = 0
