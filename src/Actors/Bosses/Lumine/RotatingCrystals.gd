extends Node2D
onready var tween := TweenController.new(self,false)
onready var tween_brightness := TweenController.new(self,false)
var crystals : Array

func _ready() -> void:
	hide()
	start_crystals()
	contract_crystals()
	hide()
	
func start_crystals() -> void:
	var i := 1
	for crystal in get_children():
		if crystal.has_method("circle_around"):
			crystal.circle_around()
			crystal.tween.custom_step(i*0.25)
			i+=1
			crystals.append(crystal)

func hide() -> void:
	for crystal in crystals:
		crystal.make_invisible()

func speed_up_crystals() -> void:
	stop_circle_around()
	for crystal in crystals:
		crystal.speed_up()
		
func contract_crystals() -> void:
	for crystal in crystals:
		crystal.contract()

func expand_crystals() -> void:
	circle_around()
	for crystal in crystals:
		crystal.speed_up(1.0)
		crystal.expand()

func speed_up_test(crystal) -> void:
	crystal.tween.get_last().set_speed_scale(2.0)

func circle_around() -> void:
	tween.create()
	tween.set_loops()
	tween.set_ease(Tween.EASE_OUT,Tween.TRANS_SINE)
	tween.add_attribute("rotation_degrees", -40, 1.5)
	tween.set_ease(Tween.EASE_IN_OUT,Tween.TRANS_SINE)
	tween.add_attribute("rotation_degrees", 40, 3.0)
	tween.set_ease(Tween.EASE_IN,Tween.TRANS_SINE)
	tween.add_attribute("rotation_degrees", 0.0, 1.5)

func stop_circle_around() -> void:
	tween.reset()
	tween.attribute("rotation_degrees", 0.0, 1.0)


func _on_Lumine_zero_health() -> void:
	contract_crystals()
