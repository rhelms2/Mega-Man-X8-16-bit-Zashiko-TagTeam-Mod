extends Node2D
class_name TransformedEnemyDamage
onready var animatedSprite = get_parent().get_node("animatedSprite")
onready var character = get_parent()
onready var visibility: = get_parent().get_node("visibilityNotifier2D")
onready var _player = GameManager.player
onready var _player_damage = _player.get_node("Damage")
export  var active: = true
export  var invulnerability_time: = 1.75
export  var minimum_damage: = 0.1
export  var only_on_screen: = true
export  var ignore_nearby_hits: = true
export  var ignore_hits_if_shield: = false
export  var bypass_hit_invulnerable: = false
export  var disable_on_death: = true
var saved_for_reactivation = []
var damage_reduction: = 1.0

export  var max_flash_time: = 0.035
var i_timer: = 0.0


var dps_timer: = 0.0
var dps_max_time: = 0.0
var damage_received: = 0.0
var dps: = 0.0

signal dps(value)
signal got_hit(inflicter)

func _ready() -> void :
	if active:
		if not is_in_group("Player"):
			add_to_group("Player", true)
		character.listen("damage", self, "damage")
		if disable_on_death:
			character.listen("death", self, "deactivate")
		Event.listen("player_death", self, "deactivate")


func set_damage_reduction(value):
	damage_reduction = value
	

func _on_area2D_body_entered(_body: Node) -> void :
	if active and character.has_health():
		if _body.is_in_group("Enemy Projectile"):
			if should_call_hit(_body):
				_body.hit(self)
			else:
				saved_for_reactivation.append(_body)

func _on_area2D_body_exited(_body: Node) -> void :
	if _body.is_in_group("Enemy Projectile"):
		_body.leave(self)
	if _body in saved_for_reactivation:
		saved_for_reactivation.erase(_body)

func direct_hit(damageValue: DamageValue) -> float:
	if character.has_shield():
		var dmg = character.shield.on_direct_hit(damageValue)
		damage(dmg.get_damage(), dmg.creator)
	return damage(damageValue.get_damage(), damageValue)

func damage(damage, inflicter) -> float:
	if should_be_damaged(inflicter):
		reduce_health(damage, inflicter)
		emit_combo_hit(inflicter)
		apply_invulnerability_or_death()
		play_vfx()
	return character.current_health

func apply_invulnerability_or_death() -> void :
		if character.current_health <= 0:
			character.emit_zero_health_signal()
		else:
			character.set_invulnerability(invulnerability_time)
			character.emit_signal("got_hit")

func reduce_health(damage, inflicter):
	var actual_damage = round(damage * (1 - _player_damage.damage_reduction / 100))
	emit_signal("reduced_health", actual_damage)
	_player.current_health -= actual_damage



func should_call_hit(inflicter) -> bool:
	return should_be_damaged(inflicter)

func should_be_damaged(inflicter) -> bool:
	return active and not should_ignore_damage(inflicter)

func should_ignore_damage(inflicter) -> bool:
	if character.is_invulnerable() or not character.has_health():
		if not bypass_hit_invulnerable:
			return true
		elif "bypass_shield" in inflicter:
			return false
	if only_on_screen and not GameManager.is_on_screen(character.global_position):
		return true
	return false


func _physics_process(delta: float) -> void :
	calculate_dps(delta)
	if i_timer != 0:
		i_timer = i_timer + delta
	if should_stop_blinking():
		call_deferred("stop_blink")

func increment_pds(dmg_value) -> void :
	damage_received += dmg_value
	dps_max_time = 5.0

func calculate_dps(delta: float) -> void :
	if dps_max_time < 0:
		dps = 0
		damage_received = 0
		dps_timer = 0
	else:
		dps_timer += delta
		dps_max_time -= delta
		if dps < 0.5:
			dps = 0
		if damage_received > 0:
			dps = damage_received / dps_timer
			emit_signal("dps", dps)

func stop_blink():
	animatedSprite.material.set_shader_param("Flash", 0)
	i_timer = 0
	

func should_stop_blinking() -> bool:
	return i_timer > max_flash_time

func play_vfx():
	play_audio()
	play_shader()
	
func play_audio():
	if character.has_health():
		$audioStreamPlayer2D.play()
	
func play_shader():
	if character.has_health():
		animatedSprite.material.set_shader_param("Flash", 1)
		animatedSprite.material.set_shader_param("Should_Blink", 1)
		i_timer = 0.01

func deactivate():
	active = false

func activate():
	active = true
	
func emit_combo_hit(inflicter) -> void :
	if character.has_method("got_combo_hit"):
		character.got_combo_hit(inflicter)
