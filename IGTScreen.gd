extends Node2D

onready var fade: Sprite = $fade
onready var tween := TweenController.new(self,false)
onready var times_label: Label = $times
onready var names: Label = $names
onready var totaltime: Label = $totaltime

var exiting := false

func get_times():
	times_label.text = ""
	names.text = ""
	totaltime.text = ""
	var misc_time := ""
	var total_time := 0.0
	for key in IGT.times.keys():
		var section_name = key + "\n"
		var section_time = Tools.get_readable_time(IGT.times[key]) + "\n"
		if key == "Misc.":
			misc_time = section_time
		else:
			names.text += section_name
			times_label.text += section_time
		total_time += IGT.times[key]
	
	names.text += "Menus"
	times_label.text += misc_time
	totaltime.text = "Total Play Time: " + Tools.get_full_readable_time(total_time)
	
func _ready() -> void:
	get_times()
	fade.modulate = Color.black
	Tools.timer(0.5,"fadein",self)
	#Tools.timer(10.0,"fadeout",self)

func _input(event: InputEvent) -> void:
	if fadein_complete and event.is_action_pressed("pause"):
		fadeout()

func fadein():
	if not exiting:
		names.modulate = Color.darkblue
		times_label.modulate = Color.darkblue
		totaltime.modulate = Color.black
		tween.attribute("modulate:a",0.0,.5,fade)
		tween.add_attribute("modulate",Color.white,.5,times_label)
		
		tween.attribute("modulate",Color.darkblue,.5,names)
		tween.add_attribute("modulate",Color.white,.5,names)
		
		tween.add_attribute("modulate",Color.darkblue,.5,totaltime)
		tween.add_attribute("modulate",Color.white,.5,totaltime)
		tween.callback("finished_fadein")

var fadein_complete = false
func finished_fadein():
	fadein_complete = true

func fadeout():
	if not exiting:
		exiting = true
		tween.reset()
		tween.attribute("modulate",Color.darkblue,.5,names)
		tween.attribute("modulate",Color.darkblue,.5,times_label)
		tween.add_attribute("modulate:a",1.0,.5,fade)
		tween.add_wait(.5)
		tween.add_callback("next_screen")

func next_screen():
	IGT.reset()
	var _dv = get_tree().change_scene("res://src/Title/IntroAlysson.tscn")
