extends BossWeapon
const dash_duration: = 0.285
const recoil_duration: = 0.25
var executing: = false
var dash_timer: = 0.0
var diagonal: = false
export  var dash_speed: = Vector2(200, 200)
var horizontal_speed: = 0.0
var vertical_speed: = 0.0
var charged: = false
var ricochet_times: = 0
var time_since_last_ricochet: = 0.0
var recoil: = 0.0
var recoil_tween: SceneTreeTween
var shot
var light_tween: SceneTreeTween
var debug_timescalled: = 0
onready var light: Light2D = get_node_or_null("../../light")
onready var airdash: Node2D = $"../../AirDash"
onready var weapon_stasis: Node2D = $"../../WeaponStasis"

const speed_limit: = Vector2(800, 500)

func setup_light():
	light = get_node_or_null("../../light")
	
func _ready() -> void :
	var _s = weapon_stasis.connect("interrupted", self, "end")
	_s = Event.connect("weapon_select_left", self, "manual_interrupt")
	_s = Event.connect("weapon_select_right", self, "manual_interrupt")
	_s = Event.connect("weapon_select_buster", self, "manual_interrupt")
	_s = Event.connect("select_weapon", self, "manual_interrupt")
	call_deferred("setup_light")

func is_cooling_down() -> bool:
	return timer > 0 or weapon_stasis.executing
	
func fire_regular() -> void :
	play(weapon.sound)
	character.firedash_signal()
	charged = false
	setup()
	shot = instantiate_projectile(weapon.regular_shot)

func fire_charged() -> void :
	play(weapon.charged_sound)
	character.firedash_signal()
	charged = true
	setup()
	character.add_invulnerability(name)
	shot = instantiate_projectile(weapon.charged_shot)

func setup() -> void :
	executing = true
	debug_timescalled = 0
	weapon_stasis.ExecuteOnce()
	weapon_stasis.play_animation_once("dash")
	dash_timer = 0.01
	vertical_speed = 0
	ricochet_times = 0
	time_since_last_ricochet = 0
	diagonal = false
	decide_vertical_speed()
	decide_horizontal_speed()
	buster.disable_animation_layer()
	character.animatedSprite.modulate = Color(1, 1, 1, 0.01)
	light_for_pitchblack()

func decide_horizontal_speed() -> void :
	var dir: = 0
	if Input.is_action_pressed("move_left") or Input.is_action_pressed("left_emulated"):
		dir = - 1
	elif Input.is_action_pressed("move_right") or Input.is_action_pressed("right_emulated"):
		dir = 1
	else:
		dir = character.get_facing_direction()
	
	character.set_direction(dir)
	var speed = dash_speed.x
	if charged:
		speed = dash_speed.x + 60
	if not diagonal:
		set_dash_horizontal_speed(speed * 1.17 * dir)
	else:
		set_dash_horizontal_speed(speed * dir)

func decide_vertical_speed() -> void :
	if Input.is_action_pressed("move_down") or Input.is_action_pressed("down_emulated"):
		vertical_speed = (dash_speed.y)
		diagonal = true
	elif Input.is_action_pressed("move_up") or Input.is_action_pressed("up_emulated"):
		vertical_speed = ( - dash_speed.y)
		diagonal = true

func set_dash_horizontal_speed(value) -> void :
	horizontal_speed = value

func _physics_process(delta: float) -> void :
	if active:
		time_since_last_ricochet += delta
		if dash_timer > 0:
			if not weapon_stasis.executing:
				interrupt()
			character.set_vertical_speed(vertical_speed)
			character.set_horizontal_speed(horizontal_speed)
			dash_timer += delta
			check_for_wallhit()
			if end_condition():
				interrupt()
		elif recoil > 0:
			recoil += delta
			if recoil > recoil_duration:
				interrupt()

func end_condition() -> bool:
	if charged:
		if diagonal:
			return dash_timer > dash_duration * 1.45
		return dash_timer > dash_duration * 1.75
		
	if diagonal:
		return dash_timer > dash_duration * 0.65
	return dash_timer > dash_duration

func manual_interrupt(_d = null) -> void :
	if executing:
		interrupt()

func interrupt() -> void :
	weapon_stasis.EndAbility()
	character.animatedSprite.frame = 9
	end()
	
