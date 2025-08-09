extends Actor
onready var pursuit: Node2D = $Pursuit


func activate() -> void :
	Tools.timer(1.0, "_on_signal", pursuit)
