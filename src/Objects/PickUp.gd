extends KinematicBody2D
class_name PickUp

export  var heal: = 2
export  var duration: = 4

onready var animated_sprite = $animatedSprite

var amount_to_heal: = 2
var expirable: = false
var groundcheck_distance: = 6.0
var time_since_spawn: = 0.0
var timer: = 0.0
var last_time_increased: = 0.0
var executing: = false
var emitted_signal: = false
var player
var velocity = Vector2.ZERO
var bonus_velocity = Vector2.ZERO
var final_velocity = Vector2.ZERO


func _ready() -> void :
	amount_to_heal = heal

func _physics_process(delta: float) -> void :
	process_gravity(delta)
	process_movement()
	process_state(delta)
	process_effect(delta)

func process_effect(delta: float) -> void :
	if executing:
		timer += delta
		if player.current_health < player.max_health:
			do_heal()
		else:
			if amount_to_heal > 0:
				add_health_to_subtank()
		if amount_to_heal == 0:
			timer = 0
			GameManager.unpause(name)
			amount_to_heal = - 1
		if amount_to_heal < 0:
			if not emitted_signal:
				player.emit_signal("collected_health", heal)
				emitted_signal = true
			if not $audioStreamPlayer2D.playing:
				queue_free()

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

func add_health_to_subtank():
	if amount_to_heal != heal:
		Event.emit_signal("add_to_subtank", amount_to_heal, true)
	else:
		Event.emit_signal("add_to_subtank", amount_to_heal, false)
	amount_to_heal = 0

func do_heal():
	if timer > last_time_increased + 0.06 and amount_to_heal > 0:
		player.recover_health(1)
		last_time_increased = timer
		amount_to_heal -= 1
		$audioStreamPlayer2D.play()

func _on_area2D_body_entered(body: Node) -> void :
	if not executing:
		if body.is_in_group("Player"):
			if body.is_in_group("Props"):
				if not GameManager.player.ride:
					return
			elif not body.character.is_current_player:
				return
			set_pause_mode(Node.PAUSE_MODE_PROCESS)
			$audioStreamPlayer2D.set_pause_mode(Node.PAUSE_MODE_PROCESS)
			var lifeup_sound = get_node_or_null("audioStreamPlayer2D2")
			if lifeup_sound != null:
				lifeup_sound.set_pause_mode(Node.PAUSE_MODE_PROCESS)
			GameManager.pause(name)
			timer = 0.01
			executing = true
			visible = false
			player = GameManager.player

func raycast(target_position: Vector2) -> Dictionary:
	var space_state = get_world_2d().direct_space_state
	return space_state.intersect_ray(global_position, target_position, [self], collision_mask)

func process_movement():
	final_velocity = velocity + bonus_velocity
	move_and_collide(Vector2.ZERO)
	final_velocity = process_final_velocity()
	velocity.y = final_velocity.y

func process_final_velocity() -> Vector2:
	return move_and_slide_with_snap(final_velocity, Vector2.DOWN * 8, Vector2.UP, true)

func process_gravity(_delta: float, gravity: = 800) -> void :
	if not is_on_floor():
		velocity.y = velocity.y + (gravity * _delta)
