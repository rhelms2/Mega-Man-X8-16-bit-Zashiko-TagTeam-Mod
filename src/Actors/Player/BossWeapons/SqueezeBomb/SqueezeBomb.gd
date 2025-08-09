extends SimplePlayerProjectile

export  var duration: = 3.0
export  var move_speed: = 100.0
export  var endanim_name: = "expire"
export  var deflectable: = true
export  var flash_duration: = 0.25
export  var foward_start: = 16.0
var target_list: Array
var interval: = 0.064
var damage_timer: = 0.0
const continuous_damage: = true
const bypass_shield: = true
onready var animation: = AnimationController.new($animatedSprite)
onready var tween: = TweenController.new(self, false)
onready var point: AudioStreamPlayer2D = $point
onready var sound: AudioStreamPlayer2D = $sound

signal projectile_started

func _ready() -> void :
	Event.connect("gigacrash", self, "end")

func _Setup() -> void :
	emit_signal("projectile_started")
	modulate = Color(10, 10, 10, 1)
	tween.attribute("modulate", Color.white, flash_duration)
	point.play()
	sound.play()
	global_position.x += foward_start * get_facing_direction()
	tween.method("set_horizontal_speed", move_speed * get_facing_direction(), 0.0, duration - 0.5)
	

func _Update(delta: float) -> void :
	if not animation.is_currently(endanim_name):
		damage_timer += delta
		if damage_timer > interval:
			damage_targets_in_list()
			damage_timer = 0.0
	if attack_stage == 0 and timer > duration:
		end()
		
	elif attack_stage == 1 and timer > 1:
		destroy()

func end():
	animatedSprite.play(endanim_name)
	disable_damage()
	next_attack_stage()
	
func enable_damage():
	$collisionShape2D.set_deferred("disabled", false)
	var extra_collider: = get_node_or_null("collisionShape2D2")
	if extra_collider != null:
		extra_collider.set_deferred("disabled", false)
func disable_damage():
	$collisionShape2D.set_deferred("disabled", true)
	var extra_collider: = get_node_or_null("collisionShape2D2")
	if extra_collider != null:
		extra_collider.set_deferred("disabled", true)

func damage_targets_in_list() -> void :
	if target_list.size() > 0:
		for body in target_list:
			if is_instance_valid(body):
				body.damage(damage, self)

func _DamageTarget(body) -> int:
	if not body in target_list:
		target_list.append(body)
	return 0
	
func deflect(_d) -> void :
	pass

func _OnHit(_target_remaining_HP) -> void :
	pass

func _OnDeflect() -> void :
	if deflectable:
		disable_damage()
		tween.reset()
		stop()
		animatedSprite.play(endanim_name)
		Tools.timer(3, "destroy", self)

func leave(_body) -> void :
	if _body in target_list:
		target_list.erase(_body)

func projectile_setup(_d, _f):
	pass

var collider_distance: = 0.0
func set_direction(new_direction):
	Log("Seting direction: " + str(new_direction))
	facing_direction = new_direction
	if not animatedSprite:
		animatedSprite = get_node("animatedSprite")
	animatedSprite.scale.x = new_direction
	var collider = $collisionShape2D
	collider_distance = collider.position.x
	collider.position.x = collider_distance * new_direction
