extends Node2D

export var active := true
export var parent_signal := "zero_health"
export var ride_ability : NodePath
onready var ride = get_node_or_null(ride_ability)
onready var character: KinematicBody2D = $".."

onready var crush_cast_up = $death_up
onready var crush_cast_down = $death_down
onready var crush_cast_left = $death_left
onready var crush_cast_right = $death_right
onready var death_right_2: RayCast2D = $death_right2
onready var death_left_2: RayCast2D = $death_left2
onready var crush_vertical = [crush_cast_up,crush_cast_down]
onready var crush_horizontal = [crush_cast_left,crush_cast_right]
onready var crush_horizontal2 = [crush_cast_left,crush_cast_right]


func _physics_process(_delta: float) -> void:
	if active and can_be_crushed():
		check(crush_vertical)
		check(crush_horizontal)
		check(crush_horizontal2)

func can_be_crushed() -> bool:
	if not character.colliding:
		return false
	if ride != null:
		return not ride.executing
	return true

func check(crush_casts) -> void:
	var death_hits := 0
	for cast in crush_casts:
		if cast.is_colliding():
			death_hits += 1
	if death_hits == 2:
		character.emit_signal(parent_signal)
		print_debug("CRUSH DETECTED")
		set_physics_process(false)
