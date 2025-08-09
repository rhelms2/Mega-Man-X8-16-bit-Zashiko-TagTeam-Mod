extends Object
class_name TimerController

var timer_list: Array
var owner: Node


func _init(_owner, reset_signal: String = "no_signal") -> void :
	owner = _owner
	connect_reset(reset_signal)

func connect_reset(end_signal: String = "stop") -> void :
	if end_signal != "no_signal":
		owner.connect(end_signal, self, "reset")

func reset(_discard = null) -> void :
	for timer in timer_list:
		if is_instance_valid(timer):
			var s = Timer.new()
			
			timer.kill()
