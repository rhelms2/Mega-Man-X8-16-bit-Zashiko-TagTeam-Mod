extends Respawner

onready var portal: Node2D = $"../Portal"

export  var spawn_at_start: = false

func _ready() -> void :
	portal.connect("teleported", self, "deactivate")
	if spawn_at_start:
		Tools.timer(0.1, "_on_checkpoint_start", self)
	
func mark_for_respawn(_enemy: Watched, _death_duration = minimum_death_duration):
	pass
	
func _on_checkpoint_start() -> void :
	var checkpoint: = 0
	if GameManager.checkpoint:
		checkpoint = GameManager.checkpoint.id
	if checkpoint == next_checkpoint - 1:
		
		_on_Portal_teleport_start()


func _on_Portal_teleport_start() -> void :
	
	for watched_enemy in enemies:
		call_deferred("respawn", watched_enemy)
	

func on_enemy_exit_screen(_enemy: Watched):
	
	pass

