extends AttackAbility

const order = [5,2,6,3,1,4,0]
var teleport_positions = []
var times_used := 0
onready var damage: Node2D = $"../Damage"
onready var dot: Node2D = $"../DamageOnTouch"
onready var disappear: AudioStreamPlayer2D = $disappear
onready var appear: AudioStreamPlayer2D = $appear
onready var leaves: Particles2D = $leaves

func _Setup() -> void:
	times_used += 1
	leaves.emitting = true
	play_animation("tp_out")
	disappear.play()
	damage.deactivate()
	dot.deactivate()

func _Update(delta) -> void:
	process_gravity(delta)
	if attack_stage == 0 and has_finished_last_animation():
		character.global_position = get_teleport_position()
		play_animation("tp_appear_prepare")
		appear.play()
		next_attack_stage()
		leaves.emitting = false
	
	elif attack_stage == 1 and has_finished_last_animation():
		play_animation("tp_appear")
		turn_and_face_player()
		damage.activate()
		Tools.timer(0.25,"activate",dot)
		next_attack_stage()
	
	elif attack_stage == 2 and has_finished_last_animation():
		EndAbility()

func _Interrupt() -> void:
	damage.activate()
	dot.activate()
	leaves.emitting = false

func get_teleport_position() -> Vector2:
	if times_used >= 6:
		times_used = 0
	return teleport_positions[order[times_used]]

func get_teleport_positions() -> void:
	var top = raycast_upward(1024)["position"]
	var origin = Vector2(top.x, top.y + 4.0)
	var left_wall = raycast_from(origin,origin + Vector2(-1024,0))["position"]
	var right_wall = raycast_from(origin,origin + Vector2(1024,0))["position"]
	var distance_between_walls = (right_wall.x - 32) - (left_wall.x + 32)
	var interval = distance_between_walls/6
	
	var i = 0
	while i < 7:
		var tel_pos : Vector2
		var ceiling = left_wall + Vector2(32 + interval * i,0) 
		tel_pos = raycast_from(ceiling, ceiling + Vector2(0,1024))["position"]
		teleport_positions.append(Vector2(round(tel_pos.x),tel_pos.y) + Vector2(0,-50))
		i += 1


func _on_Intro_ability_start(_ability) -> void:
	get_teleport_positions()
