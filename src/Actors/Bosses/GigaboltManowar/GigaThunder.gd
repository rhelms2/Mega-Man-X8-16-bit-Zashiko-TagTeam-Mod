extends AttackAbility
export var flash :PackedScene

onready var space: Node = $"../Space"
onready var tween := TweenController.new(self)
var reached_pos := false
var time_to_return := 1.0
signal stop
onready var prepare: AudioStreamPlayer2D = $prepare
onready var move: AudioStreamPlayer2D = $"../move"

func _Update(_delta) -> void:
	if attack_stage == 0:
		go_to_closest_position()
		play_animation("move_down")
		move.play_rp()
		next_attack_stage()
	
	elif attack_stage == 1 and timer > time_to_return:
		turn_and_face_player()
		play_animation("thunder_prepare")
		prepare.play()
		next_attack_stage()
	
	elif attack_stage == 2 and has_finished_last_animation():
		play_animation("thunder_start")
		create_flashs()
		next_attack_stage()
	
	elif attack_stage == 3 and timer > 0.75:
		character.global_position = space.center
		character.scale.x = 1
		character.global_position.y -= 128
		next_attack_stage()
	
	elif attack_stage == 4 and has_finished_last_animation():
		play_animation("thunder_loop")
		go_to_center()
		next_attack_stage()
		
	elif attack_stage == 5 and timer > time_to_return:
		play_animation("thunder_end")
		next_attack_stage()
		
	elif attack_stage == 6 and has_finished_last_animation():
		EndAbility()

func create_flashs() -> void:
	var pos1 := character.global_position
	var pos2 : Vector2
	var pos3 : Vector2
	var angle1 := 0.0
	var angle2 : float
	var angle3 : float
	pos2 = Vector2(space.arena_pos.x + space.arena_size.x, character.global_position.y - 64)
	pos3 = Vector2(space.arena_pos.x, character.global_position.y - 80)
	angle2 = -10.0 + 180
	angle3 = 39.0
	if get_facing_direction() == -1:
		angle1 = 180.0
		angle2 = -12.0
		angle3 = 39.0 + 180
		pos2 = Vector2(space.arena_pos.x, character.global_position.y - 24)
		pos3 = Vector2(space.arena_pos.x + space.arena_size.x, character.global_position.y + 64)
	
	Tools.timer_p(0.05, "create_flash",self,[pos1,angle1])
	Tools.timer_p(0.30, "create_flash",self,[pos2,angle2])
	Tools.timer_p(0.60, "create_flash",self,[pos3,angle3])

func create_flash(global_pos, rotate:= 0.0) -> void:
	if executing:
		var projectile = flash.instance()
		projectile.global_position = global_pos
		projectile.rotate_degrees(rotate)
		get_tree().current_scene.add_child(projectile)
		var _s = connect("stop",projectile,"queue_free")
	

func go_to_closest_position() -> void:
	var pos = space.get_closest_position()
	pos.y = GameManager.get_player_position().y
	time_to_return = clamp(space.time_to_position(pos) /2,0.65,2.0)
	tween.create(Tween.EASE_IN_OUT,Tween.TRANS_SINE)
	tween.add_attribute("global_position",pos,time_to_return,character)

func go_to_center() -> void:
	tween.create(Tween.EASE_IN_OUT,Tween.TRANS_SINE,false)
	var destination = space.center + Vector2(0,32)
	time_to_return = space.time_to_position(destination)
	turn_towards_point(destination)
	tween.add_attribute("global_position",destination,time_to_return,character)

func reached_position() -> void:
	reached_pos = true

func is_in_position() -> bool:
	return reached_pos

func _Interrupt() -> void:
	emit_signal("stop")
