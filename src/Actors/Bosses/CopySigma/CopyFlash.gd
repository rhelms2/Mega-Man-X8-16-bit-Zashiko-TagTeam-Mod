extends AttackAbility
onready var charge: AudioStreamPlayer2D = $charge
onready var beam: AudioStreamPlayer2D = $beam
onready var flash: Sprite = $flash
onready var tween := TweenController.new(self,false)
onready var flash_area: Node2D = $flash_area


func _Setup() -> void:
	turn_and_face_player()
	flash.scale.x = 16
	

func _Update(_delta) -> void:
	process_gravity(_delta)

	if attack_stage == 0:
		play_animation("throw_prepare")
		charge.play()
		tween.method("set_flash_radius",0.6,0.4,1.15)
		tween.attribute("modulate", Color(1,0.5,0.75,.45), .8, flash)
		next_attack_stage()
	
	elif attack_stage == 1 and has_finished_last_animation():
		play_animation("throw_prepare_loop")
		next_attack_stage()
		
	elif attack_stage == 2 and timer > 0.6:
		play_animation("throw_start")
		Tools.timer(0.1,"play",beam)
		next_attack_stage()
	
	elif attack_stage == 3 and has_finished_last_animation():
		play_animation("throw")
		flash.modulate = Color(2,2,2,1)
		flash.scale.x = 3000
		tween.attribute("modulate", Color(.5,0,.5,0.25), 0.25, flash)
		tween.method("set_flash_radius",0.2,0.8,0.4)
		flash_area.activate()
		next_attack_stage()

	elif attack_stage == 4 and has_finished_last_animation():
		flash.modulate.a = 0
		EndAbility()

func _Interrupt() -> void:
	._Interrupt()
	tween.reset()
	flash.modulate.a = 0


func set_flash_radius(value := 0.0):
	flash.material.set_shader_param("radius",value)
