extends Node2D

export var box : PackedScene

func _ready() -> void:
	call_deferred("spawn_box")

func spawn_box() -> void:
	if player_is_in_current_area():
		var b = box.instance()
		get_parent().add_child(b)
		b.global_position = global_position
	Tools.timer(3.0,"spawn_box",self)
	
func player_is_in_current_area() -> bool:
	var checkpoint : CheckpointSettings = GameManager.checkpoint
	if checkpoint:
		return checkpoint.id == 1
	return false
