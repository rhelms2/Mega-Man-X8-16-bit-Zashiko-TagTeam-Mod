extends AttackAbility


export  var speed: = 50.0
var executed_once: = false
var reached_ceilling: = false
var collision_point: Vector2
onready var screw_texture: Line2D = $"../ScrewTexture"
onready var bottom_sprite: AnimatedSprite = $"../bottomSprite"
onready var bottom_ray: RayCast2D = $"../bottomSprite/rayCast2D"
onready var ceil_ray: RayCast2D = $ceilcast
onready var damage_area: Area2D = $"../area2D"
onready var wall_area: StaticBody2D = $"../WallArea"

func _StartCondition() -> bool:
	return not executed_once

func _process(_delta: float) -> void :
	call_deferred("reach_ceilling")

func reach_ceilling() -> void :
	if not reached_ceilling:
		if ceil_ray.is_colliding():
			reached_ceilling = true
			Log(character.name + ": collision at : " + str(ceil_ray.get_collision_point()))
			Log(ceil_ray.get_collider().name)
			Log(ceil_ray.get_collider().get_parent().name)
			character.global_position.y = ceil_ray.get_collision_point().y + 24
			Log(character.name + ": new position : " + str(global_position))

func _Update(delta: float) -> void :
	if attack_stage == 0 and timer > 0.5:
		play_animation_once("pump_start")
		if has_finished_last_animation():
			next_attack_stage()
	
	elif attack_stage == 1:
		play_animation_once("pump")
		send_bottom_half_downwards(delta)
		if has_reached_bottom():
			correct_bottom_height()
			next_attack_stage()
	
	elif attack_stage == 2:
		play_animation_once("idle")
		executed_once = true
		EndAbility()

func send_bottom_half_downwards(delta: float) -> void :
	bottom_sprite.global_position.y += delta * speed
	screw_texture.points[1].y += delta * speed
	damage_area.scale.y += delta * speed
	wall_area.scale.y += delta * speed

func correct_bottom_height() -> void :
	collision_point = bottom_ray.get_collision_point()
	bottom_sprite.global_position.y = collision_point.y - 7

func has_reached_bottom() -> bool:
	return bottom_ray.is_colliding()
	
