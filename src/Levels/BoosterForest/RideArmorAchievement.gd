extends Node


func _ready() -> void:
	pass


func _on_elevatorStarter_prepare() -> void:
	if GameManager.player and GameManager.player.ride:
		if GameManager.player.ride.name == "RideArmor":
			Achievements.unlock("PANDARIDEREACHED")
	pass # Replace with function body.
