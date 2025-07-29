extends BossWeapon

export  var horizontal_speed: = 800.0
var light_tween
var charges_left: = 0
var dash_timer: = 0.0
var charged_timer = Timer.new()
var cooldown_timer = Timer.new()
var safe_conclusion: = false
const dash_duration: = 0.12
const ability_duration: = 1.0

export  var fire_action: = "fire"

onready var light: Light2D = get_node_or_null("../../light")
onready var weapon_stasis: Node2D = $"../../WeaponStasis"
onready var _s = weapon_stasis.connect("interrupted", self, "stasis_interrupt")

func setup_light():
	light = get_node_or_null("../../light")

func _ready() -> void :
	set_physics_process(false)
	charged_timer.connect("timeout", self, "charge_expire")
	charged_timer.wait_time = ability_duration
	charged_timer.one_shot = true
	add_child(charged_timer)
	call_deferred("setup_light")

func fire(charge_level) -> void :
	if charges_left > 0:
		dash_forward()
	else:
		.fire(charge_level)

func fire_regular() -> void :
	.fire_regular()
	light_for_pitchblack()
	dim_light_for_pitchblack()

func fire_charged() -> void :
	charges_left = 3
	charged_timer.start()
	dash_forward()

func dash_forward() -> void :
	var dir: = 0
	if Input.is_action_pressed("move_left"):
		dir = - 1
	elif Input.is_action_pressed("move_right"):
		dir = 1
	if dir != 0:
		character.set_direction(dir)
	Log("Starting dash")
	safe_conclusion = false
	play(weapon.charged_sound)
	weapon_stasis.ExecuteOnce()
	weapon_stasis.play_animation_once("dash")
	reduce_dash_charges()
	make_character_invisible()
	light_for_pitchblack()
	dim_light_for_pitchblack()
	dash_timer = 0
	set_physics_process(true)
	character.add_invulnerability(name)
	var shot = instantiate_projectile(weapon.charged_shot)
	set_position_as_character_position(shot)
	shot.scale.x = character.get_facing_direction()
	if dir != 0:
		shot.scale.x = dir
	if timer == 0:
		start_cooldown()

func _physics_process(delta: float) -> void :
	if dash_timer < dash_duration:
		character.set_horizontal_speed(horizontal_speed * character.get_facing_direction())
		dash_timer += delta
		if charges_left > 0 and Input.is_action_just_pressed(fire_action):
			buster.manual_save_shot()
			Log("manually saving shot")
	else:
		interrupt()

func charge_expire() -> void :
	charges_left = 0

func interrupt() -> void :
	if weapon_stasis.executing:
		safe_conclusion = true
		weapon_stasis.EndAbility()
	end()
	Log("concluded")

func stasis_interrupt() -> void :
	if not safe_conclusion:
		end()
		Log("interrupted")

var post_thunder_timer: Timer

func end() -> void :
	make_character_visible()
	character.set_horizontal_speed(0)
	set_physics_process(false)
	character.add_invulnerability("PostThunder")
	if is_instance_valid(post_thunder_timer):
		post_thunder_timer.queue_free()
	post_thunder_timer = Tools.timer_r(0.25, "remove_invulnerability", character, "PostThunder")
	character.call_deferred("remove_invulnerability", name)
	character.start_dashfall()

func light_for_pitchblack() -> void :
	if light != null:
		light.light(0.9, Vector2(5, 3), Color.aqua)

func dim_light_for_pitchblack() -> void :
	if light != null:
		light.dim(1)

func reduce_dash_charges() -> void :

	charges_left = clamp(charges_left - 1, 0, 2)

func start_cooldown() -> void :
	if cooldown:
		cooldown.kill()
	timer = weapon.cooldown
	if charges_left > 0:
		timer = 0.1201
	Log("Setting cooldown to " + str(timer))
	cooldown = create_tween()
	cooldown.tween_property(self, "timer", 0, timer)
	cooldown.tween_callback(self, "buster_notify_cooldown_end")

func has_ammo() -> bool:
	if charges_left > 0:
		return true
		
	return .has_ammo()
