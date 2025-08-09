extends VisibilityNotifier2D

var active := false
var first_frame := true
signal ready_for_respawn

func _ready() -> void:
	Tools.timer(0.02,"ignore_first_frame",self)

func _on_screen_entered() -> void:
	if active and not first_frame:
		emit_signal("ready_for_respawn")
		queue_free()

func activate():
	active = true

func ignore_first_frame():
	first_frame = false
	
