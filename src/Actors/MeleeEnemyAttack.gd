extends DamageOnTouch
class_name EnemyMeleeAttack

export var active_duration := 0.0
export var owner_character : NodePath
export var dont_deal_damage := false

export var previous_combo : NodePath
export var damage_in_combo := 3.0
var hit_through_invulnerability := false

func _ready() -> void:
	if previous_combo:
		connect_combo(get_node(previous_combo))

func connect_combo(_previous_combo):
	_previous_combo.connect("damage_target",self,"_on_previous_combo_damage_target")

func set_character() -> void:
	character = get_node(owner_character)

func activate():
	.activate()
	visible = true

func deactivate(_sm := null):
	if active:
		Log("Deactivated")
		active = false
		visible = false

func connect_area_events():
	for child in get_children():
		if child is Area2D:
			area2D = get_node("area2D")
# warning-ignore:return_value_discarded
			child.connect("body_entered",self,"_on_area2D_body_entered")
# warning-ignore:return_value_discarded
			child.connect("body_exited",self,"_on_area2D_body_exited")
			Log("Connected Melee events")

func apply_damage(delta) -> void:
	.apply_damage(delta)
	if timer >= active_duration:
		call_deferred("deactivate")

func deal_damage(target) -> void:
	if hit_through_invulnerability:
		GameManager.player.invulnerability = 0.0
		
	emit_signal("touch_target")
	if not dont_deal_damage:
		Log("Dealing " + str(get_damage()) + " damage to: " + target.name)
		if not GameManager.player.is_connected("damage",self,"on_actual_hit"):
			GameManager.player.connect("damage",self,"on_actual_hit")
		target.damage(get_damage(), get_parent())
		
	hit_through_invulnerability = false

func get_damage() -> float:
	return damage_in_combo if hit_through_invulnerability else damage

func on_actual_hit(_value, _inflicter = null):
	emit_signal("damage_target")
	GameManager.player.disconnect("damage",self,"on_actual_hit")

func handle_direction()->void:
	if character is Actor:
		area2D.scale.x = character.get_direction()
	Log(character.get_direction())
	Log("Hitbox scale x " + str(area2D.scale.x))


func _on_previous_combo_damage_target() -> void:
	Log("Detected Hit from previous attack")
	hit_through_invulnerability = true

func reset_combo():
	hit_through_invulnerability = false
