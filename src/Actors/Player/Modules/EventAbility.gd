extends Movement
class_name EventAbility

export  var start_event: String = "event"
export  var receive_parameter: bool = false
export  var global_event: bool = false
export  var force_start: bool = false
export  var stop_listening_on_death: bool = true

var execution_method: String = "execute"
var start_parameter


func _ready() -> void :
	check_for_event_errors()
	if receive_parameter:
		execution_method = "execute_with_parameter"
	if global_event:
		set_up_global_event_connection()
	else:
		set_up_character_event_connection()

func execute() -> void :
	if force_start:
		ExecuteOnce()
	else:
		character.try_execution(self)

func execute_with_parameter(param) -> void :
	setup_parameter(param)
	execute()

func set_up_global_event_connection() -> void :
	Event.connect(start_event, self, execution_method)
	if stop_listening_on_death:
		character.listen("death", self, "deactivate")

func set_up_character_event_connection() -> void :
	character.connect(start_event, self, execution_method)
	if stop_listening_on_death:
		character.listen("death", self, "deactivate")

func setup_parameter(param = null) -> void :
	if param != null:
		start_parameter = param
	else:
		Log("Starting without a parameter for event " + start_event)
