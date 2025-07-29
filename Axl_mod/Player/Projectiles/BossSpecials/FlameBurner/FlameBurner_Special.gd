extends SpecialAbilityAxl

onready var player_damage: = character.get_node("Damage")
onready var player_shot_node: = character.get_node("Shot")
onready var player_altshot_node: = character.get_node("AltFire")

onready var flame_hitbox: = preload("res://Axl_mod/Player/Projectiles/BossSpecials/FlameBurner/Flame_Hitbox.tscn")
onready var light: Light2D = $light
onready var smoke_particles: = $smoke
onready var sfx: = $sfx
onready var damage_sfx: = $damage

var aura_time: float = 16.0
var flame_frames: Array = [1.0]
var light_color: Color = Color.orange
var damage_factor = 1.5
var shot_damage_values: Dictionary = {}
var alt_damage_values: Dictionary = {}

var flame_aura_timer: float = 0.0
var flame_aura_time: float = 0.2
var small_flame_timer: float = 0.0
var small_flame_time: float = 0.2
var small_flame_tower_time: float = 0.2
var small_flame_height: int = 12

var damage_tick_timer: float = 0.0
var damage_tick_time: float = 1.0
var damage_per_tick: float = 1.0

func deactivate() -> void :
	go_to_attack_stage(10)
	Tools.timer(1.0, "queue_free", self)

func destroy(enemy) -> void :
	if typeof(enemy) == TYPE_STRING:
		if enemy == "boss":
			go_to_attack_stage(10)

func initialize() -> void :
	Tools.timer(animation_time, "set_stage", self)
	small_flame_time = 0.1
	flame_aura_time = 0.2

func set_stage() -> void :
	attack_stage = 1

func _physics_process(delta: float) -> void :
	._physics_process(delta)
	if attack_stage == 1:
		play_animation("aura")
		set_aura_buff()
		
		next_attack_stage()
		
	elif attack_stage == 2:
		light.light(0.3 * rand_range(1.5, 2.0), Vector2(2.5 * rand_range(1.0, 1.5), 2 * rand_range(1.0, 1.5)), light_color)
		small_flame_timer -= delta
		if small_flame_timer <= 0:
			small_flame_timer = small_flame_time
			spawn_small_flame_tower()
		flame_aura_timer -= delta
		if flame_aura_timer <= 0:
			flame_aura_timer = flame_aura_time
			spawn_aura_flame()
			sfx.play()
		reduce_health(delta)
		aura_time -= delta
		if aura_time <= 0:
				go_to_attack_stage(10)
	
	elif attack_stage == 10:
		unset_aura_buff()
		next_attack_stage()
		EndAbility()

func spawn_aura_flame() -> void :
	var flame = flame_hitbox.instance()
	add_child(flame)
	flame.animation.animation = "aura_flame"
	flame.animation.playing = true
	flame.animation.frame = 0
	flame.z_index = z_index + 1
	flame.collision_shape.shape.extents = Vector2(24, 24)
	flame.collision_shape.position.y = - 10
	flame.global_position.x = global_position.x
	flame.global_position.y = global_position.y + 6

func spawn_small_flame_tower() -> void :
	var x_pos = global_position.x + rand_range( - 15, 15)
	var y_pos = global_position.y + 16
	spawn_small_flame(x_pos, y_pos)
	Tools.timer_p(small_flame_time, "spawn_small_flame", self, [x_pos, y_pos - small_flame_height, 3])
	Tools.timer_p(small_flame_time * 2, "spawn_small_flame", self, [x_pos, y_pos - small_flame_height * 2, 3])

func spawn_small_flame(x_pos: float = global_position.x, y_pos: float = global_position.y + 16, frame: int = 0) -> void :
	var flame = flame_hitbox.instance()
	get_tree().current_scene.add_child(flame)
	flame.animation.animation = "small_flame"
	flame.animation.playing = true
	flame.animation.frame = frame
	flame.z_index = z_index + 3
	flame.collision_shape.shape.extents = Vector2(11, 13)
	flame.collision_shape.position.y = - 13
	flame.global_position.x = x_pos
	flame.global_position.y = y_pos

func reduce_health(delta: float) -> void :
	damage_tick_timer += delta
	if damage_tick_timer >= damage_tick_time:
		damage_tick_timer = 0.0
		if character.current_health > 1:
			player_damage.emit_signal("reduced_health", damage_per_tick)
			character.current_health -= damage_per_tick
			character.flash()
			damage_sfx.play()

func set_aura_buff() -> void :
	smoke_particles.emitting = true
	for shot in player_shot_node.get_children():
		if shot is WeaponAxl:
			var path = shot.get_path()
			shot_damage_values[path] = {
				"projectile_damage": shot.projectile_damage, 
				"projectile_damage_to_bosses": shot.projectile_damage_to_bosses, 
				"projectile_damage_to_weakness": shot.projectile_damage_to_weakness
			}
			shot.projectile_damage *= damage_factor
			shot.projectile_damage_to_bosses *= damage_factor
			shot.projectile_damage_to_weakness *= damage_factor
	for shot in player_altshot_node.get_children():
		if shot is WeaponAxl:
			var path = shot.get_path()
			alt_damage_values[path] = {
				"projectile_damage": shot.projectile_damage, 
				"projectile_damage_to_bosses": shot.projectile_damage_to_bosses, 
				"projectile_damage_to_weakness": shot.projectile_damage_to_weakness
			}
			shot.projectile_damage *= damage_factor
			shot.projectile_damage_to_bosses *= damage_factor
			shot.projectile_damage_to_weakness *= damage_factor

func unset_aura_buff() -> void :
	smoke_particles.emitting = false
	for shot in player_shot_node.get_children():
		if shot is WeaponAxl:
			var path = shot.get_path()
			if shot_damage_values.has(path):
				var original = shot_damage_values[path]
				shot.projectile_damage = original.projectile_damage
				shot.projectile_damage_to_bosses = original.projectile_damage_to_bosses
				shot.projectile_damage_to_weakness = original.projectile_damage_to_weakness
	for shot in player_altshot_node.get_children():
		if shot is WeaponAxl:
			var path = shot.get_path()
			if alt_damage_values.has(path):
				var original = alt_damage_values[path]
				shot.projectile_damage = original.projectile_damage
				shot.projectile_damage_to_bosses = original.projectile_damage_to_bosses
				shot.projectile_damage_to_weakness = original.projectile_damage_to_weakness
	shot_damage_values.clear()
	alt_damage_values.clear()
