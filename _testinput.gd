extends Node2D

var listened_events := ["fire","jump","dash","move_right","move_left", "move_up", "move_down"]
var timer := 0.0
var sequence : Resource

func _input(event: InputEvent) -> void:
	for listened in listened_events:
		if event.is_action_pressed(listened):
			save(listened)
		elif event.is_action_released(listened):
			save(listened,true)
	ResourceSaver.save(sequence.resource_path,sequence)

func save(listened : String, released := false):
	var n = listened
	if "move_right" in listened:
		n = "right"
	elif "move_left" in listened:
		n = "left"
	if "move_up" in listened:
		n = "up"
	elif "move_down" in listened:
		n = "down"
	if released:
		n += "_release"
	
	print(n + " " + str(timer))
	sequence.presses.append(n)
	sequence.timings.append(timer)

func _physics_process(delta: float) -> void:
	timer += delta

func _on_weapon_defined(weapon) -> void:
	sequence = weapon.input_sequence
	sequence.presses.clear()
	sequence.timings.clear()
	print("Input Recorder: Sequence defined: " + str(weapon.collectible))
