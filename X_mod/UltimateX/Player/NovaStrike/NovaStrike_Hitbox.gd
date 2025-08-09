extends Actor
class_name NovaStrikeHitbox

var debug_log: bool = false

var hit_time: = 0.0
export  var timer: = 0.025
onready var collision_shape = $collisionShape2D
onready var deflection_shape = $area2D / collisionShape2D

export  var damage: = 1.0
export  var damage_to_bosses: = 1.0
export  var damage_to_weakness: = 1.0
export  var break_guards: = false
export  var break_guard_damage = 0
export  var rehit = 0.1
var upgraded: bool = true
var deflectable: bool = true

func _ready():
	pass
	
func set_hitbox_corners(upleft: Vector2, downright: Vector2):
	var shape = RectangleShape2D.new()
	var size = downright - upleft
	shape.extents = size / 2
	collision_shape.shape = shape
	deflection_shape.shape = shape
	position = (upleft + downright) / 2

func _physics_process(delta: float) -> void :
	timer -= delta
	if timer <= 0:
		queue_free()
	
func activate() -> void :
	active = true
	
func deactivate() -> void :
	active = false

func hit(target):
	if active:
		
		if rehit != 0:
			if "saber_rehit" in target:
				if target.saber_rehit <= 0:
					if target is BossDamage:
						target.saber_rehit = rehit * 2
					else:
						target.saber_rehit = rehit
						
					target.damage(damage, self)
					show_damage_values()

func show_damage_values():
	if debug_log:
		print(str(name) + " DMG: " + str(damage))
		print(str(name) + " BOSS: " + str(damage_to_bosses))
		print(str(name) + " WEAKNESS: " + str(damage_to_weakness))
		print(str(name) + " REHIT: " + str(rehit))

func leave(_target):
	pass

func deflect(_body) -> void :
	pass
		
func disable_damage():
	pass

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

