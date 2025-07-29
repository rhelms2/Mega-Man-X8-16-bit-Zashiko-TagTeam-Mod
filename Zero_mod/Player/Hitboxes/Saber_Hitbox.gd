extends Actor
class_name SaberZeroHitbox

export  var timer: = 0.025
export  var damage: = 1.0
export  var damage_to_bosses: = 1.0
export  var damage_to_weakness: = 1.0
export  var break_guards: = false
export  var break_guard_damage = 0
export  var saber_rehit = 0.1

onready var collision_shape = $collisionShape2D
onready var deflection_shape = $area2D / collisionShape2D
onready var deflect_sound = $deflectSound.stream
onready var saber_effect = preload("res://System/misc/visual_effect.tscn")
onready var effect_material = preload("res://Zero_mod/X8/Sprites/ZeroX8_Material_Shader.tres")
onready var sfx_player: = preload("res://System/misc/sound_effect.tscn")

var canhit: bool = true
var spawn_effect: bool = true
var debug_log: bool = false
var hit_time: = 0.0
var upgraded: bool = false
var deflectable: bool = false
var deflectable_type: int = 0
var only_deflect_weak: bool = true

var saber_effect_names = [
	"Saber", 
	"Rekkyoudan", 
	"Rasetsusen", 
	"Youdantotsu", 
	]

func _ready():
	Event.listen("stage_rotate", self, "destroy")
	

func set_hitbox_corners(upleft: Vector2, downright: Vector2):
	var shape = RectangleShape2D.new()
	var size = downright - upleft
	shape.extents = size / 2
	collision_shape.shape = shape
	deflection_shape.shape = shape
	position = ((upleft + downright) / 2)

func _physics_process(delta: float) -> void :
	timer -= delta
	if timer <= 0:
		destroy()

func destroy() -> void :
	queue_free()

func activate() -> void :
	active = true

func deactivate() -> void :
	active = false

func spawn_saber_effect(target):
	if spawn_effect:
		for saber_name in saber_effect_names:
			if saber_name in name:
				if saber_effect and target:
					var effect_instance = saber_effect.instance()
					effect_instance.material = effect_material
					if "Youdantotsu" in name:
						CharacterManager.set_saberX8_green(effect_instance)
					else:
						CharacterManager.set_saberX8_colors(effect_instance)
					effect_instance.global_position = collision_shape.global_position + ((target.global_position - collision_shape.global_position) / 2)
					get_tree().current_scene.add_child(effect_instance)
					return

func hit(target):
	if active and canhit:
		if saber_rehit != 0:
			if "saber_rehit" in target:
				
				if target.saber_rehit <= 0:
					if target is BossDamage:
						target.saber_rehit = saber_rehit * 2
						Event.emit_signal("saber_has_hit_boss")
					else:
						target.saber_rehit = saber_rehit
					target.damage(damage, self)
					Event.emit_signal("saber_has_hit")
					
					spawn_saber_effect(target)
			else:
				target.damage(damage, self)
				
	
	

func show_damage_values() -> void :
	if debug_log:
		print(str(name) + " DMG: " + str(damage))
		print(str(name) + " BOSS: " + str(damage_to_bosses))
		print(str(name) + " WEAKNESS: " + str(damage_to_weakness))
		print(str(name) + " REHIT: " + str(saber_rehit))

func leave(_target) -> void :
	pass

func deflect(_body) -> void :
	pass

func disable_damage() -> void :
	pass

const SimpleProjectile = preload("res://src/Actors/Enemies/SimpleProjectile.gd")
const GenericProjectile = preload("res://src/Actors/GenericProjectile.gd")

var flippable_projectiles: Array = [
	"Missile", 
]
var not_rotatable_projectiles: Array = [
	"SimpleEnemyProjectile", 
	"EnemyBouncer", 
	"CannonShot", 
]
var exceptions: Array = [
	"BambooMissile", 
	"FirePillar", 
	"DarkArrow", 
	"MantisWave", 
	"LandSpikeProjectile", 
	"WallSpikeProjectile", 
	"GiantMechaniloid"
]
var deflectable_projectiles: Array = [
	"EnemyProjectile", 
]
var projectile_classes: Array = [
	SimpleProjectile, 
	GenericProjectile, 
]
var deflectable_projectiles_weak: Array = [
	"EnemyBouncer", 
	"SimpleEnemyProjectile", 
]

func _destroy_projectile(body) -> void :
	if body.has_method("_OnHit"):
		body._OnHit(self)
	elif body.has_method("destroy"):
		body.destroy()
	else:
		body.queue_free()

func _is_class(node: Node, class_list: Array) -> bool:
	for cls in class_list:
		if node is cls:
			return true
	return false

func _is_in_list(name: String, list: Array) -> bool:
	for entry in list:
		if name.begins_with(entry):
			return true
	return false

func _on_area2D_body_entered(body: Node) -> void :
	if active:
		if body.is_in_group("Enemies") or body.is_in_group("Bosses") or body.is_in_group("Player"):
			return
		if body.is_in_group("Enemy Projectile") or body.is_in_group("Player Projectile"):
			for exception in exceptions:
				if body.name.begins_with(exception):
					return
			if deflectable:
				if body.active:
					react(body)

func react(body: Node) -> void :
	handle_deflection(body)
	

func handle_deflection(body) -> void :
	var is_weak = _is_in_list(body.name, deflectable_projectiles_weak)
	var is_normal = _is_in_list(body.name, deflectable_projectiles) or _is_class(body, projectile_classes)

	if only_deflect_weak and not is_weak and not upgraded:
		return

	var rotate: = not _is_in_list(body.name, not_rotatable_projectiles)
	var flip: = _is_in_list(body.name, flippable_projectiles)

	if deflectable_type == - 1:
		_destroy_projectile(body)
		return

	_deflect_projectile(body, rotate, flip, deflectable_type)

func _deflect_projectile(body, rotate: bool, flip: bool, type: int) -> void :
	var sfx = sfx_player.instance()
	get_tree().current_scene.add_child(sfx)
	sfx.global_position = global_position
	sfx.play_sound(deflect_sound)

	if type == 0:
		var normal = (body.global_position - global_position).normalized()
		var reflected = body.velocity - 2.0 * body.velocity.dot(normal) * normal
		body.velocity = reflected
	else:
		body.velocity *= - type
		if upgraded:
			body.damage *= 1.2
		body.damage_to_bosses = body.damage
		body.damage_to_weakness = body.damage
		body.remove_from_group("Enemy Projectile")
		body.add_to_group("Player Projectile")

	if "damage_disabled" in body:
		body.damage_disabled = true
	if body.has_node("DamageOnTouch"):
		body.get_node("DamageOnTouch").active = false
	body.set_collision_layer(4)

	if rotate:
		body.rotation = body.velocity.angle()
	if flip:
		if body.has_node("animatedSprite"):
			body.get_node("animatedSprite").scale.x = 1
