extends Enemy

export var strong_sprites : Resource
var player_at_left := false
var player_at_right := false
var creator : Node2D
var shattered := false
onready var collider: CollisionShape2D = $rigidBody2D/collisionShape2D
onready var wall_check_left: RayCast2D = $wallCheck_left
onready var wall_check_right: RayCast2D = $wallCheck_right
onready var wallchecks = [wall_check_left, wall_check_right]
onready var explosion: Particles2D = $explosion
onready var remains: Particles2D = $remains
onready var dot: Node2D = $DamageOnTouch

onready var stage := AbilityStage.new(self,false)
onready var animation := AnimationController.new($animatedSprite)
var timer := 0.0
var speed := 0.0

func _ready() -> void:
	$appear.play_rp()
	call_deferred("kill_if_not_onscreen")

func kill_if_not_onscreen():
	if not is_on_screen():
		queue_free()

func is_on_screen() -> bool:
	var camera = GameManager.camera
	return abs(camera.get_camera_screen_center().x - global_position.x) < 180 and abs(camera.get_camera_screen_center().y - global_position.y) < 128

func initialize(_speed : float) -> void:
	if _speed < 0:
		set_direction(-1)
	else:
		set_direction(1)
	dot.damage = 3
	speed = _speed
	animation.change_spriteframes(strong_sprites)
	remains.modulate = Color("6affea")

func break_if_crushing_player() -> void:
	if raycasts_are_detecting_a_wall() and is_player_nearby():
		if raycast_distance_to_wall_is_smaller_than(32.0):
			if is_still_active():
				Log("Detected Player Crush")
				activate_damage()
				break_crystal()
				_on_zero_health()

func is_still_active() -> bool:
	return stage.current_stage < 5

func shatter_if_one_health() -> void:
	if current_health < 3 and has_health():
		shatter()

func _physics_process(delta: float) -> void:
	if not active:
		return
		
	timer += delta
	
	shatter_if_one_health()
	break_if_crushing_player()

	if stage.is_initial():
		animation.play("intro")
		Tools.timer(0.042,"activate_collider",self)
		Tools.timer(0.042,"activate_damage",self)
		Tools.timer(0.126,"deactivate_damage",self)
		stage.next()
	
	elif stage.currently_is(1) and timer > 0.13:
		stage.next()
	
	elif stage.currently_is(2) and timer > 0.4:
		animation.play("idle")
		if speed != 0:
			set_horizontal_speed(speed)
			stage.next()
		else:
			stage.go_to_stage(4)
	
	elif stage.currently_is(3):
		if is_close_to_wall() and is_distance_smaller_than(16.0):
			break_crystal()
	
	elif stage.currently_is(4) and timer > 2.0:
		shatter()
		stage.next()
	
	elif stage.currently_is(5) and timer > 1:
		break_crystal()

func shatter() -> void:
	if not shattered:
		shattered = true
		play_animation("shattered")
		if current_health > 1:
			current_health = 1
		$break.play_rp(0.05,1.85)
	

func break_crystal() -> void:
	if active:
		Log("Breaking Crystal")
		scale.y = 1
		deactivate_collider()
		emit_break_vfx()
		Tools.timer(2.0,"destroy",self)
		deactivate()
		damage.active = false
		$break.play_rp(0.025)
		stage.go_to_stage(6)

func is_player_nearby() -> bool:
	return player_at_left or player_at_right

func is_close_to_wall() -> int:
	if get_facing_direction() < 0:
		if wall_check_left.is_colliding():
			return 1
	elif get_facing_direction() > 0:
		if wall_check_right.is_colliding():
			return -1
	return 0

func raycasts_are_detecting_a_wall() -> bool:
	return wall_check_left.is_colliding() or wall_check_right.is_colliding()

func raycast_distance_to_wall_is_smaller_than(distance) -> bool:
	if abs(distance_to_wall(wall_check_left)) <= distance:
		return player_at_left
	if abs(distance_to_wall(wall_check_right)) <= distance:
		return player_at_right
	return false
	

func is_distance_smaller_than(distance : float) -> bool:
	if is_close_to_wall() < 0:
		if abs(distance_to_wall(wall_check_left)) <= distance:
			return true
	elif is_close_to_wall() > 0:
		if abs(distance_to_wall(wall_check_right)) <= distance:
			return true
	return false

func distance_to_wall(wallcheck) -> float:
	return global_position.x - wallcheck.get_collision_point().x

func activate_damage() -> void:
	dot.activate()
	Tools.timer(0.1,"deactivate_damage",self)

func deactivate_damage() -> void:
	dot.deactivate()

func activate_collider() -> void:
	if stage.current_stage < 5:
		Log("Activating Collider")
		collider.disabled = false
		collider.scale.x = 0
		Tools.tween(collider,"scale",Vector2.ONE,0.16)

func deactivate_collider() -> void:
	Log("Deactivating Collider")
	collider.disabled = true

func emit_break_vfx() -> void:
	animation.set_visible(false)
	#explosion.emitting = true
	remains.emitting = true

func deactivate() -> void:
	active = false

func _on_playerDetector_left_body_entered(_body: Node) -> void:
	player_at_left = true

func _on_playerDetector_right_body_entered(_body: Node) -> void:
	player_at_right = true

func _on_playerDetector_left_body_exited(_body: Node) -> void:
	player_at_left = false

func _on_playerDetector_right_body_exited(_body: Node) -> void:
	player_at_right = false

func _on_zero_health() -> void:
	stage.go_to_stage(5)
	timer = 1
