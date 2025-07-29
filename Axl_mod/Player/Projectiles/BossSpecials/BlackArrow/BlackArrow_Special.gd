extends SpecialAbilityAxl

onready var player_damage: = character.get_node("Damage")
onready var player_shot_node: = character.get_node("Shot")
onready var player_altshot_node: = character.get_node("AltFire")
onready var player_afterimages: = character.get_node("animatedSprite/afterImages")
onready var sfx: = $sfx

var aura_time: float = 16.0
var sfx_timer: float = 0.0
var sfx_time: float = 0.13
var damage_factor = 0.5
var shot_damage_values: Dictionary = {}
var alt_damage_values: Dictionary = {}


func deactivate() -> void :
	unset_aura_buff()
	queue_free()

func destroy(enemy) -> void :
	if typeof(enemy) == TYPE_STRING:
		if enemy == "boss":
			go_to_attack_stage(10)

func initialize() -> void :
	Tools.timer(animation_time, "set_stage", self)

func set_stage() -> void :
	attack_stage = 1
	sfx.play()

func _physics_process(delta: float) -> void :
	._physics_process(delta)
	
	if attack_stage == 1:
		play_animation("aura")
		set_aura_buff()
		animatedSprite.show()
		next_attack_stage()
		
	elif attack_stage == 2:
		sfx_timer -= delta
		if sfx_timer <= 0:
			sfx_timer = sfx_time
			
		aura_time -= delta
		if aura_time <= 0:
				go_to_attack_stage(10)
	
	elif attack_stage == 10:
		unset_aura_buff()
		next_attack_stage()
		EndAbility()

func invulnerable(state: bool) -> void :
	player_afterimages.upgraded = state
	if state:
		character.add_invulnerability(name)
	else:
		player_afterimages.activate()
		character.remove_invulnerability(name)

func set_aura_buff() -> void :
	invulnerable(true)
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
	invulnerable(false)
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
