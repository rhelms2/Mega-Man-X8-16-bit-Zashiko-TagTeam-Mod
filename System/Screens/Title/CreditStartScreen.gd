extends Node2D

onready var fade: Sprite = $fade
onready var tween: TweenController = TweenController.new(self, false)
onready var inspired: Label = $inspired

var able_to_exit: bool = false
var exiting: bool = false
var is_ended: bool = false

func _ready() -> void :
	fade.modulate = Color.black
	Tools.timer(0.5, "fadein", self)
	Tools.timer(5.0, "fadeout", self)
	Tools.timer(1.0, "set_able_to_exit", self)






func set_able_to_exit() -> void :
	able_to_exit = true

func _input(event: InputEvent) -> void :
	if not able_to_exit:
		return
	if event.is_action_pressed("pause"):
		fadeout()

func fadein() -> void :
	if not exiting:
		inspired.modulate = Color.darkblue
		tween.attribute("modulate:a", 0.0, 0.5, fade)
		tween.add_attribute("modulate", Color.white, 0.5, inspired)

func fadeout() -> void :
	if not exiting:
		exiting = true
		tween.reset()
		tween.attribute("modulate", Color.darkblue, 0.5, inspired)
		tween.add_attribute("modulate:a", 1.0, 0.5, fade)
		tween.add_wait(0.5)
		tween.add_callback("next_screen")

func next_screen() -> void :
	is_ended = true
	
	var _dv = get_tree().change_scene("res://src/Title/IntroCapcom.tscn")
