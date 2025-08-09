extends SimplePlayerProjectile

const continuous_damage: bool = true

onready var animation: AnimationController = AnimationController.new($animatedSprite)
onready var sound: AudioStreamPlayer2D = $sound
onready var light: Light2D = $light

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
	animation.play("intro")
	sound.play_rp(0.05, 0.725)
	light.light(0.7, Vector2(5, 3), Color.gold)

func _Update(delta: float) -> void :
	if not animation.is_currently("loop_end"):
		flicker()
		damage_timer += delta
		if damage_timer > interval:
			damage_targets_in_list()
			damage_timer = 0.0
	
	if attack_stage == 0 and animation.has_finished_last():
		animatedSprite.play("loop")
		next_attack_stage()
	
	elif attack_stage == 1 and timer > 0.45:
		animatedSprite.play("loop_end")
		light.dim(0.85, 0)
		sound.fade_out(3)
		disable_damage()
		next_attack_stage()
		
	elif attack_stage == 2 and timer > 1:
		destroy()

func flicker() -> void :
	animatedSprite.z_index = round(17 * inverse_lerp( - 1, 1, cos(timer * 100)))

func damage_targets_in_list() -> void :
	if target_list.size() > 0:
		for body in target_list:
			if is_instance_valid(body):
				body.damage(damage, self)

func leave(_body) -> void :
	if _body in target_list:
		target_list.erase(_body)
