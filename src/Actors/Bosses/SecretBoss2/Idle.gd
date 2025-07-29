extends AttackAbility

const order = [0, 5, 2, 6, 3, 1, 4]
var teleport_positions = []
var times_used: = 0
var position_count: = 0
onready var damage: Node2D = $"../Damage"
onready var dot: Node2D = $"../DamageOnTouch"
onready var disappear: AudioStreamPlayer2D = $disappear
onready var reflector: Node2D = $"../DamageReflector"

signal teleported
signal started

func _Setup() -> void :
	times_used = 0
	emit_signal("started")
	#queue_reset = true
	pass

var queue_reset := false
func _Update(delta) -> void:
	process_gravity(delta)
	if attack_stage == 0:
		times_used += 1
		play_animation("teleport")
		disappear.play()
		reflector.deactivate()
		damage.deactivate()
		dot.deactivate()
		next_attack_stage()

	elif attack_stage == 1 and timer > 0.25:
		if queue_reset:
			queue_reset = false
			reflector.reset()
		reflector.hide_laser()
		emit_signal("teleported")
		character.global_position = get_teleport_position() + Vector2(0,-21)
		position_count += 1
		turn_and_face_player()
		play_animation("teleport_end")
		reflector.activate()
		Tools.timer(0.15,"activate",dot)
		if reflector.deflects == 0:
			queue_reset = true
		next_attack_stage()
	
	elif attack_stage == 2 and timer > 1.0:
		go_to_attack_stage(0)

func _Interrupt() -> void:
	damage.activate()
	dot.activate()
	reflector.activate()

func get_teleport_position() -> Vector2:
	if position_count >= 7:
		position_count = 0
	return teleport_positions[order[position_count]]

func get_teleport_positions() -> void:
	var top = raycast_upward(1024)["position"]
	var origin = Vector2(top.x, top.y + 4.0)
	var left_wall = raycast_from(origin,origin + Vector2(-1024,0))["position"]
	var right_wall = raycast_from(origin,origin + Vector2(1024,0))["position"]
	var distance_between_walls = (right_wall.x - 32) - (left_wall.x + 32)
	var interval = distance_between_walls / 6
	
	var i = 0
	while i < 7:
		var tel_pos : Vector2
		var ceiling = left_wall + Vector2(32 + interval * i,0) 
		tel_pos = raycast_from(ceiling, ceiling + Vector2(0,1024))["position"]
		teleport_positions.append(Vector2(round(tel_pos.x),tel_pos.y))
		i += 1


func _on_Intro_ability_start(_ability) -> void:
	get_teleport_positions()
