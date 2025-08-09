extends Node2D

export var active := true
var character_direction := 0
onready var character : Bike = get_parent()
onready var hyperdash: Node2D = $"../HyperDash"


func _ready() -> void:
	var _s = hyperdash.connect("hyperdash",self,"clear_vertical_buildup")


func _physics_process(delta: float) -> void:
	if active:
		decay_buildup_based_on_speed(delta)
		if has_turned() or stopped():
			clear_vertical_buildup()

		if has_vertical_buildup() and has_exited_slope():
			apply_vertical_buildup()
		else:
			if should_increment_vertical_buildup():
				increment_vertical_buildup()
		
		#$"../label2".text = str(get_vertical_buildup())

func should_increment_vertical_buildup() -> bool:
	return character.is_on_floor() and character.is_at_proper_slope_jump_speed()

func decay_buildup_based_on_speed(delta) -> void:
	#var speed_m = inverse_lerp(0,420,abs(character.velocity.x))
	if has_vertical_buildup():
		character.vertical_buildup += abs(character.velocity.x) * delta
	else:
		clear_vertical_buildup()

func has_exited_slope() -> bool:
	return character.is_going_down_on_slope()  \
		or is_on_level_plane()       \
		or not character.is_colliding_with_ground()
	
func is_on_level_plane() -> bool:
	return character.get_ground_normal().x < 0.15 and character.get_ground_normal().x > -0.15

func has_vertical_buildup() -> bool:
	return character.vertical_buildup < 0

func get_vertical_buildup() -> float:
	return character.vertical_buildup

func increment_vertical_buildup() -> void:
	if character.velocity.y < character.vertical_buildup:
		character.vertical_buildup = character.velocity.y

func apply_vertical_buildup() -> void:
	var buildup = get_vertical_buildup() * 1.1
	if abs(buildup) > 100:
		#print_debug("Applying vertical buildup: " + str(buildup))
		if character.get_vertical_speed() > buildup:
			character.call_deferred("set_vertical_speed",buildup)
	clear_vertical_buildup()

func clear_vertical_buildup() -> void:
	character.vertical_buildup = 0

func stopped() -> bool:
	return abs(character.get_actual_speed()) < 10

func has_turned() -> bool:
	if character_direction != character.get_facing_direction():
		character_direction = character.get_facing_direction()
		return true
	return false
