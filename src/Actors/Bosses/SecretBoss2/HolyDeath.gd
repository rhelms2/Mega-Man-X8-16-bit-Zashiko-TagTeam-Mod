extends Node2D

onready var death_area: Sprite = $death_area
onready var death_cover: Sprite = $death_cover
onready var charge: AudioStreamPlayer2D = $charge
onready var shot: AudioStreamPlayer2D = $shot
onready var kanji: Light2D = $kanji


onready var tween := TweenController.new(self,false)
onready var area_1: Area2D = $"1"
onready var area_2: Area2D = $"2"
onready var area_3: Area2D = $"3"
onready var area_4: Area2D = $"4"
onready var area_5: Area2D = $"5"
onready var area_6: Area2D = $"6"

onready var areas = [area_1,area_2,area_3,area_4,area_5,area_6]
var current_area := 0
var previous_area : Area2D

var targetting_player := false

func _ready() -> void:
	visible = false
	set_radius()

func deactivate():
	queue_free()

func activate():
	visible = true
	if GameManager.camera:
		global_position = GameManager.camera.get_camera_screen_center()
		global_position -= Vector2(398/2,224/2)
	targetting_player = false
	connect_area(areas[get_current_area()])
	Tools.timer(0.5,"start_visuals",self) #1.6

func get_current_area() -> int:
	var c = current_area
	current_area += 1
	if current_area > 5:
		current_area = 0
	return c

func connect_area(area : Area2D):
	if previous_area:
		previous_area.monitoring = false
		previous_area.disconnect("body_entered",self,"on_player_enter")
		previous_area.disconnect("body_exited",self,"on_player_exit")
	
	kanji.texture = area.kanji
	death_area.texture = area.bg
	death_cover.texture = area.bg
	area.connect("body_entered",self,"on_player_enter")
	area.connect("body_exited",self,"on_player_exit")
	area.monitoring = true
	
	previous_area = area

func start_visuals():
	death_area.offset.y = 10
	death_cover.offset.y = 10
	death_area.modulate = Color.darkblue
	death_area.modulate.a = 0.25
	death_cover.modulate.a = 1.0
	charge.play()
	kanji.scale = Vector2(2,2)
	
	tween.create(Tween.EASE_OUT,Tween.TRANS_SINE,true)
	tween.add_attribute("offset:y",-10,2.5,death_area)
	tween.add_attribute("offset:y",-10,2.5,death_cover)
	
	tween.create(Tween.EASE_OUT,Tween.TRANS_SINE)
	tween.add_attribute("scale",Vector2(1,1),2,kanji)
	tween.attribute("modulate",Color.red,2.0,death_area)
	tween.add_wait(.35)
	var i = 0
	while i < 5:
		tween.add_attribute("modulate",Color.white,0.045,death_area)
		tween.add_attribute("modulate",Color.red,0.045,death_area)
		i +=1
	tween.add_attribute("modulate",Color.red,0.045,death_area)
	#tween.attribute("modulate:a",1,2.5,death_area)
	tween.method("set_radius",0.65,0.1,2.30)
	tween.add_wait(.55)
	tween.add_callback("death")
	

func death():
	shot.play()
	Event.emit_signal("screenshake",2)
	death_area.modulate = Color.white
	death_cover.modulate.a = 0.0
	kanji.scale = Vector2(.95,.95)
	tween.create(Tween.EASE_OUT,Tween.TRANS_SINE)
	tween.add_attribute("scale",Vector2(1.05,1.05),.2,kanji)
	tween.attribute("modulate",Color(1,1,0,0),1.1,death_area)
	tween.method("set_radius",0.1,0.8,0.7)
	if targetting_player:
		GameManager.player.damage(42)

func on_player_enter(_body):
	targetting_player = true
	
func on_player_exit(_body):
	targetting_player = false

func set_radius(value := 0.65):
	death_area.material.set_shader_param("radius",value)
	pass
