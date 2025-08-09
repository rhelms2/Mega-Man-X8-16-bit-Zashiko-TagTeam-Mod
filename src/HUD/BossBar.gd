extends NinePatchRect

onready var bar: TextureProgress = $textureProgress
onready var tween := TweenController.new(self,false)
onready var tween_near := TweenController.new(self,false)

var fading_out := false
var fading_in := false

func _ready() -> void:
	Event.connect("set_boss_bar",self,"set_boss_bar")
	visible = false

func set_boss_bar(new_bar : Texture):
	texture = new_bar

func blink():
	tween.reset()
	bar.modulate.r = 15.0
	bar.modulate.g = 15.0
	bar.modulate.b = 15.0
	self_modulate.r = 1.5 
	self_modulate.g = 1.5
	self_modulate.b = 1.5
	tween.create()
	tween.add_wait(0.032)
	tween.add_callback("unblink")

func unblink():
	bar.modulate.r = Color.white.r
	bar.modulate.g = Color.white.g
	bar.modulate.b = Color.white.b
	self_modulate.r = Color.white.r
	self_modulate.g = Color.white.g
	self_modulate.b = Color.white.b

func disable():
	set_physics_process(false)

func fade_out():
	if not fading_out:
		fading_out = true
		fading_in = false
		tween_near.reset()
		tween_near.attribute("modulate:a",0.1,0.1)
	
func fade_in():
	if not fading_in:
		fading_in = true
		fading_out = false
		tween_near.reset()
		tween_near.attribute("modulate:a",1.0,0.6)

func _physics_process(_delta: float) -> void:
	if player_is_near_lifebar():
		fade_out()
	else:
		fade_in()

func player_is_near_lifebar() -> bool:
	var screencenter = GameManager.camera.get_camera_screen_center()
	return GameManager.get_player_position().x > screencenter.x +199 - 36 and \
		   GameManager.get_player_position().y < screencenter.y + 10
