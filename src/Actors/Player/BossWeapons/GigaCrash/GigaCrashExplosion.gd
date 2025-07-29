extends SimplePlayerProjectile

const continuous_damage: = true

export  var duration: float = 2.0

onready var smoke: Particles2D = $smoke
onready var explosion_particles: Particles2D = $explosionParticles
onready var black: Sprite = $black
onready var red: = $red_bg

var target_list: Array
var interval: float = 0.064
var damage_timer: float = 0.0

func _DamageTarget(body) -> int:
	target_list.append(body)
	return 0

func _OnHit(_target_remaining_HP) -> void :
	pass

func _OnDeflect() -> void :
	pass

func _Setup() -> void :
	$sound.play()
	Event.emit_signal("gigacrash")

func _Update(delta: float) -> void :
	damage_timer += delta
	if damage_timer > interval:
		damage_targets_in_list()
		damage_timer = 0.0
	
	if attack_stage == 0 and timer > duration:
		explosion_particles.emitting = false
		smoke.emitting = false
		disable_damage()
		Tools.timer(0.15, "start_fade", self)
		next_attack_stage()
		
	elif attack_stage == 2 and timer > 0.5:
		destroy()

func _process(_delta: float) -> void :
	global_position = GameManager.camera.get_camera_screen_center()

func start_fade() -> void :
	var tween = create_tween().set_parallel()
	tween.tween_property(black, "modulate", Color(1, 1, 1, 0), 0.25)
	tween.tween_property(red, "modulate", Color(1, 1, 1, 0), 0.25)

func damage_targets_in_list() -> void :
	if target_list.size() > 0:
		for body in target_list:
			if is_instance_valid(body):
				body.damage(damage, self)

func deal_a_third_hp_damage(body: Panda):
	
	var one_third = body.max_health / 3
	body.damage(one_third, self)

func leave(_body) -> void :
	if _body in target_list:
		target_list.erase(_body)
