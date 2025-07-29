extends AnimatedSprite
onready var upper_half: AnimatedSprite = $"../animatedSprite"


func _physics_process(_delta: float) -> void :
	if upper_half.animation == "rest":
		play_once("closed")
	elif upper_half.animation == "alert":
		play_once("open")
	elif upper_half.animation == "pump_start" or upper_half.animation == "pump":
		play_once("roll")
	elif upper_half.animation == "idle":
		play_once("land")

func play_once(anim: String) -> void :
	if animation != anim:
		play(anim)
