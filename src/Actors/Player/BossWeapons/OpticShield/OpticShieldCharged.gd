extends SimplePlayerProjectile

const continuous_damage: bool = true
const bypass_shield: bool = true
const destroyer: bool = true

onready var thunder: AudioStreamPlayer2D = $thunder
onready var animated_sprite_2: AnimatedSprite = $animatedSprite2
onready var light: Light2D = $light
onready var deflect_hitbox: = $area2D / collisionShape2D

var target_list: Array
var interval: float = 0.064
var mid_animation_time: float = 0.12
var end_animation_time: float = 1.45
var deflectable: bool = false


func _DamageTarget(body) -> int:
	target_list.append(body)
	return 0

func _OnHit(_target_remaining_HP) -> void :
	pass

func _OnDeflect() -> void :
	pass

func _Setup() -> void :
	Tools.timer(mid_animation_time, "mid_animation", self)
	Tools.timer(end_animation_time, "end_animation", self)
	thunder.play_rp(0.07, 0.85)
	animatedSprite.playing = true
	animated_sprite_2.playing = true
	next_attack_stage()

func mid_animation() -> void :
	animatedSprite.play("loop")
	animated_sprite_2.play("loop")

func end_animation() -> void :
	deflect_hitbox.disabled = true
	animatedSprite.play("end")
	animated_sprite_2.play("end")
	light.dim(0.5, 0)
	next_attack_stage()

func _Update(_delta: float) -> void :
	if attack_stage == 1:
		if timer > interval:
			damage_targets_in_list()
			timer = 0.0
			Event.emit_signal("screenshake", 0.2)
	
	elif attack_stage == 2:
		disable_damage()
		if timer > 0.5:
			disable_visuals()
			next_attack_stage()
	
	if ending and timer > 1.2:
		destroy()

func damage_targets_in_list() -> void :
	if target_list.size() > 0:
		for body in target_list:
			if is_instance_valid(body):
				body.damage(damage, self)

func leave(_body) -> void :
	if _body in target_list:
		target_list.erase(_body)

func _on_area2D_body_entered(body: Node) -> void :
	if active:
		if body.is_in_group("Enemies") or body.is_in_group("Bosses"):
			return
		if deflectable:
			if body.active:
				react(body)

func react(body: Node) -> void :
	call_deferred("deflect_projectile", body)

func deflect_projectile(body):
	if body.is_in_group("Enemy Projectile"):
		if body.has_method("_OnHit"):
			body._OnHit(self)
			return
		body.destroy()