func end() -> void :
	character.animatedSprite.modulate = Color(1, 1, 1, 1)
	if is_instance_valid(shot):
		shot.finish()
	dash_timer = 0
	recoil = 0
	dim_light_for_pitchblack()
	character.start_dashfall()
	Tools.timer_p(0.25, "remove_invulnerability", character, name)
	executing = false


func _recoil() -> void :
	weapon_stasis.play_animation_once("damage_resist")
	character.animatedSprite.frame = 9
	character.animatedSprite.modulate = Color(1, 1, 1, 1)
	shot.finish()
	horizontal_speed = - horizontal_speed / 4
	character.set_horizontal_speed(horizontal_speed)
	dash_timer = 0
	recoil_tween = create_tween()
	recoil_tween.tween_method(character, "set_vertical_speed", - 280.0, 0.0, recoil_duration)
	recoil = 0.01
	visual_explosion()
	if cooldown:
		cooldown.kill()
	timer = 0
	buster_notify_cooldown_end()

func check_for_wallhit() -> void :
	if not charged:
		return
	var speed = Vector2(horizontal_speed, vertical_speed)
	var buildup = clamp(1 + (time_since_last_ricochet * 0.75), 1.1, 1.2)
	if character.is_in_reach_for_walljump() == - 1 and speed.x <= 0:
		character.set_direction(1)
		horizontal_speed = - horizontal_speed * buildup
		vertical_speed = vertical_speed * buildup
		visual_explosion()
		reset_dash_duration()
		switch_direction()
	
	elif character.is_in_reach_for_walljump() == 1 and speed.x >= 0:
		character.set_direction( - 1)
		horizontal_speed = - horizontal_speed * buildup
		vertical_speed = vertical_speed * buildup
		visual_explosion()
		reset_dash_duration()
		switch_direction()
	
	if character.is_on_floor() and speed.y > 0:
		vertical_speed = - vertical_speed * buildup
		horizontal_speed = horizontal_speed * buildup
		visual_explosion()
		reset_dash_duration()
		
	elif character.is_on_ceiling() and speed.y < 0:
		vertical_speed = - vertical_speed * buildup
		horizontal_speed = horizontal_speed * buildup
		visual_explosion()
		reset_dash_duration()
	horizontal_speed = clamp(horizontal_speed, - speed_limit.x, speed_limit.x)
	vertical_speed = clamp(vertical_speed, - speed_limit.y, speed_limit.y)

func switch_direction() -> void :
	if Input.is_action_pressed("move_down"):
		if vertical_speed == 0:
			vertical_speed = abs(horizontal_speed / 2)
			diagonal = true
		elif vertical_speed < 0:
			vertical_speed = 0
			diagonal = false
	elif Input.is_action_pressed("move_up"):
		if vertical_speed == 0:
			vertical_speed = - abs(horizontal_speed / 2)
			diagonal = true
		elif vertical_speed > 0:
			vertical_speed = 0
			diagonal = false

func switch_direction_on_ceiling() -> void :
	if Input.is_action_pressed("move_down"):
		if vertical_speed == 0:
			vertical_speed = abs(horizontal_speed / 2)
			diagonal = true
		elif vertical_speed < 0:
			vertical_speed = 0
			diagonal = false
	elif Input.is_action_pressed("move_up"):
		if vertical_speed == 0:
			vertical_speed = - abs(horizontal_speed / 2)
			diagonal = true
		elif vertical_speed > 0:
			vertical_speed = 0
			diagonal = false

func visual_explosion() -> void :
	if shot.has_method("explode"):
		shot.call_deferred("explode")
	pass
	
func instantiate(scene: PackedScene) -> Node2D:
	var instance = scene.instance()
	character.call_deferred("add_child", instance, true)
	instance.set_position(Vector2.ZERO)
	instance.connect("finish", self, "_recoil")
		
	return instance

func reset_dash_duration() -> void :
	if ricochet_times <= 4:
		dash_timer = 0.01
	else:
		dash_timer = dash_timer * 0.95
	ricochet_times += 1
	time_since_last_ricochet = 0

func light_for_pitchblack() -> void :
	if light != null:
		light.light(1, Vector2(5, 3), Color.lightsalmon)

func dim_light_for_pitchblack() -> void :
	if light != null:
		light.dim(4)
	
