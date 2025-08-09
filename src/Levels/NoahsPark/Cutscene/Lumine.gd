extends AnimatedSprite

var tween: = TweenController.new(self, false)
onready var initial_color: = modulate
var appeared: = false

func _ready() -> void :
	Event.connect("character_talking", self, "on_talk")
	reset()

func on_talk(character_name):
	if appeared:
		if character_name == "Lumine":
			play("talk")
		else:
			play("idle")

func reset():
	tween.reset()
	modulate = initial_color
	self_modulate.a = 0.0
	position = Vector2(274, 176)

func appear():
	tween.attribute("self_modulate:a", 1.0, 2.0)

func color_to_light():
	tween.attribute("modulate", Color.white, 3.0)
	tween.add_callback("play", self, ["open"])
	appeared = true
