class_name ActionPresses extends Resource

export  var presses: Array
export  var timings: Array

export  var limit: = 1512


func call_actions(node: Node) -> void :
	var i = 0
	for key in presses:
		Tools.timer_p(timings[i] - 0.1, "emulate_press", node, get_action(key))
		i += 1

func get_action(key: = "right_release") -> Array:
	var press: = true
	var text = key
	if "_release" in text:
		press = false
		text.erase(text.length() - 8, 8)
	return [text + "_emulated", press]
