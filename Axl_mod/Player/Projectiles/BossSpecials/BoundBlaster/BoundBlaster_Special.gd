extends SpecialAbilityAxl

const SimpleProjectile = preload("res://src/Actors/Enemies/SimpleProjectile.gd")
const GenericProjectile = preload("res://src/Actors/GenericProjectile.gd")

onready var player_damage: = character.get_node("Damage")
onready var player_walk: = character.get_node("Walk")
onready var player_jump: = character.get_node("Jump")
onready var player_walljump: = character.get_node("WallJump")
onready var player_hover: = character.get_node("Hover")
onready var player_wallslide: = character.get_node("WallSlide")
onready var player_dash: = character.get_node("Dash")
onready var player_airdash: = character.get_node("AirDash")
onready var player_dashjump: = character.get_node("DashJump")
onready var player_dashwalljump: = character.get_node("DashWallJump")
onready var player_dodge: = character.get_node("Dodge")
onready var player_fall: = character.get_node("Fall")
onready var collision_shape = $collisionShape2D
onready var deflection_shape = $area2D / collisionShape2D
onready var deflect_sound = $deflectSound
onready var create_sfx: = $sfx_create
onready var sfx: = $sfx

var active: bool = false
var infinite_shield: bool = false
var shield_time: float = 16.0
var shield_timer: float = 0.0
var shield_blink_time: float = 0.0125
var shield_blink_timer: float = 0.0
var damage_reduction: float = 0.5
var speed_factor: float = 0.85
var height_factor: float = 0.95
var gravity_factor: float = 1.25
var default_gravity: float = 900.0
var rotation_speed: float = 30.0

var player_knockback: bool = false
var player_reduction: float = 1.0
var walk_speed: float
var jump_speed: float
var walljump_speed: float
var hover_speed: float
var wallslide_speed: float
var dash_speed: float
var airdash_speed: float
var dashjump_speed: float
var dashwalljump_speed: float
var dodge_speed: float
var fall_speed: float
var dashfall_speed: float
var jump_time: float
var dashjumptime: float
var walljumptime: float
var dashwalljump_time: float

var damage: float = 1.0
var damage_to_bosses: float = 1.0
var damage_to_weakness: float = 5.0

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
]
var deflectable_projectiles: Array = [
	"EnemyProjectile", 
]
var projectile_classes: Array = [
	SimpleProjectile, 
	GenericProjectile, 
]

func _ready() -> void :
	Event.connect("enemy_kill", self, "destroy")
	character.connect("zero_health", self, "deactivate")
	connect_animation_finished_event()

func deactivate() -> void :
	unset_defense_buff()
	sfx.stop()
	queue_free()

func destroy(enemy) -> void :
	if typeof(enemy) == TYPE_STRING:
		if enemy == "boss":
			go_to_attack_stage(10)

func initialize() -> void :
	Tools.timer(animation_time, "set_stage", self)

func set_stage() -> void :
	attack_stage = 1

func _physics_process(delta: float) -> void :
	._physics_process(delta)
	if attack_stage == 1:
		play_animation("shield_start")
		create_sfx.play()
		animatedSprite.show()
		next_attack_stage()
		
	elif attack_stage == 2 and has_finished_last_animation():
		play_animation("shield_loop")
		sfx.play()
		set_defense_buff()
		active = true
		next_attack_stage()
		
	elif attack_stage == 3:
		animatedSprite.rotation_degrees += rotation_speed * character.get_facing_direction()
		shield_timer += delta
		handle_shield_blink(delta)
		if shield_timer >= shield_time:
			if infinite_shield:
				go_to_attack_stage(3)
			else:
				go_to_attack_stage(10)
	
	elif attack_stage == 10:
		play_animation("shield_end")
		animatedSprite.show()
		animatedSprite.speed_scale = 1
		create_sfx.play()
		sfx.stop()
		unset_defense_buff()
		active = false
		next_attack_stage()
		
	elif attack_stage == 11 and has_finished_last_animation() and timer > 1.5:
		EndAbility()

func handle_shield_blink(delta) -> void :
	shield_blink_timer += delta
	if shield_time - shield_timer <= 3:
		shield_blink_time = 0.0375
	if shield_time - shield_timer <= 2:
		shield_blink_time = 0.05
	if shield_time - shield_timer <= 1:
		shield_blink_time = 0.0625
	if infinite_shield:
		shield_blink_time = 0.0125
	if shield_blink_timer >= shield_blink_time:
		shield_blink_timer = 0
		animatedSprite.visible = not animatedSprite.visible

func set_defense_buff() -> void :
	backup_original_values()
	player_damage.prevent_knockbacks = true
	player_damage.extra_damage_reduction = damage_reduction
	character.spike_invincibility = true
	
	player_walk.horizontal_velocity *= speed_factor
	player_jump.horizontal_velocity *= speed_factor
	player_walljump.horizontal_velocity *= speed_factor
	player_hover.horizontal_velocity *= speed_factor
	player_dash.horizontal_velocity *= speed_factor
	player_airdash.horizontal_velocity *= speed_factor
	player_dashjump.horizontal_velocity *= speed_factor
	player_dashwalljump.horizontal_velocity *= speed_factor
	player_dodge.horizontal_velocity *= speed_factor
	player_fall.horizontal_velocity *= speed_factor
	player_fall.dash_momentum *= speed_factor
	player_wallslide.jump_velocity *= gravity_factor
	
	player_jump.max_jump_time *= height_factor
	player_walljump.max_jump_time *= height_factor
	player_dashjump.max_jump_time *= height_factor
	player_dashwalljump.max_jump_time *= height_factor
	
	player_walk.default_gravity *= gravity_factor
	player_jump.default_gravity *= gravity_factor
	player_walljump.default_gravity *= gravity_factor
	player_hover.default_gravity *= gravity_factor
	player_wallslide.default_gravity *= gravity_factor
	player_dash.default_gravity *= gravity_factor
	player_airdash.default_gravity *= gravity_factor
	player_dashjump.default_gravity *= gravity_factor
	player_dashwalljump.default_gravity *= gravity_factor
	player_dodge.default_gravity *= gravity_factor
	player_fall.default_gravity *= gravity_factor

