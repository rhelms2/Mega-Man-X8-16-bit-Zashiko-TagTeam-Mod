extends KinematicBody2D
class_name CopyPickUp

export  var duration: float = 4.0

onready var animated_sprite: = $animatedSprite
onready var pickup_sound: = $audioStreamPlayer2D

var expirable: bool = true
var groundcheck_distance: float = 6.0
var time_since_spawn: float = 0.0
var timer: float = 0.0
var last_time_increased: float = 0.0
var executing: bool = false
var emitted_signal: bool = false
var player
var velocity: Vector2 = Vector2.ZERO
var bonus_velocity: Vector2 = Vector2.ZERO
var final_velocity: Vector2 = Vector2.ZERO
var collected: bool = false
var copiedenemy


func _physics_process(delta: float) -> void :
	process_gravity(delta)
	process_movement()
	process_state(delta)
	process_effect(delta)

func process_state(delta: float) -> void :
	if is_on_floor():
		time_since_spawn += delta
		if animated_sprite.animation != "idle":
			animated_sprite.play("idle")
		if expirable and not executing:
			if not GameManager.is_on_screen(global_position):
				queue_free()
			else:
				if time_since_spawn > duration * 0.75:
					set_modulate(Color(1, 1, 1, abs(round(cos(time_since_spawn * 500)))))
				if time_since_spawn > duration:
					queue_free()

func get_enemy_instance():
	if "Drone" in copiedenemy:
		return load("res://Axl_mod/Player/Projectiles/Transform/Transfomed Enemies/Drone/Drone_Transformed.tscn")
	elif "MetoolQueatira" in copiedenemy:
		return load("res://Axl_mod/Player/Projectiles/Transform/Transfomed Enemies/Metool/MetoolQueAtira_Transformed.tscn")
	elif "Turret" in copiedenemy:
		return load("res://Axl_mod/Player/Projectiles/Transform/Transfomed Enemies/Turret/Turret_Transformed.tscn")
	elif "FlameThrower" in copiedenemy:
		return load("res://Axl_mod/Player/Projectiles/Transform/Transfomed Enemies/Throwers/FlameThrower_Transformed.tscn")

func add_copy_enemy() -> void :
	if not collected:
		pickup_sound.play()
		collected = true
		var transform_node = player.get_node("Shot").get_node("Transform")
		if transform_node != null:
			transform_node.active = true
			transform_node.transform_enemy = get_enemy_instance()
			player.get_node("Shot").update_list_of_weapons()

func process_effect(delta: float) -> void :
	if executing:
		timer += delta
		add_copy_enemy()
		if not pickup_sound.playing:
			queue_free()

func _on_area2D_body_entered(body: Node) -> void :
	if not executing:
		if body.is_in_group("Player"):
			if body.is_in_group("Props") and not GameManager.player.ride:
				return
			executing = true
			visible = false
			player = GameManager.player

func raycast(target_position: Vector2) -> Dictionary:
	var space_state = get_world_2d().direct_space_state
	return space_state.intersect_ray(global_position, target_position, [self], collision_mask)

func process_movement() -> void :
	final_velocity = velocity + bonus_velocity
	move_and_collide(Vector2.ZERO)
	final_velocity = process_final_velocity()
	velocity.y = final_velocity.y

func process_final_velocity() -> Vector2:
	return move_and_slide_with_snap(final_velocity, Vector2.DOWN * 8, Vector2.UP, true)

func process_gravity(_delta: float, gravity: = 800) -> void :
	if not is_on_floor():
		velocity.y = velocity.y + (gravity * _delta)
