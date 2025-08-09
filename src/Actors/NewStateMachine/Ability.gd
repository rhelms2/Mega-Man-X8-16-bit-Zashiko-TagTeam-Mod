extends Node2D
class_name NewAbility, "res://src/HUD/ability_icon.png"

export  var debug_logs: bool = false
export  var active: bool = true
export  var hard_conflicts: Array
export  var soft_conflicts: Array

onready var character = get_character()

var current_conflicts: Array
var executing: bool = false
var timer: float = 0.0

signal start(ability_name)
signal stop(ability_name)


func _ready() -> void :
	connect_conflicts()

func get_character():
	return get_parent()

func connect_conflicts() -> void :
	for nodepath in hard_conflicts:
		var ability = get_node(nodepath)
		ability.connect("start", self, "_on_hard_conflict")
		ability.connect("stop", self, "_on_hard_conflict_stop")
	for nodepath in soft_conflicts:
		var ability = get_node(nodepath)
		ability.connect("start", self, "_on_soft_conflict")

func _on_signal(_p = null) -> void :
	if active:
		if not is_executing():
			if should_execute():
				if _StartCondition():
					execute()
				else:
					Log("StartCondition returned false")
			else:
				Log("Should_execute returned false")
		else:
			pass
	else:
		Log("Deactivated")

func is_executing() -> bool:
	return executing

func should_execute() -> bool:
	if character.has_method("should_execute_abilities"):
		return character.should_execute_abilities() and current_conflicts.size() == 0
	else:
		return current_conflicts.size() == 0

func execute() -> void :
	emit_signal("start", name)
	executing = true
	
	_Setup()

func set_true_delta(_delta) -> void :
	if is_instance_valid(character):
		if character is Character:
			if character.time_stop_active:
				set_animated_sprite_speed_scale(self, 1.0 / Engine.time_scale)
			else:
				set_animated_sprite_speed_scale(self, 1.0)

func set_animated_sprite_speed_scale(node: Node, _scale: float) -> void :
	for child in node.get_children():
		if child is AnimatedSprite:
			child.speed_scale = _scale
		elif child.get_child_count() > 0:
			set_animated_sprite_speed_scale(child, _scale)

func _physics_process(delta: float) -> void :
	set_true_delta(delta)
	if is_executing():
		timer += delta
		if _EndCondition():
			end()
		else:
			_Update(delta)

func _on_hard_conflict(ability_name: String) -> void :
	Log("detected hard conflict with " + ability_name)
	current_conflicts.append(ability_name)
	if is_executing():
		end()

func _on_soft_conflict(ability_name: String) -> void :
	Log("detected soft conflict with " + ability_name)
	if is_executing():
		end()

func _on_hard_conflict_stop(ability_name: String) -> void :
	current_conflicts.erase(ability_name)

func EndAbility() -> void :
	end()

func end() -> void :
	executing = false
	_Interrupt()
	timer = 0
	emit_signal("stop", name)

func _StartCondition() -> bool:
	return true

func _Setup() -> void :
	pass

func _Update(_delta: float) -> void :
	set_physics_process(false)

func _EndCondition() -> bool:
	return false

func _Interrupt() -> void :
	pass

func activate() -> void :
	active = true

func deactivate() -> void :
	active = false

func Log(msg) -> void :
	if debug_logs:
		print_debug(get_parent().name + "." + name + ": " + str(msg))
