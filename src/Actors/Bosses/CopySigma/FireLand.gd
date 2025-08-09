extends Node2D

onready var tween := TweenController.new(self,false)

onready var fire_1: Particles2D = $fire1
onready var fire_2: Particles2D = $fire2
onready var fire_3: Particles2D = $fire3
onready var fires := [fire_1,fire_2,fire_3]
onready var damage_on_touch: Node2D = $DamageOnTouch
onready var backflames: Sprite = $backflames
onready var o_modulate := backflames.modulate
onready var loop: AudioStreamPlayer2D = $loop
onready var start: AudioStreamPlayer2D = $start

func _ready() -> void:
	Event.listen("copy_sigma_desperation",self,"start_desperation")
	Event.listen("copy_sigma_flash",self,"activate_damage")
	Event.listen("copy_sigma_end_desperation",self,"end")
	Event.connect("enemy_kill",self,"on_boss_death")
	end()

func start_desperation():
	var fadein = o_modulate
	fadein.a = 0.5
	tween.attribute("modulate",fadein,0.2,backflames)

func activate_damage():
	for f in fires:
		f.emitting = true
	start.play_rp()
	loop.play()
	backflames.modulate = Color(2,2,2,1)
	tween.attribute("modulate",o_modulate,0.2,backflames)
	damage_on_touch.activate()

func on_boss_death(enemy_name):
	if enemy_name is String:
		if enemy_name == "boss":
			end()

func end():
	for f in fires:
		f.emitting = false
	loop.stop()
	tween.attribute("modulate:a",0.0,0.25,backflames)
	damage_on_touch.deactivate()