func unset_defense_buff() -> void :
	restore_original_values()
	character.spike_invincibility = false
	collision_shape.disabled = true
	deflection_shape.disabled = true

func restore_original_values() -> void :
	player_damage.prevent_knockbacks = player_knockback
	player_damage.extra_damage_reduction = player_reduction
	
	player_walk.horizontal_velocity = walk_speed
	player_jump.horizontal_velocity = jump_speed
	player_walljump.horizontal_velocity = walljump_speed
	player_hover.horizontal_velocity = hover_speed
	player_dash.horizontal_velocity = dash_speed
	player_airdash.horizontal_velocity = airdash_speed
	player_dashjump.horizontal_velocity = dashjump_speed
	player_dashwalljump.horizontal_velocity = dashwalljump_speed
	player_dodge.horizontal_velocity = dodge_speed
	player_fall.horizontal_velocity = fall_speed
	player_fall.dash_momentum = dashfall_speed
	player_wallslide.jump_velocity = wallslide_speed
	
	player_jump.max_jump_time = jump_time
	player_walljump.max_jump_time = walljumptime
	player_dashjump.max_jump_time = dashjumptime
	player_dashwalljump.max_jump_time = dashwalljump_time
	
	player_walk.default_gravity = default_gravity
	player_jump.default_gravity = default_gravity
	player_walljump.default_gravity = default_gravity
	player_hover.default_gravity = default_gravity
	player_wallslide.default_gravity = default_gravity
	player_dash.default_gravity = default_gravity
	player_airdash.default_gravity = default_gravity
	player_dashjump.default_gravity = default_gravity
	player_dashwalljump.default_gravity = default_gravity
	player_dodge.default_gravity = default_gravity
	player_fall.default_gravity = default_gravity

func backup_original_values() -> void :
	player_knockback = player_damage.prevent_knockbacks
	player_reduction = player_damage.extra_damage_reduction
	
	walk_speed = player_walk.horizontal_velocity
	jump_speed = player_jump.horizontal_velocity
	walljump_speed = player_walljump.horizontal_velocity
	hover_speed = player_hover.horizontal_velocity
	dash_speed = player_dash.horizontal_velocity
	airdash_speed = player_airdash.horizontal_velocity
	dashjump_speed = player_dashjump.horizontal_velocity
	dashwalljump_speed = player_dashwalljump.horizontal_velocity
	dodge_speed = player_dodge.horizontal_velocity
	fall_speed = player_fall.horizontal_velocity
	dashfall_speed = player_fall.dash_momentum
	wallslide_speed = player_wallslide.jump_velocity
	
	jump_time = player_jump.max_jump_time
	walljumptime = player_walljump.max_jump_time
	dashjumptime = player_dashjump.max_jump_time
	dashwalljump_time = player_dashwalljump.max_jump_time

func get_facing_direction():
	return character.get_facing_direction()

func hit(target):
	if active:
		var enemy = target.get_parent()
		if enemy == null:
			return
		if enemy.name.begins_with("Jellyfish"):
			target.damage(enemy.max_health, self)
		else:
			target.damage(damage, self)
		

func leave(_target):
	pass

func deflect(_body) -> void :
	pass

func disable_damage():
	pass

func _on_area2D_body_entered(body: Node) -> void :
	if active:
		if body.is_in_group("Enemies") or body.is_in_group("Bosses") or body.is_in_group("Player"):
			return
		if body.is_in_group("Enemy Projectile") or body.is_in_group("Player Projectile"):
			for exception in exceptions:
				if body.name.begins_with(exception):
					return
			if body.active:
				var deflect_projectile = false
				var reverse_velocity = false
				var rotate = true
				var flip_h = false

				for cls in projectile_classes:
					if body is cls:
						deflect_projectile = true
						if "velocity" in body:
							reverse_velocity = true
						for rotatable in not_rotatable_projectiles:
							if body.name.begins_with(rotatable):
								rotate = false
								break
						for flippable in flippable_projectiles:
							if body.name.begins_with(flippable):
								flip_h = true
								break

				if not deflect_projectile:
					for projectile in deflectable_projectiles:
						if body.name.begins_with(projectile):
							deflect_projectile = true
							if "velocity" in body:
								reverse_velocity = true




							for rotatable in not_rotatable_projectiles:
								if body.name.begins_with(rotatable):
									rotate = false
									break
							for flippable in flippable_projectiles:
								if body.name.begins_with(flippable):
									flip_h = true
									break

				if deflect_projectile:
					if reverse_velocity:
						
						var normal = (body.global_position - global_position).normalized()
						var reflected = body.velocity - 2.0 * body.velocity.dot(normal) * normal
						body.velocity = reflected
					if rotate:
						body.rotation = body.velocity.angle()
					if flip_h:
						body.animatedSprite.scale.x = 1
					if "damage_disabled" in body:
						body.damage_disabled = true
					if body.has_node("DamageOnTouch"):
						body.get_node("DamageOnTouch").active = false
					var dmg = 0
					dmg = body.damage
					body.damage_to_bosses = dmg
					body.damage_to_weakness = dmg
					body.remove_from_group("Enemy Projectile")
					body.add_to_group("Player Projectile")
					body.set_collision_layer(4)
					deflect_sound.play()
