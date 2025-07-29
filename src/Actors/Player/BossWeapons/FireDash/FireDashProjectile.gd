class_name FireDash extends SimplePlayerProjectile

export  var has_deflectable: = true
const damage_frequency: = 0.06
var next_damage_time: = 0.0
var target_list = []
var character: Character
var emitted_finish: = false

onready var collision: CollisionShape2D = $collisionShape2D
signal finish
signal disabled

func _ready() -> void :
	Event.listen("damage", self, "finish")
	Event.listen("player_death", self, "finish")
	if GameManager.is_player_in_scene():
		character = GameManager.player
		character.listen("cutscene_deactivate", self, "finish")

func connect_disable_unneeded_object() -> void :
	pass

func _Setup() -> void :
	next_damage_time = 0
	set_collider_position()

func set_collider_position() -> void :
	if character:
		if character.get_facing_direction() > 0:
			collision.position.x = 21
		elif character.get_facing_direction() < 0:
			collision.position.x = 21

	
func _Update(_delta: float) -> void :
	set_visual_direction()
	if ending and timer > 0.5:
		call_deferred("destroy")

func destroy() -> void :
	Log("Destroying fire")
	.destroy()

func set_visual_direction() -> void :
	if GameManager.is_player_in_scene():
		character = GameManager.player
		set_direction(character.get_facing_direction())
		set_collider_position()
		
		collision.position.x = collision.position.x * character.get_facing_direction()
		if get_facing_direction() > 0 and character.get_vertical_speed() > 0:
			rotation_degrees = 35
		elif get_facing_direction() > 0 and character.get_vertical_speed() < 0:
			rotation_degrees = - 35
		elif get_facing_direction() < 0 and character.get_vertical_speed() > 0:
			rotation_degrees = - 35
		elif get_facing_direction() < 0 and character.get_vertical_speed() < 0:
			rotation_degrees = 35
		elif character.get_vertical_speed() == 0:
			rotation_degrees = 0

func hit(_body) -> void :
	if active:
		Log("Hit " + _body.name)
		var target_hp = _DamageTarget(_body)
		_OnHit(target_hp)

func finish() -> void :
	disable_damage()
	call_deferred("disable_visuals")
	$fire2.emitting = false
	ending = true
	emit_signal("disabled")
	Tools.timer(0.45, "destroy", self)

func _OnDeflect() -> void :
	Log("OnDeflect")
	emit_signal("disabled")
	emit_finish()
	pass

func deflect(_v) -> void :
	pass

func _OnScreenExit() -> void :
	pass

func handle_off_screen(_delta: float) -> void :
	pass

func _OnHit(_target_remaining_HP) -> void :
	if _target_remaining_HP > 0:
		emit_finish()

func emit_finish() -> void :
	if not emitted_finish:
		emit_signal("finish")
		emitted_finish = true
		
