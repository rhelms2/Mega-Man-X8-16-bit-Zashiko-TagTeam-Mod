extends KinematicBody2D
class_name GenericProjectile

export  var active: bool = false
export  var debug_logs: bool = false
export  var damage: float = 1.0
export  var damage_to_bosses: float = 1.0
export  var damage_to_weakness: float = 1.0
export  var time_off_screen: float = 0.05
export  var break_guards: bool = false
export  var break_guard_damage: float = 1.0
export  var rotate_to_velocity: bool = false

onready var visibility: VisibilityNotifier2D = $visibilityNotifier2D
onready var animatedSprite: AnimatedSprite = $animatedSprite

var facing_direction: int = 1
var last_message
var velocity: Vector2 = Vector2.ZERO
var timer: float = 0.0
var attack_stage: int = 0
var creator: Node2D
var off_screen_timer: float = 0.0
var damage_ot: Node2D

signal hit(target)
signal deflect(deflector)
signal projectile_end(projectile)
signal zero_health


func _ready() -> void :
	damage_ot = get_node_or_null("DamageOnTouch")
	check_group_and_alert()
	connect_disable_unneeded_object()
	visibility.connect("screen_exited", self, "_OnScreenExit")

func connect_disable_unneeded_object() -> void :
	Event.listen("disable_unneeded_objects", self, "destroy")

func _physics_process(delta: float) -> void :
	if active:
		timer += delta
		handle_off_screen(delta)
		_Update(delta)
		process_movement()
		if velocity.length() > 0 and rotate_to_velocity:
			animatedSprite.rotation_degrees = velocity.angle()

func initialize(direction) -> void :
	Log("Initializing")
	activate()
	reset_timer()
	set_direction(direction)
	_Setup()

func set_creator(_creator: Node2D) -> void :
	
	creator = _creator

func process_movement() -> void :
	velocity = move_and_slide_with_snap(velocity, Vector2.ZERO, Vector2.UP, true)

func activate() -> void :
	Log("Activating")
	active = true

func reset_timer() -> void :
	timer = 0

func next_attack_stage() -> void :
	attack_stage += 1
	reset_timer()
	Log("Entering Attack Stage " + str(attack_stage))

func previous_attack_stage() -> void :
	attack_stage -= 1
	reset_timer()
	Log("Entering Attack Stage " + str(attack_stage))

func go_to_attack_stage(stage: int) -> void :
	attack_stage = stage
	reset_timer()
	Log("Entering Attack Stage " + str(attack_stage))
	
func set_direction(new_direction: int) -> void :
	Log("Seting direction: " + str(new_direction))
	facing_direction = new_direction
	if not animatedSprite:
		animatedSprite = get_node("animatedSprite")
	animatedSprite.scale.x = new_direction

func get_direction() -> int:
	return facing_direction

func get_facing_direction() -> int:
	return get_direction()

func deactivate() -> void :
	Log("Deactivating")
	active = false

func deflect(_body) -> void :
	_OnDeflect()
	emit_signal("deflect", _body)

func hit(_body) -> void :
	if active:
		Log("Hit " + _body.name)
		var target_hp = _DamageTarget(_body)
		_OnHit(target_hp)

func _Setup() -> void :
	pass

func _DamageTarget(_body) -> int:
	return _body.damage(damage, self)

func _OnHit(_target_remaining_HP) -> void :
	disable_visuals()

func _OnDeflect() -> void :
	Log("Deflected")
	disable_visuals()

func _Update(_delta: float) -> void :
	pass

func _OnScreenExit() -> void :
	Log("Exited Screen")
	destroy()

func handle_off_screen(delta: float) -> void :
	if off_screen_timer > time_off_screen:
		Log("Off screen for too long, destroying")
		destroy()
	elif not visibility.is_on_screen():
		off_screen_timer += delta
	else:
		off_screen_timer = 0

func disable_visuals() -> void :
	Log("Disabling Visuals")
	$animatedSprite.visible = false
	destroy()

func disable_damage() -> void :
	if damage_ot != null:
		damage_ot.deactivate()

func enable_visuals() -> void :
	Log("Enabling Visuals")
	$animatedSprite.visible = true

func leave(_body) -> void :
	pass

func destroy() -> void :
	Log("Being Destroyed")
	emit_signal("projectile_end", self)
	queue_free()

func set_horizontal_speed(speed: float) -> void :
	velocity.x = speed

func add_horizontal_speed(speed: float) -> void :
	velocity.x = velocity.x + speed
	
func get_horizontal_speed() -> float:
	return velocity.x

func get_vertical_speed() -> float:
	return velocity.y
	
func add_vertical_speed(speed: float) -> void :
	velocity.y = velocity.y + speed

func set_vertical_speed(speed: float) -> void :
	velocity.y = speed

func check_group_and_alert() -> void :
	if not is_in_group("Player Projectile") and not is_in_group("Enemy Projectile"):
		
		pass

func Log(msg) -> void :
	if debug_logs:
		if not last_message == str(msg):
			if is_instance_valid(creator):
				print(creator.name + "." + name + ": " + str(msg))
			else:
				print(name + ": " + str(msg))
			last_message = str(msg)

func listen(event_name: String, listener, method_to_call: String) -> void :
	var error_code = connect(event_name, listener, method_to_call)
	if error_code != 0:
		
		
		pass

func process_gravity(_delta: float, gravity: float = 900.0, max_fall_speed: float = 400.0) -> void :
	add_vertical_speed(gravity * _delta)
	if get_vertical_speed() > max_fall_speed:
		set_vertical_speed(max_fall_speed)
