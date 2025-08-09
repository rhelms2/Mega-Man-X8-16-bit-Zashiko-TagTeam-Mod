extends AnimatedSprite

export var duration := 1.2
export var warning_duration := 1.75
export var debug_mode := false
var timer := 0.0
onready var alert = $audioStreamPlayer2

func _ready() -> void:
	#GameManager.on_level_start()
	Event.listen("stage_start", self, "skip_ready")

func skip_ready() -> void:
	Tools.timer(0.1,"hur",self)

func hur():
	GameManager.call_deferred("emit_intro_signal")
	
