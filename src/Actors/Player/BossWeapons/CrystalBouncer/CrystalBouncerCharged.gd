extends SimplePlayerProjectile

const destroyer: = true

export  var duration: = 5.0
var shattered: = false
onready var stage: = AbilityStage.new(self, false)
onready var animation: = AnimationController.new($animatedSprite)
onready var break_s: AudioStreamPlayer2D = $break
onready var wall_check_left: RayCast2D = $platform / wallCheck_left
onready var wall_check_right: RayCast2D = $platform / wallCheck_right
onready var collider: CollisionShape2D = $platform / collisionShape2D
onready var remains: Particles2D = $remains
onready var ceiling_check: Array = [$platform / wallCheck_up, $platform / wallCheck_up2, $platform / wallCheck_up3]
onready var appear: AudioStreamPlayer2D = $appear

var player_direction: = 0

func _Setup() -> void :
	Event.emit_signal("crystal_wall_created", self)
	Tools.timer(0.1, "disable_damage", self)

func _Update(delta: float) -> void :
	if not active:
		return
	
	break_if_crushing_player()
	break_if_low_ceiling()
	process_gravity(delta)
	
	if stage.is_initial():
		animation.play("start")
		appear.play_rp()
		activate_collider()
		Tools.timer(0.042, "activate_damage", self)
		Tools.timer(0.126, "deactivate_damage", self)
		stage.next()
	
	elif stage.currently_is(1) and timer > 0.13:
		stage.next()
	
	elif stage.currently_is(2) and timer > 1.4:
		animation.play("loop")
		stage.next()
	
	elif stage.currently_is(3) and timer > duration:
		shatter()
		stage.next()
	
	elif stage.currently_is(4) and timer > 1:
		break_crystal()

func break_if_low_ceiling() -> void :
	for check in ceiling_check:
		if check.is_colliding():
			if stage.current_stage < 5:
				break_crystal()
		

func break_if_crushing_player() -> void :
	if is_player_on_crush_zone():
		if is_distance_smaller_than(32.0):
			if stage.current_stage < 5:
				break_crystal()

func shatter() -> void :
	if not shattered:
		shattered = true
		animation.play("shatter")
		break_s.play_rp(0.05, 1.85)

func break_crystal() -> void :
	if active:
		scale.y = 1
		deactivate_collider()
		emit_break_vfx()
		Tools.timer(2.0, "destroy", self)
		deactivate()
		disable_damage()
		break_s.play_rp(0.025)
		stage.go_to_stage(6)

func is_player_nearby() -> bool:
	return player_direction != 0

func has_wall_to_the_right() -> bool:
	return wall_check_right.is_colliding()
func has_wall_to_the_left() -> bool:
	return wall_check_left.is_colliding()

func is_player_on_crush_zone() -> bool:
	if has_wall_to_the_left():
		return player_direction == - 1
	elif has_wall_to_the_right():
		return player_direction == 1
	return false

func is_close_to_wall() -> int:
	if get_facing_direction() < 0:
		if wall_check_left.is_colliding():
			return 1
	elif get_facing_direction() > 0:
		if wall_check_right.is_colliding():
			return - 1
	return 0

func is_distance_smaller_than(distance: float) -> bool:
	if has_wall_to_the_left():
		if abs(distance_to_wall(wall_check_left)) <= distance:
			return true
	elif has_wall_to_the_right():
		if abs(distance_to_wall(wall_check_right)) <= distance:
			return true
	return false

func distance_to_wall(wallcheck) -> float:
	return global_position.x - wallcheck.get_collision_point().x

func activate_damage() -> void :
	if active:
		enable_damage()
		$collisionShape2D.set_deferred("disabled", false)
		

func deactivate_damage() -> void :
	disable_damage()

func activate_collider() -> void :
	collider.disabled = false
	collider.scale.x = 0
	Tools.tween(collider, "scale", Vector2.ONE, 0.16)

func deactivate_collider() -> void :
	collider.disabled = true

func emit_break_vfx() -> void :
	animation.set_visible(false)
	
	remains.emitting = true

func _on_playerDetector_left_body_entered(_body: Node) -> void :
	player_direction = - 1

func _on_playerDetector_right_body_entered(_body: Node) -> void :
	player_direction = 1

func _on_playerDetector_left_body_exited(_body: Node) -> void :
	player_direction = 0

func _on_playerDetector_right_body_exited(_body: Node) -> void :
	player_direction = 0


func disable_damage() -> void :
	set_collision_layer_bit(2, false)

		
func _OnHit(_target_remaining_HP) -> void :
	pass
func _OnDeflect() -> void :
	pass

