extends Enemy

func _ready() -> void:
	var _s = $visibilityNotifier2D.connect("screen_exited",self,"auto_destruct")
	
func auto_destruct() -> void:
	current_health = 0
