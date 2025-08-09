extends AttackAbility
class_name ShieldClaw

export (PackedScene) var claw_attack
onready var shield := $EnemyShield
onready var damage_on_touch: Node2D = $DamageOnTouch
var claw_projectile
var wall_position : float
onready var prepare: AudioStreamPlayer2D = $prepare
onready var wallhit: AudioStreamPlayer2D = $wallhit
onready var footstep: AudioStreamPlayer2D = $footstep
onready var footstep_2: AudioStreamPlayer2D = $footstep2

func _Setup() -> void:
	attack_stage = 0
	wall_position = get_wall()
	prepare.play()

func _Update(_delta) -> void:
	if attack_stage == 0 and timer > 0.3:
		shield.activate()
		damage_on_touch.activate()
		next_attack_stage()
	if attack_stage == 1  and timer > 0.85:
		if is_too_distant_from_wall():
			play_animation_once("shieldclaw_foward")
			force_movement(30)
		next_attack_stage()

	if attack_stage == 2:
		if not is_too_distant_from_wall():
			play_animation("shieldclaw_prepare")
			force_movement(0)
			next_attack_stage()
		elif animatedSprite.frame == 3:
			if not footstep.playing:
				screenshake(.8)
				footstep.play()
		elif animatedSprite.frame == 6:
			if not footstep_2.playing:
				footstep_2.play()

	elif attack_stage == 3:
		if has_finished_last_animation():
			shield.deactivate()
			damage_on_touch.deactivate()
			play_animation("shieldclaw")
			wallhit.play()
			screenshake()
			fire_projectile()
			next_attack_stage()
			
	elif attack_stage == 4 and timer > 0.5:
		claw_projectile.destroy()
		play_animation("shieldclaw_end")
		next_attack_stage()
		
	elif attack_stage == 5 and has_finished_last_animation():
		EndAbility()

func _Interrupt() -> void:
	._Interrupt()
	shield.deactivate()
	damage_on_touch.deactivate()

func is_too_distant_from_wall() -> bool:
	return global_position.x - wall_position > 200

func fire_projectile() -> void:
	claw_projectile = instantiate(claw_attack)
	claw_projectile.set_creator(self)
	claw_projectile.initialize(-1)
	claw_projectile.global_position.y = global_position.y
	claw_projectile.global_position.x = wall_position + 64
	
func get_wall() -> float:
	var intersection = raycast ( Vector2(-1000, global_position.y)).position.x
	return intersection

func raycast(target_position : Vector2) -> Dictionary:
	var space_state = get_world_2d().direct_space_state
	return space_state.intersect_ray(global_position, target_position, [self], character.collision_mask)

