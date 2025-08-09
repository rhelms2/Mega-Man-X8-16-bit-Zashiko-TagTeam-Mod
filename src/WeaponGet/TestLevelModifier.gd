extends Node
onready var spike_row: Node2D = $"../Objects/SpikeRow"
onready var servbot: KinematicBody2D = $"../Objects/Servbot"
onready var servbot_2: KinematicBody2D = $"../Objects/Servbot2"
onready var servbot_3: KinematicBody2D = $"../Objects/Servbot3"

onready var drone_2: KinematicBody2D = $"../Objects/Drone2"

func _on_WeaponGetScreen_weapon_defined(weapon: WeaponResource) -> void :
	if not weapon.collectible == "panda_weapon":
		call_deferred("delete_spikes")
	if weapon.collectible == "sunflower_weapon":
		call_deferred("delete_servbots")
	else:
		call_deferred("delete_drones")

func delete_spikes():
	spike_row.queue_free()
	
func delete_servbots():
	servbot.queue_free()
	servbot_2.queue_free()
	servbot_3.queue_free()

func delete_drones():
	drone_2.queue_free()
