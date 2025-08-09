extends Node
onready var camera: Camera2D = $"../../../StateCamera"
onready var elevator: StaticBody2D = $".."

export  var offset_top: = 226.0
export  var offset_bottom: = 0

var active: = false

func _ready() -> void :
	deactivate()
	
func _on_Elevator_started() -> void :
	activate()

func activate():
	set_physics_process(true)
	
func deactivate():
	set_physics_process(false)

func _physics_process(_delta: float) -> void :
	camera.custom_limits_top = float(elevator.global_position.y - offset_top)

	camera.limit_bottom = float(elevator.global_position.y - offset_bottom)
