extends Node
class_name MovementRecorder
onready var x: KinematicBody2D = $".."
onready var a: AnimatedSprite = $"../animatedSprite"

var recording: = false

var recorded_positions = []

func _ready() -> void :
	if GameManager.time_attack:
		Event.listen("gameplay_start", self, "start_recording")
		Event.listen("player_death", self, "cancel_recording")
		Event.listen("boss_door_open", self, "finish_recording")

func start_recording() -> void :
	recording = true
	

func cancel_recording() -> void :
	recording = false
	recorded_positions.clear()
	

func finish_recording() -> void :
	recording = false
	
	GameManager.save_recording(recorded_positions)

func _physics_process(_delta: float) -> void :
	if recording:
		recorded_positions.append(Locale.new(x.global_position, a.animation, get_ms()))

func get_ms() -> float:
	return OS.get_ticks_msec() - GameManager.get_stage_start_msec()

func get_resource() -> int:
	if a.frames.resource_name != "":
		return 1
	return 0
