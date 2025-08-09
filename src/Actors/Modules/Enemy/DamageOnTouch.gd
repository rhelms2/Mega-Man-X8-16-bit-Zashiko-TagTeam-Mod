extends Node2D
class_name DamageOnTouch

export  var active: bool = true
export  var debug_logs: bool = false
export  var damage: float = 1.0
export  var damage_group: String = "Player"
export  var disable_on_death: bool = true

var damage_frequency: float = 0.016
var can_hit: bool = true
var next_damage_time: float = 0.02
var target_list: Array = []
var last_message
var timer: float = 0.0
var area2D
var character

signal touch_target
signal damage_target


func activate() -> void :
	if not active:
		Log("Activated")
		active = true
		timer = 0

func deactivate(_sm: = null) -> void :
	if active:
		Log("Deactivated")
		active = false

func _ready() -> void :
	set_character()
	if character is Actor and disable_on_death:
		character.listen("zero_health", self, "_on_death")
	connect_area_events()

func set_character() -> void :
	character = get_parent()

func Log(msg) -> void :
	if debug_logs:
		if not last_message == str(msg):
			
			last_message = str(msg)

func connect_area_events():
	for child in get_children():
		if child is Area2D:
			area2D = child
			child.connect("body_entered", self, "_on_area2D_body_entered")
			child.connect("body_exited", self, "_on_area2D_body_exited")
			Log("Connected Area2D events")
			return
	area2D = get_parent().get_node("area2D")
	area2D.connect("body_entered", self, "_on_area2D_body_entered")
	area2D.connect("body_exited", self, "_on_area2D_body_exited")

func _on_area2D_body_entered(_body: Node) -> void :
	Log(_body.name + " entered damage area")
	Log(_body.name + " entered damage area")
	if _body.is_in_group(damage_group):
		Log("Detected collision with " + _body.get_parent().name + "." + _body.name)
		hit(_body)

func _on_area2D_body_exited(_body: Node) -> void :
	if _body.is_in_group(damage_group):
		leave(_body)

func hit(_body: Node) -> void :
	if not (_body in target_list):
		target_list.append(_body)
		_Setup()
		Log("Detected hit with: " + _body.name)

func leave(_target: Node):
	if _target in target_list:
		target_list.erase(_target)
		Log("Removing from list: " + _target.name)

func _Setup():
	next_damage_time = 0.0
	timer = 0

func _physics_process(delta: float) -> void :
	if active:
		apply_damage(delta)

func apply_damage(delta: float) -> void :
	if active:
		timer = timer + delta
		if should_deal_damage():
			deal_damage_to_targets_in_list()

func handle_direction() -> void :
	if character is Actor:
		area2D.scale.x = character.get_direction()

func should_deal_damage() -> bool:
	if timer > 0.02:
		return timer > next_damage_time and target_list.size() > 0
	else:
		return target_list.size() > 0

func deal_damage_to_targets_in_list():
	if target_list.size() > 0 and can_hit:
		for target in target_list:
			if is_instance_valid(target):
				apply_direct_damage(target)
		next_damage_time = timer + damage_frequency

func apply_direct_damage(target) -> void :
	Log("Dealing " + str(damage) + " damage to: " + target.name)
	target.damage(damage, get_parent())
	emit_signal("touch_target")

func _on_death() -> void :
	can_hit = false
	Log("Death, deactivating")
	deactivate()
