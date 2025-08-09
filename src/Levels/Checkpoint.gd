extends Area2D

export (NodePath) var last_door
export var force_direction := 0

var settings : CheckpointSettings

func _ready() -> void:
	settings = CheckpointSettings.new()
	settings.id = int(name)
	settings.respawn_position = global_position
	var door = get_node_or_null(last_door)
	if door != null:
		settings.character_direction = int(door.scale.x)
		settings.last_door = door.get_path()
	
	if force_direction != 0:
		settings.character_direction = force_direction
		

func _on_Checkpoint_body_entered(_body: Node) -> void:
	if not _body.is_in_group("Props"):
		GameManager.reached_checkpoint(settings)
		update_limits()
		

func update_limits() -> void:
	if not last_door:
		#push_warning ("Door not set on checkpoint " + name)
		return
	var d = get_node(last_door)
	if d and d.has_method("reached_checkpoint"):
		d.reached_checkpoint()
