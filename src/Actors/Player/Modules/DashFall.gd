extends Fall


func _ready() -> void :
	if active:
		character.listen("dry_dash", self, "try_dash")
		
func _Interrupt() -> void :
	pass

func try_dash() -> void :
	if not executing:
		ExecuteOnce()
