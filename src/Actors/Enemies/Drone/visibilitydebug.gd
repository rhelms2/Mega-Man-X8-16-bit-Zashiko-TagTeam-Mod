extends Node

onready var drone: KinematicBody2D = $"../.."

#func _physics_process(delta: float) -> void:
	#print(drone.active)

func _on_visibilityNotifier2D_screen_exited() -> void:
		#print("Drone ::: screen exited")
		pass

func _on_visibilityNotifier2D_screen_entered() -> void:
		#print("Drone ::: screen entered")
		pass
