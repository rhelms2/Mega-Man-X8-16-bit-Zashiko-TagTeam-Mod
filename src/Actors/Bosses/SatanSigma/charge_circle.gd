extends Sprite

onready var tween := TweenController.new(self,false)
var active := false
export var initial_scale := Vector2(4,3)
export var final_color := Color.green
export var interval := 0.21
export var max_flashes := -1
export var total_duration := 0.3

var current_flashes := 0

func _ready() -> void:
	visible = false

func activate():
	if not active:
		active = true
		flash()

func flash():
	if active:
		if max_flashes > 0:
			if current_flashes >= max_flashes:
				current_flashes = 0
				deactivate()
				return
				
		current_flashes += 1
		visible = true
		scale = initial_scale
		modulate = Color.white
		self_modulate.a = 0.0
		tween.attribute("scale",Vector2(.1,.05), total_duration/3*2)
		tween.attribute("modulate",final_color,total_duration/3*2)
		tween.attribute("self_modulate:a",.5,total_duration/3)
		tween.add_attribute("self_modulate:a",0.0,total_duration/3)
		Tools.timer(interval,"flash",self)


func deactivate():
	active = false
	Tools.timer(.4,"hide",self)

func hide():
	visible = false
