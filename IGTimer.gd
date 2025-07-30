extends Node

export var section := "section_name"

var running := true

func _ready() -> void:
	Event.connect("beat_seraph_lumine",self,"stop")
	IGT.current_section = section
	running = true

func _physics_process(delta: float) -> void:
	if running:
		IGT.add_time(section,delta)

func stop() -> void:
	running = false
