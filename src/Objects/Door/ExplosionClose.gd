extends Area2D

var fired_signal: = false
onready var door: = $".."

signal player_enter

func activate(_d) -> void :
	var boss_spawner = door.get_node_or_null(door.boss_spawner)
	if boss_spawner and boss_spawner.active:
		
		monitoring = true
	else:
		pass
		
	


func _on_area2D_body_entered(body: Node) -> void :
	if not fired_signal and body.is_in_group("Player"):
		emit_signal("player_enter")
		fired_signal = true
		GameManager.player.cutscene_deactivate()
		if GameManager.player.ride:
			GameManager.player.ride.stop_listening_to_inputs()
