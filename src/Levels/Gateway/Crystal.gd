extends Node2D

export  var boss: = "rooster"
export  var color: Color

onready var animation: AnimatedSprite = $animatedSprite
onready var particles: Particles2D = $particles2D
onready var sfx: AudioStreamPlayer2D = $get
onready var light: Sprite = $light
onready var tween: TweenController = TweenController.new(self, false)

var timer: float = 0.0


func _ready() -> void :
	animation.play(boss)
	light.modulate = color

func _physics_process(delta: float) -> void :
	timer += delta * 2
	position.y = sin(timer) * 3

func activate() -> void :
	tween.create()
	tween.set_parallel()
	tween.add_attribute("self_modulate", Color(5, 5, 5, 1), 0.025, animation)
	tween.add_attribute("modulate:a", 0.0, 0.2, animation)
	tween.add_attribute("scale", Vector2(0.1, 14), 0.2, animation)
	tween.add_attribute("self_modulate", Color(5, 5, 5, 1), 0.1, light)
	tween.add_attribute("modulate:a", 0.0, 0.2, light)
	tween.add_attribute("scale", Vector2(4, 4), 0.2, light)
	particles.emitting = false
	sfx.play()
	Tools.timer(2, "reset", self, self, true)
	Event.emit_signal("gateway_crystal_get", boss)
	Event.emit_signal("gateway_segment_cleared", boss)

func reset():
	animation.scale = Vector2.ONE
	particles.emitting = true
	animation.modulate = Color.white
	animation.self_modulate = Color.white
	particles.modulate = Color.white
	light.self_modulate = Color.white
	light.modulate = color
	light.scale = Vector2.ONE
