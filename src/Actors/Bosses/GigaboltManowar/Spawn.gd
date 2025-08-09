extends AttackAbility

export var jellyfish : PackedScene
onready var spin: AudioStreamPlayer2D = $spin

var rolled_around := false
var at_end_position := false
var wait := 0.0
onready var collider: CollisionShape2D = $"../collisionShape2D"
onready var tween = TweenController.new(self)
onready var space: Node = $"../Space"
onready var move: AudioStreamPlayer2D = $"../move"

signal stop

func _ready() -> void:
	pass

func _Setup() -> void:
	play_animation("move_up")
	move.play_rp()
	rolled_around = false
	at_end_position = false
	collider.disabled = true
	tween.create(Tween.EASE_IN_OUT,Tween.TRANS_SINE,false)
	var destination = space.center + Vector2(0,32)
	turn_towards_point(destination)
	tween.add_attribute("global_position",destination,space.time_to_position(destination,140),character)
	tween.add_callback("next_attack_stage")

func _Update(_delta) -> void:
	if attack_stage == 1:
		play_animation("roll_prepare")
		turn_and_face_player()
		next_attack_stage()
	elif attack_stage == 2 and has_finished_last_animation():
		play_animation("roll_start")
		spin.play()
		next_attack_stage()
	elif attack_stage == 3 and has_finished_last_animation():
		play_animation("roll_loop")
		roll_around()
		next_attack_stage()
	elif attack_stage == 4 and rolled_around:
		play_animation("roll_end")
		next_attack_stage()
	elif attack_stage == 5 and has_finished_last_animation():
		play_animation("move_down")
		next_attack_stage()
	elif attack_stage == 6:# and at_end_position:
		EndAbility()

func go_to_closest_position() -> void:
	var pos = space.get_closest_position()
	tween.create(Tween.EASE_IN_OUT,Tween.TRANS_SINE)
	tween.add_attribute("global_position",pos,space.time_to_position(pos),character)
	tween.add_callback("at_end")

func at_end() -> void:
	at_end_position = true

func roll_around() -> void:
	tween_horizontal_movement()
	tween_vertical_movement()
	spawn_jellies()

func spawn_jellies() -> void:
	tween.create()
	tween.add_attribute("wait",1.0,0.3)
	tween.add_callback("spawn")
	tween.add_attribute("wait",1.0,0.05)
	var i = 0
	while i < 3:
		tween.add_callback("spawn")
		tween.add_attribute("wait",1.0,0.05)
		i += 1

	tween.add_attribute("wait",1.0,0.8)
	
	i = 0
	while i < 4:
		tween.add_callback("spawn")
		tween.add_attribute("wait",1.0,0.05)
		i += 1

func tween_horizontal_movement() -> void:
	tween.create()
	tween.add_method("set_horizontal_speed",0.0,-horizontal_velocity,0.35)
	tween.add_method("set_horizontal_speed",-horizontal_velocity,horizontal_velocity,0.35)
	tween.add_method("set_horizontal_speed",horizontal_velocity,horizontal_velocity,0.35)
	tween.add_method("set_horizontal_speed",horizontal_velocity,-horizontal_velocity,0.35)
	tween.add_method("set_horizontal_speed",-horizontal_velocity,0.0,0.35)

func tween_vertical_movement() -> void:
	tween.create()
	tween.add_method("set_vertical_speed",0.0,jump_velocity,0.35)
	tween.add_method("set_vertical_speed",jump_velocity,jump_velocity,0.35)
	tween.add_method("set_vertical_speed",jump_velocity,-jump_velocity,0.35)
	tween.add_method("set_vertical_speed",-jump_velocity,-jump_velocity,0.35)
	tween.add_method("set_vertical_speed",-jump_velocity,0.0,0.351)
	tween.add_callback("finished_rolling_around")

func spawn() -> void:
	var s = instantiate(jellyfish)
	character.listen("zero_health",s,"auto_destruct")

func finished_rolling_around() -> void:
	Event.emit_signal("jellyfish_start")
	rolled_around = true

func _Interrupt() -> void:
	collider.set_deferred("disabled",false)
	emit_signal("stop")
