extends Actor

export var unique_time:= 0.5
export var boss : PackedScene


signal spawned_boss(boss)
signal enter_battle

func start_battle():
	emit_signal("enter_battle")
