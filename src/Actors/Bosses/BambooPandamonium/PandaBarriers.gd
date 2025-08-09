extends AttackAbility
const barrier_distance := 52.0
export var barrier : PackedScene
var current_distance_right := barrier_distance
var current_distance_left := -barrier_distance
var target_position : Vector2

onready var start: AudioStreamPlayer2D = $start
onready var flooor: AudioStreamPlayer2D = $floor
onready var remove: AudioStreamPlayer2D = $remove


signal barriers_created
signal cancel

func _Setup() -> void:
	._Setup()
	current_distance_right = barrier_distance
	current_distance_left = -barrier_distance
	Tools.timer(0.42,"play",start)
	

func _Update(_delta) -> void:
	process_gravity(_delta)
	if attack_stage == 0 and has_finished_last_animation():
		play_animation("drill_prepare_loop")
		next_attack_stage()
		
	elif attack_stage == 1 and timer > 0.25:
		play_animation("drill_start")
		next_attack_stage()
		
	elif attack_stage == 2 and has_finished_last_animation():
		play_animation("drill_start_loop")
		next_attack_stage()
		
	elif attack_stage == 3 and timer > 0.35:
		play_animation("drill")
		start.stop()
		flooor.play()
		emit_signal("barriers_created")
		create_barriers()
		screenshake()
		next_attack_stage()
		
	elif attack_stage == 4 and has_finished_last_animation():
		play_animation("drill_loop")
		next_attack_stage()
		
	elif attack_stage == 5 and timer > 0.35:
		next_attack_stage()
		
	elif attack_stage == 6 and timer > 0.35:
		play_animation("drill_end")
		flooor.stop()
		Tools.timer(0.23,"play",remove)
		next_attack_stage()
		
	elif attack_stage == 7 and has_finished_last_animation():
		EndAbility()

func _Interrupt() -> void:
	flooor.stop()

func create_barriers() -> void:
	target_position = Vector2(GameManager.get_player_position().x, get_ground_y())
	create_right_barrier()
	Tools.timer(0.1,"create_right_barrier",self)
	Tools.timer(0.2,"create_right_barrier",self)
	create_left_barrier()
	Tools.timer(0.1,"create_left_barrier",self)
	Tools.timer(0.2,"create_left_barrier",self)

func create_right_barrier() -> void:
	var b = instantiate(barrier)
	connect_barrier_signals(b)
	b.global_position = target_position + Vector2(current_distance_right,0)
	current_distance_right += barrier_distance
	
func create_left_barrier() -> void:
	var b = instantiate(barrier)
	connect_barrier_signals(b)
	b.global_position = target_position + Vector2(current_distance_left,0)
	current_distance_left -= barrier_distance

func connect_barrier_signals(barrier) -> void:
	var _d = get_parent().connect("death",barrier,"expire")
	_d = connect("barriers_created",barrier,"expire")
	_d = connect("cancel",barrier,"expire")

func cancel_barriers() -> void:
	emit_signal("cancel")

func get_ground_y() -> float:
	return global_position.y
