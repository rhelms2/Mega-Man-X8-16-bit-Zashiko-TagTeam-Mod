extends AttackAbility
onready var damage_on_touch: DamageOnTouch = $"../DamageOnTouch"
var speed := 0.0
var initial_pos := Vector2.ZERO
onready var up: RayCast2D = $up
onready var down: RayCast2D = $down
onready var animated_sprite: AnimatedSprite = $"../animatedSprite"
onready var up_2: RayCast2D = $up2
onready var down_2: RayCast2D = $down2

func _ready() -> void:
	speed = horizontal_velocity
	initial_pos = global_position
	call_deferred("setup_direction")

func _Setup() -> void:
	._Setup()
	set_vertical_speed(speed)

func setup_direction() -> void:
	if character.get_direction() == -1 and animated_sprite.rotation_degrees != -90:
		animated_sprite.rotation_degrees = -90
		animatedSprite.position.x = 4
		up_2.cast_to.x = 16
		down_2.cast_to.x = 16
	elif character.get_direction() == 1 and animated_sprite.rotation_degrees != 90:
		animated_sprite.rotation_degrees = 90
		up_2.cast_to.x = -16
		down_2.cast_to.x = -16

func _Update(_delta) -> void:
	if attack_stage == 0 and has_finished_last_animation():
		play_animation_once("stop")
		activate_touch_damage()
		next_attack_stage()
		
	elif attack_stage == 1:
		play_animation_once("idle")
		if is_colliding() or is_over_range() or is_near_ledge():
			invert()
			set_vertical_speed(speed)
			next_attack_stage()
	elif attack_stage == 2 and timer> 0.1:
		go_to_attack_stage(1)

func invert() -> void:
	Log("inverting")
	Log(speed)
	speed = speed * -1
	Log(speed)

func is_colliding() -> bool:
	return up.is_colliding() or down.is_colliding()
	
func is_near_ledge() -> bool:
	return not up_2.is_colliding() or not down_2.is_colliding()

func is_over_range() -> bool:
	return initial_pos.y > global_position.y + character.radius or \
		   initial_pos.y < global_position.y - character.radius

func deactivate_touch_damage() -> void:
	damage_on_touch.active = false

func activate_touch_damage() -> void:
	damage_on_touch.active = true
