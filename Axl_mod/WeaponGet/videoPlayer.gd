extends VideoPlayer

onready var tween: = TweenController.new(self, false)


func _on_Armor_reset() -> void :
	call_deferred("reset")

func reset() -> void :
	stop()
	modulate.a = 0
	pass

func start() -> void :
	play()
	tween.attribute("modulate:a", 1.0)


func _on_Armor_start() -> void :
	call_deferred("start")
	pass
