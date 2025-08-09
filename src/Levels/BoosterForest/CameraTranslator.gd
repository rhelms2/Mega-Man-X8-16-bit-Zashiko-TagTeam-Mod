extends Node

onready var camera: Camera2D = $"../../../StateCamera"
onready var tween := TweenController.new(self,false)
onready var elevator: StaticBody2D = $".."
onready var warning: AnimatedSprite = $"../../../StateCamera/Ready Warning Text"

func _on_BossElevator_started() -> void:
	Event.emit_signal("boss_door_open")
	GameManager.music_player.start_fade_out()
	GameManager.player.cutscene_deactivate()
	camera.limit_left = 13616 - 64
	tween.attribute("limit_left",13616,1.0,camera)

func _on_BossElevator_at_max() -> void:
	tween.attribute("limit_bottom",elevator.global_position.y - 32,1.0,camera)
	Event.emit_signal("boss_door_closed")
	Tools.timer(1,"show_warning",self)

func show_warning():
	warning.global_position = GameManager.camera.get_camera_screen_center()
	Event.emit_signal("show_warning")
	
