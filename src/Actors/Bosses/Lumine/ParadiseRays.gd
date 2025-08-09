extends AttackAbility

onready var space: Node = $"../Space"
onready var flap: AudioStreamPlayer2D = $flap
onready var tween := TweenController.new(self,false)

export var rotating_laser : PackedScene

var laser_1: Node2D
var laser_2: Node2D
onready var charge: AudioStreamPlayer2D = $charge
onready var fire: AudioStreamPlayer2D = $fire

var firing_lasers: = false

var wait_duration: = 5.0

func position_both_lasers():
	if not is_instance_valid(laser_1):
		#print_debug("Spawning Lasers")
		laser_1 = position_laser()
		laser_2 = position_laser()

func position_laser() -> Node2D:
	var laser = rotating_laser.instance()
	get_tree().current_scene.add_child(laser,true)
	laser.global_position = space.get_center()
	laser.global_position.y -= 80
	laser.visible = false
	return laser

func _Setup():
	if firing_lasers:
		EndAbility()
		return
	position_both_lasers()
	go_to_high_position()
	play_animation("hand_prepare")
	firing_lasers = true
	flap.play_rp()

func _Update(delta: float) -> void :
	if attack_stage == 0 and has_finished_last_animation():
		play_animation_once("hand")

	elif attack_stage == 1:
		activate_lasers()
		next_attack_stage()
		
	elif attack_stage == 2 and timer > wait_duration:
		play_animation("hand_end")
		next_attack_stage()
		
	elif attack_stage == 3 and has_finished_last_animation():
		play_animation_once("idle")
		go_back_to_hittable_position()
		next_attack_stage()
		
	elif attack_stage == 5:
		EndAbility()

func activate_lasers():
	charge.play()
	laser_1.set_rotation_degrees( - 42.0)
	laser_1.rotate_to(30)
	laser_1.prepare()
	Tools.timer(1.5, "fire_laser1", self)
	Tools.timer(1.85, "second_volley", self)

func second_volley():
	charge.play()
	laser_2.set_rotation_degrees(42.0)
	laser_2.rotate_to( - 30)
	laser_2.prepare()
	Tools.timer(1.5, "fire_laser2", self)
	Tools.timer(1.85, "third_volley", self)

func third_volley():
	charge.play()
	laser_1.set_rotation_degrees( - 42.0)
	laser_1.rotate_to(30)
	laser_1.prepare()
	laser_2.set_rotation_degrees(42.0)
	laser_2.rotate_to( - 30)
	laser_2.prepare()
	Tools.timer(1.5, "fire_both_lasers", self)
	Tools.timer(1.5, "finish_lasers", self)

func fire_laser1():
	laser_1.activate()
	fire.play()
	charge.stop()

func fire_laser2():
	laser_2.activate()
	fire.play()
	charge.stop()

func fire_both_lasers():
	laser_1.activate()
	laser_2.activate()
	fire.play()
	charge.stop()

func finish_lasers():
	firing_lasers = false

func _Interrupt():
	wait_duration = 0.95
	._Interrupt()

func _StartCondition() -> bool:
	if firing_lasers:
		return false
	else:
		return _StartCondition()

func go_to_high_position() -> void :
	var center = GameManager.camera.get_camera_screen_center() + Vector2(0, - 42)
	var time_to_return = 1.0
	turn_towards_point(center)
	tween.create(Tween.EASE_IN_OUT, Tween.TRANS_QUAD)
	tween.add_attribute("global_position:y", center.y, time_to_return, character)
	tween.add_callback("next_attack_stage")

func go_back_to_hittable_position() -> void :
	var pos = space.get_closest_position()
	var time_to_return = 1.0
	
	tween.create(Tween.EASE_IN_OUT, Tween.TRANS_SINE)
	tween.add_attribute("global_position.y", pos.y, time_to_return, character)
	tween.add_callback("next_attack_stage")
