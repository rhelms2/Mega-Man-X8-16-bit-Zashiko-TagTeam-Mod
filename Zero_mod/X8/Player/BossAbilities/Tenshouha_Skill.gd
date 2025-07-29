extends Movement
class_name SaberTenshouhaX8

onready var animatedSprite = character.get_node("animatedSprite")
onready var laser = preload("res://src/Actors/Player/BossWeapons/OpticShield/OpticShieldCharged.tscn")
onready var ground_check: RayCast2D = $ground_check
onready var laser_cast_frame: int = 5
onready var sfx: Node = $sfx

var ending_saber_state: bool = false
var creator: Node2D
var laser_casted: bool = false


func _ready() -> void :
	Event.connect("saber_has_hit_boss", self, "reduce_speed")
	animatedSprite.connect("animation_finished", self, "_on_animation_finished")

func _on_animation_finished() -> void :
	ending_saber_state = true

func end_ability_state() -> bool:
	return ending_saber_state

func cast_laser() -> void :
	if not laser_casted:
		if animatedSprite.animation == "tenshouha":
			if animatedSprite.frame >= laser_cast_frame:
				fire_laser()
				laser_casted = true
				Event.emit_signal("screenshake", 0.5)

func _StartCondition() -> bool:
	if not character.Tenshouha:
		return false
	if not character.get_action_pressed("move_down"):
		return false
	var _animation = get_parent().get_animation()
	if _animation in character.saber_animations:
		return false
	if not executing:
		if character.is_on_floor():
			return true
	return false

func _ResetCondition() -> bool:
	return false

func _EndCondition() -> bool:
	var _animation = get_parent().get_animation()
	if _animation in character.saber_animations:
		if not _animation == "tenshouha":
			return true
		if end_ability_state():
			return true
	else:
		return true
	return false

func _Setup() -> void :
	
	update_bonus_horizontal_only_conveyor()
	changed_animation = false
	laser_casted = false
	ending_saber_state = false

func _Update(_delta: float) -> void :
	cast_laser()
	force_movement(0)
	
	process_gravity(_delta)
	update_bonus_horizontal_only_conveyor()

func change_animation_if_falling(_s) -> void :
	pass

func _Interrupt() -> void :
	._Interrupt()

func fire_laser() -> void :
	var ground_position = Vector2(global_position.x, global_position.y + 256)
	if ground_check.is_colliding():
		ground_position = ground_check.get_collision_point()
	create_laser(ground_position)

func create_laser(ground_position) -> void :
	var instance = laser.instance()
	ground_position.y += 7
	instance.modulate = Color(1, 1, 1, 0.65)
	instance.z_index = character.z_index + 10
	instance.mid_animation_time = 0.12
	instance.end_animation_time = 1.45
	instance.deflectable = true
	get_tree().current_scene.get_node("Objects").call_deferred("add_child", instance, true)
	instance.set_global_position(ground_position)
	instance.set_creator(creator)
	instance.call_deferred("initialize", get_facing_direction())
