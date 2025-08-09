extends Node

const sections := 13

var times := {}

func reset():
	times.clear()

func add(section_name,delta):
	if section_name in times:
		times[section_name] += delta
	else:
		times[section_name] = 0.0

func clocked_all_stages() -> bool:
	return times.size() == sections
