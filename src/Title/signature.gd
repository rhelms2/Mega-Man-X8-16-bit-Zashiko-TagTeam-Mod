extends Sprite

export  var color1: Color
export  var color2: Color

onready var tween: TweenController = TweenController.new(self, false)
onready var signature: Label = $"../signature2"
onready var by: Label = $"../by"
onready var fade: Sprite = $"../fade"
onready var jingle: AudioStreamPlayer = $"../jingle"

var able_to_exit: bool = false
var exiting: bool = false

func _ready() -> void :
	jingle.play()
	modulate = Color.black
	by.modulate = Color.black
	signature.modulate = Color.black
	activate()

func activate() -> void :
	modulate = Color.black
	by.modulate = Color.black
	signature.modulate = Color.black
	enter_by()
	Tools.timer(1.0, "appear", self)
	Tools.timer(2.5, "set_able_to_exit", self)
	Tools.timer(6, "fade", self)
	Tools.timer(6, "fade_by", self)

func enter_by() -> void :
	tween.attribute("modulate", Color.white, 2.0, by)

func appear() -> void :
	tween.attribute("modulate", color1, 1.3)
	tween.add_attribute("modulate", color2, 0.6)
	tween.add_attribute("modulate", Color.white, 0.9)
	tween.attribute("modulate", Color.black, 0.5, signature)
	tween.add_attribute("modulate", Color.white, 3, signature)

func set_able_to_exit() -> void :
	able_to_exit = true

func fade_by() -> void :
	tween.attribute("modulate", Color.black, 2.0, by)

func fade() -> void :
	tween.attribute("modulate", color2, 0.7)
	tween.add_attribute("modulate", color1, 0.7)
	tween.add_callback("fadeout")
	tween.attribute("modulate", Color.black, 2.0, signature)

func _input(event: InputEvent) -> void :
	if not able_to_exit:
		return
	if event.is_action_pressed("fire") or event.is_action_pressed("pause"):
		fadeout()

func fadeout() -> void :
	if not exiting:
		exiting = true
		tween.reset()
		tween.attribute("volume_db", - 50, 1.0, jingle)
		tween.attribute("modulate", Color.black, 1.0, fade)
		tween.add_wait(1)
		tween.add_callback("next_screen")

func next_screen() -> void :
	
	var _dv = get_tree().change_scene("res://System/Screens/Title/CreditStartScreen.tscn")
