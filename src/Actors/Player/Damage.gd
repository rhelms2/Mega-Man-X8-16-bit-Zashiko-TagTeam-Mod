extends Movement
class_name Damage

export  var duration_time: float = 0.6
export  var invulnerability_time: float
export  var prevent_knockbacks: bool = false
export  var damage_reduction: float = 0.0
export  var death_protection: int = 1

onready var sparks: AnimatedSprite = get_node_or_null("sparks")
onready var back: AnimatedSprite = get_node_or_null("back")

var extra_damage_reduction: float = 1.0
var damage_taken: float
var enemy
var damage_direction: int
var has_set_vertical_speed: bool = false
var last_chance_threshold: int = 3

signal reduced_health(damage)

func set_game_modes() -> void :
	if CharacterManager.game_mode == - 1:
		last_chance_threshold = 6
	elif CharacterManager.game_mode == 0:
		last_chance_threshold = 3
	elif CharacterManager.game_mode == 1:
		last_chance_threshold = 2
	elif CharacterManager.game_mode == 2:
		last_chance_threshold = character.max_health - 1.0
	elif CharacterManager.game_mode == 3:
		last_chance_threshold = character.max_health - 1
	elif CharacterManager.game_mode >= 4:
		last_chance_threshold = character.max_health * 2

func _ready() -> void :
	set_game_modes()
	character.listen("damage", self, "on_damage")

func play_animation_on_initialize() -> void :
	if prevent_knockbacks:
		return
	if damage_reduction > 0.0:
		play_animation("damage_resist")
	else:
		.play_animation_on_initialize()

func _Setup() -> void :
	has_set_vertical_speed = false
	reduce_health()
	character.flash()
	character.set_invulnerability(invulnerability_time)
	if not prevent_knockbacks:
		set_direction( - damage_direction)
		character.set_vertical_speed( - jump_velocity)
	else:
		if character.current_health > 0:
			GameManager.pause("IcarusBody")
			Tools.timer_p(0.1, "unpause", GameManager, "IcarusBody")
			sparks.frame = 0
			back.frame = 0
	character.remove_invulnerability_shader()
	zero_bonus_horizontal_speed()
	character.global_position.y -= 1
	character.emit_signal("received_damage")

func reduce_health() -> void :
	var actual_damage = round(((damage_taken * (1 - damage_reduction / 100)) * CharacterManager.damage_get_multiplier) * extra_damage_reduction)
	if actual_damage <= 0:
		actual_damage = 1
	if should_last_chance(actual_damage):
		activate_last_chance(actual_damage)
	else:
		emit_signal("reduced_health", actual_damage)
		character.current_health -= actual_damage
		

func should_last_chance(actual_damage: float) -> bool:
	return character.current_health > last_chance_threshold and death_protection > 0 and character.current_health - actual_damage <= 0

func activate_last_chance(_actual_damage: float) -> void :
	emit_signal("reduced_health", character.current_health - 1)
	character.current_health = 1
	set_death_protection(0)

func set_death_protection(value: float = 1.0) -> void :
	death_protection = value

func _Update(_delta: float) -> void :
	force_movement_toward_direction(horizontal_velocity, damage_direction)
	process_gravity(_delta)

func _EndCondition() -> bool:
	if Has_time_ran_out() or prevent_knockbacks:
		return true
	if character.is_colliding_with_wall():
		if character.get_pressed_axis() == character.is_colliding_with_wall():
			character.set_vertical_speed(0)
			return true
	return false

func Has_time_ran_out() -> bool:
	return duration_time < timer

func _Interrupt() -> void :
	character.set_horizontal_speed(0)
	character.apply_invulnerability_shader()

func on_damage(value: float, inflicter: Object) -> void :
	if should_be_damaged():
		if not character.is_invulnerable():
			damage_taken = value
			damage_direction = define_knockback_direction(inflicter)
			ExecuteOnce()
			if inflicter == character and character.current_health > 1 and (CharacterManager.game_mode <= - 1 or not character.should_die_to_spikes):
				character.current_health = 1

func should_be_damaged() -> bool:
	return character.listening_to_inputs and character.has_health() and not character.is_invulnerable() and active

func define_knockback_direction(inflicter: Object) -> int:
	if inflicter:
		if character.global_position.x - inflicter.global_position.x > 0:
			return 1
	return - 1

func is_high_priority() -> bool:
	return true
