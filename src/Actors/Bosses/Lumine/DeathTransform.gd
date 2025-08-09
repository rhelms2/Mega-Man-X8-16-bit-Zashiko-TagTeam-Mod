extends AnimatedSprite

onready var boss_death: Node2D = $"../BossDeath"
onready var transform_sfx: AudioStreamPlayer2D = $"../transform"

var stage := 0
onready var sprite: AnimatedSprite = $"../animatedSprite"

signal finished

func _on_BossDeath_start_fade() -> void:
	scale.x = sprite.scale.x
	visible = true
	Tools.timer(4,"start",self)

func start():
	playing = true

func open_wings():
	play("wings_open")
	Tools.timer(0.1,"play",transform_sfx)

func _on_animation_finished() -> void:
	if animation == "transform_start":
		play("wings_appear")
		Tools.timer_p(0.35,"play",self,"wings_end")
		Tools.timer(0.75,"open_wings",self)
	elif animation == "wings_open":
		play("transform_end")
	elif animation == "transform_end":
		emit_signal("finished")
		Event.emit_signal("lumine_went_seraph")
