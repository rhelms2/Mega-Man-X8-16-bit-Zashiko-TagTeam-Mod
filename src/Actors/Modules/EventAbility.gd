class_name EventAbility
extends Movement

export var start_event := "event"
export var receive_parameter := false
export var global_event := false
export var force_start := false
export var stop_listening_on_death := true
var execution_method := "execute"
var start_parameter

func _ready() -> void:
	check_for_event_errors()
	
	if receive_parameter:
		execution_method = "execute_with_parameter"
	
	if global_event:
		set_up_global_event_connection()
	else:
		set_up_character_event_connection()

func execute() -> void:
	if force_start:
		ExecuteOnce()
	else:
		character.try_execution(self)

func execute_with_parameter(param) -> void:
	setup_parameter(param)
	execute()

func set_up_global_event_connection():
	# warning-ignore:return_value_discarded
	Event.connect(start_event,self,execution_method)
	if stop_listening_on_death:
		# warning-ignore:return_value_discarded
		character.listen("death",self,"deactivate")

func set_up_character_event_connection():
	# warning-ignore:return_value_discarded
	character.connect(start_event,self,execution_method)
	if stop_listening_on_death:
		# warning-ignore:return_value_discarded
		character.listen("death",self,"deactivate")

func setup_parameter(param = null):
	if param != null:
		start_parameter = param
	else:
		Log("Starting without a parameter for event " + start_event)
	
