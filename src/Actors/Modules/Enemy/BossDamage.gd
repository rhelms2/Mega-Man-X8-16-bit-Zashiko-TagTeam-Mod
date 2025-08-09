extends EnemyDamage
class_name BossDamage

export  var debugging: bool = false
export  var debug_visual: bool = false
export  var activate_after_intro: bool = true
export  var weakenesses: Array
export  var weakness_multiplier: float = 1.0

var debug_last_hit: float = 0.0
var activated: bool = false
var hit_by_weakeness: bool = false
var can_get_hit: bool = false
var custom_hitbox

const normal_invulnerability_time: float = 0.06
const weakness_invulnerability_time: float = 1.75
const charged_weakness_invul_time: float = 2.15
const normal_flash_time: float = 0.35
const buster_family: Array = ["Buster", "Lemon"]

signal charged_weakness_hit
signal took_damage


func _ready() -> void :
	if get_node_or_null("dps"):
		$dps.visible = debugging
	can_get_hit = debugging
	if activate_after_intro:
		character.listen("intro_concluded", self, "activate_get_hit")
	character.listen("damage_reduction", self, "set_damage_reduction")
	if CharacterManager.game_mode >= 3:
		remove_weaknesses()
	add_weakness("NovaStrike")
	add_weakness("Shoryuuken")
	add_weakness("GigaCrash")
	deactivate()
	if activated:
		activate()

func add_weakness(weakness: String) -> void :
	if not weakness in weakenesses:
		weakenesses.append(weakness)

func remove_weakness(weakness: String) -> void :
	weakenesses.erase(weakness)
	
func remove_weaknesses() -> void :
	weakenesses.clear()

func activate_get_hit() -> void :
	can_get_hit = true
	activate()

func should_call_hit(_inflicter) -> bool:
	return can_get_hit

func connect_area_events() -> void :
	for child in get_children():
		if child is Area2D:
			custom_hitbox = child
			child.connect("body_entered", self, "_on_area2D_body_entered")
			child.connect("body_exited", self, "_on_area2D_body_exited")
			return
	area2D.connect("body_entered", self, "_on_area2D_body_entered")
	area2D.connect("body_exited", self, "_on_area2D_body_exited")

func reduce_health(_damage, inflicter) -> void :
	debug_last_hit = OS.get_ticks_msec()
	Event.emit_signal("hit_enemy")
	var dmg_value: float = 1
	if "damage_to_bosses" in inflicter:
		dmg_value = (inflicter.damage_to_bosses * damage_reduction) * CharacterManager.damage_deal_multiplier




	if is_weakness(inflicter):
		dmg_value = handle_weakness(inflicter)
	else:
		character.reduce_health(dmg_value)
		max_flash_time = normal_flash_time
		invulnerability_time = normal_invulnerability_time
	emit_signal("took_damage")
	emit_signal("got_hit", inflicter)
	increment_pds(dmg_value)

func is_weakness(inflicter: Object) -> bool:
	for word in weakenesses:
		if word in inflicter.name:
			return true
	return false

func is_a_buster(inflicter: Object) -> bool:
	for word in buster_family:
		if word in inflicter.name:
			return true
	return false

func handle_weakness(inflicter) -> float:
	var dmg_value = 0.0
	if CharacterManager.game_mode <= 0:
		dmg_value = (inflicter.damage_to_weakness * weakness_multiplier * damage_reduction)
	else:
		dmg_value = (inflicter.damage_to_weakness * weakness_multiplier * damage_reduction) * CharacterManager.damage_deal_multiplier
	character.reduce_health(dmg_value)
	if "Charged" in inflicter.name or "Punch" in inflicter.name:
		invulnerability_time = charged_weakness_invul_time
		emit_signal("charged_weakness_hit", get_inflicter_direction(inflicter))
	else:
		invulnerability_time = weakness_invulnerability_time
	max_flash_time = invulnerability_time
	return dmg_value

func get_inflicter_direction(inflicter) -> int:
	if inflicter.global_position.x < global_position.x:
		return 1
	else:
		return - 1

func play_shader() -> void :
	if not character.has_health():
		max_flash_time = invulnerability_time / 6
		
	animatedSprite.material.set_shader_param("Flash", 1)
	if debug_visual:
		animatedSprite.material.set_shader_param("Should_Blink", 1)
	if character.current_health > 0:
		i_timer = 0.01
	else:
		i_timer = normal_flash_time / 2

func stop_shader() -> void :
	animatedSprite.material.set_shader_param("Flash", 0)
	animatedSprite.material.set_shader_param("Should_Blink", 0)

func should_stop_blinking() -> bool:
	if debug_visual:
		return not character.is_invulnerable()
	return i_timer > max_flash_time

func apply_invulnerability_or_death() -> void :
		if character.current_health <= 0:
			character.emit_zero_health_signal()
		else:
			character.set_invulnerability(invulnerability_time)
			character.emit_signal("got_hit")

func deactivate() -> void :
	active = false
	if custom_hitbox != null:
		custom_hitbox.get_node("collisionShape2D").call_deferred("set_disabled", true)
	else:
		$"../area2D/collisionShape2D".call_deferred("set_disabled", true)

func activate() -> void :
	active = true
	if custom_hitbox != null:
		custom_hitbox.get_node("collisionShape2D").call_deferred("set_disabled", false)
	else:
		$"../area2D/collisionShape2D".call_deferred("set_disabled", false)

func should_ignore_damage(inflicter) -> bool:
	if character.is_invulnerable() or not character.has_health():
		if not bypass_hit_invulnerable:
			return true
		elif "bypass_shield" in inflicter:
			return false
	if only_on_screen and not GameManager.is_on_screen(character.global_position):
		return true
	if ignore_nearby_hits and character.has_shield():
		if inflicter.is_in_group("Props") or "bypass_shield" in inflicter:
			
			return false
		return true
	return false
