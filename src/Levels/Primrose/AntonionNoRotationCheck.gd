extends Node

export  var achievement: Resource

var used_checkpoint: = false
var rotated_stage: = false

func _ready() -> void :
	Event.connect("moved_player_to_checkpoint", self, "checkpoint_check")
	Event.connect("rotate_stage_in_degrees", self, "on_rotation")

func on_rotation(_param: = null, _param2: = null) -> void :
	rotated_stage = true
	

func checkpoint_check(checkpoint: CheckpointSettings) -> void :
	if checkpoint.id > 0:
		used_checkpoint = true
		

func fire_achievement() -> void :
	
	if not used_checkpoint and not rotated_stage:
		Achievements.unlock(achievement.get_id())
