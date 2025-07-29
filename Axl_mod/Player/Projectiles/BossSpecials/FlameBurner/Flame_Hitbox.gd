extends Actor

const continuous_damage: bool = true

export  var timer: float = 0.025
export  var damage: float = 1.0
export  var damage_to_bosses: float = 1.0
export  var damage_to_weakness: float = 1.0
export  var break_guards: bool = false
export  var break_guard_damage: float = 0

onready var collision_shape: = $collisionShape2D
onready var animation: = get_node("animatedSprite")

var target_list: Array
var interval: float = 0.001
var damage_timer: float = 0.0
var alpha: float = 1.0
var rotated: bool = false

var deflectable_projectiles: Array = [
	"EnemyBouncer", 
	"SimpleEnemyProjectile", 
]


func _ready():
	animatedSprite.connect("animation_finished", self, "_on_animation_finished")

func _on_animation_finished() -> void :
	queue_free()

func activate() -> void :
	active = true

func deactivate() -> void :
	active = false

func _physics_process(delta: float) -> void :
	if not rotated:
		rotated = true
		if animation.animation == "aura_flame":
			animation.rotation_degrees = rand_range( - 20, 20)
	if animation.animation == "aura_flame":
		if animation.frame > 0:
			position.y -= delta * rand_range(25, 50)
		alpha -= delta * 2
	if animation.animation == "small_flame":
		if animation.frame >= 6:
			position.y -= delta * rand_range(60, 100)
		alpha -= delta * 3
	animation.modulate = Color(1, 1, 1, alpha)
	damage_timer += delta
	if damage_timer > interval:
		damage_targets_in_list()
		damage_timer = 0.0

func damage_targets_in_list() -> void :
	if target_list.size() > 0:
		for body in target_list:
			if is_instance_valid(body):
				body.damage(damage, self)

func hit(_body) -> void :
	if active:
		var target_hp = _DamageTarget(_body)
		_OnHit(target_hp)

func deflect(_body) -> void :
	pass

func leave(_body) -> void :
	if _body in target_list:
		target_list.erase(_body)

func _DamageTarget(body) -> int:
	target_list.append(body)
	return 0

func _OnHit(_target_remaining_HP) -> void :
	pass

func _OnDeflect() -> void :
	pass

func _on_area2D_body_entered(body: Node) -> void :
	if active:
		if body.is_in_group("Enemies") or body.is_in_group("Bosses") or body.is_in_group("Player"):
			return











