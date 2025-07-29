extends Node

export  var checkpoint_limit: = 3

func _ready() -> void :
	call_deferred("check_current_checkpoint")
	Event.connect("reached_checkpoint", self, "on_reach_checkpoint")

func on_reach_checkpoint(reached_checkpoint: CheckpointSettings) -> void :
	if reached_checkpoint.id >= checkpoint_limit:
		queue_free()

func check_current_checkpoint() -> void :
	if GameManager.checkpoint:
		if GameManager.checkpoint.id >= checkpoint_limit:
			queue_free()
