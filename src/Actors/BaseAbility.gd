extends Node2D
class_name BaseAbility

export  var active: bool = true
export  var debug_logs: bool = false
export  var conflicting_moves: Array = []

onready var character: Actor = get_parent()

var executing: bool = false
var timer: float = 0.0
var last_time_used: float = 0.0
var _commandList: CommandList = CommandList.new()
var audio
var last_message

signal ability_start(ability)
signal ability_end(ability)
signal executed


func activate() -> void :
	active = true

func deactivate(_d = null) -> void :
	Log("Deactivated")
	active = false

func _StartCondition() -> bool:
	return true

func _Setup() -> void :
	pass

func _Update(_delta: float) -> void :
	pass

func _EndCondition() -> bool:
	return true

func _Interrupt() -> void :
	pass

func Should_Execute() -> bool:
	if active:
		if not conflicting_abilities():
			return true
	return false

func ExecuteOnce() -> void :
	if active:
		Log("Executing")
		emit_signal("ability_start", self)
		StopAnyConflictingMoves()
		Initialize()
		_Setup()
		_commandList.ExecuteAll()

func Initialize() -> void :
	executing = true
	timer = 0
	last_time_used = get_time()
	character.executing_moves.append(self)
	emit_signal("executed")

func get_time() -> int:
	return OS.get_ticks_msec()

func BeforeEveryFrame(delta: float) -> void :
	timer = timer + delta

func ExecuteEachFrame(delta: float) -> void :
	if executing:
		BeforeEveryFrame(delta)
		if _ResetCondition():
			ResetAbility()
		elif _EndCondition():
			EndAbility()
		else:
			_Update(delta)

func EndAbility() -> void :
	Log("Ending")
	Finalize()
	character.remove_from_executing_list(self)
	character.enable_floor_snap()
	emit_signal("ability_end", self)

func ResetAbility() -> void :
	Log("Resetting " + name)
	Finalize()
	ExecuteOnce()

func Finalize() -> void :


	executing = false
	timer = 0
	_Interrupt()
	_commandList.UndoAll()

func Interrupt(interruptor: String) -> void :
	Log("Interrupted by " + interruptor)
	EndAbility()

func _ResetCondition() -> bool:
	return false

func conflicting_abilities() -> bool:
	for executing_move in character.executing_moves:
		if executing_move.name != self.name:
			if self_conflicts_with_anything(executing_move):
				return true
		if self_conflicts_with(executing_move):
			return true
		if is_higher_priority(executing_move):
			if conflicts_with_nothing():
				break
			else:
				return true
	return false

func self_conflicts_with_anything(executing_move) -> bool:
	if conflicts_with_anything():
		if executing_move.conflicts_with_nothing():
			return false
		else:
			return true
	return false

func is_higher_priority(executing_move) -> bool:
	if executing_move.is_high_priority():
		if executing_move.name != self.name:
			return true
	return false

func is_high_priority() -> bool:
	return false

func self_conflicts_with(executing_move) -> bool:
	for conflict in conflicting_moves:
		if executing_move.name == conflict:
			if executing_move.conflicts_with(self):
				Log("Found a mutual conflict with " + executing_move.name)
			else:
				Log("Cant execute, conflict: " + executing_move.name)
				return true
	return false

func conflicts_with(move) -> bool:
	if conflicts_with_anything():
		return true
	for conflicting_move in conflicting_moves:
		if conflicting_move in move.name:
			return true
	return false

func conflicts_with_nothing() -> bool:
	if "Nothing" in conflicting_moves:
		return true
	return false

func conflicts_with_anything() -> bool:
	if "Anything" in conflicting_moves:
			return true
	return false

func StopAnyConflictingMoves() -> void :
	if conflicts_with_nothing():
		return
	var moves_to_end: Array = []
	for executing_move in character.executing_moves:
		if is_high_priority():
			if not executing_move.conflicts_with_nothing():
				moves_to_end.append(executing_move)
		if executing_move.conflicts_with_anything() or executing_move.conflicts_with(self):
			moves_to_end.append(executing_move)
	for move in moves_to_end:
		move.Interrupt(name)

func Log(msg) -> void :
	if debug_logs:
		if not last_message == str(msg):
			
			last_message = str(msg)

func n_int(direction: bool) -> int:
	if not direction:
		return - 1;
	return 1;

func emit_particles(particles, value: bool = true) -> void :
	particles.visible = true
	particles.emitting = value

func is_initial_frame() -> bool:
	return timer < 1.1 / Engine.get_iterations_per_second()

func play_sound(audiostream: AudioStream = null, pitch: = true) -> void :
	if not audio:
		audio = get_node("audioStreamPlayer")
	if pitch:
		audio.pitch_scale = rand_range(1.0, 1.1)
	if audiostream != null:
		if audio.stream == null or audio.stream != audiostream:
			audio.stream = audiostream
	audio.play()

func stop_sound() -> void :
	if audio:
		audio.stop()

func get_all_particles() -> Array:
	var particle_list: Array = []
	for child in get_children():
		if child is Particles2D:
			particle_list.append(child)
	return particle_list

func get_children_whose_name_contains(text: String) -> Array:
	var valid_children: Array = []
	for child in get_children():
		if text in child.name:
			valid_children.append(child)
	return valid_children

func toggle_emit(object, state: bool) -> void :
	if object is Array:
		for particle in object:
			particle.emitting = state
	else:
		object.emitting = state

func restart(object) -> void :
	if object is Array:
		for particle in object:
			particle.restart()
	else:
		object.restart()

func flip(object, d: int) -> void :
	if object is Array:
		for particle in object:
			particle.scale.x = d
	else:
		object.scale.x = d
