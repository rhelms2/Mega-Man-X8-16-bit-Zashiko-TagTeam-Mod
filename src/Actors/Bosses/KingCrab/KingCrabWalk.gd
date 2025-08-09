extends AttackAbility
class_name KingCrabWalk

export var walk_speed := 30
export var max_distance := 64
var max_time := 1.0
var direction := -1
onready var footstep: AudioStreamPlayer2D = $footstep
onready var footstep_2: AudioStreamPlayer2D = $footstep2

onready var initial_position := global_position.x

func _Setup() -> void:
	direction = decide_direction()
	if is_past_maxdistance():
		direction = -direction
	
	max_time = 2.2
	
	force_movement_regardless_of_direction(walk_speed * direction)
	if direction < 0:
		play_animation("walk_foward")
	elif direction > 0:
		play_animation("walk_back")

func _Update(_delta) -> void:
	if animatedSprite.frame == 3:
		if not footstep.playing:
			screenshake(.8)
			footstep.play()
	elif animatedSprite.frame == 6:
		if not footstep_2.playing:
			footstep_2.play()

func decide_direction() -> int:
	var r = rand_range(-1.0,1.0)
	if r > 0:
		Log("Direction Backwards")
		return 1
	else:
		Log("Direction Forward")
		return -1

func _EndCondition() -> bool:
	if timer > max_time:
		print_debug("Ended because of time")
		return true
	
	if direction < 0:
		if global_position.x <=  initial_position - max_distance:
			return true
	elif direction > 0:
		if global_position.x >=  initial_position:
			return true
	return false

func _Interrupt() -> void:
	._Interrupt()
	play_animation("idle")
	

func is_past_maxdistance() -> bool:
	if direction < 0:
		if global_position.x <=  initial_position - max_distance:
			Log("Can't walk anymore, past max_distance")
			return true
	elif direction > 0:
		if global_position.x >=  initial_position:
			Log("Can't walk anymore, past max_distance")
			return true
	return false
	
