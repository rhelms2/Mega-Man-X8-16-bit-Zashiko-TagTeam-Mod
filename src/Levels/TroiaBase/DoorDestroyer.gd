extends Area2D

onready var reward_door: StaticBody2D = $"../RewardDoor"
onready var reward_door_2: StaticBody2D = $"../RewardDoor2"
onready var troia_particles: Particles2D = $troia_particles
onready var troia_particles_2: Particles2D = $troia_particles2


func _ready() -> void :
	get_parent().connect("script_changed", self, "_on_combo_section_setup")

func _on_combo_section_setup():
	get_parent().connect("open_doors", self, "_on_open_doors")

func _process(_delta: float) -> void :
	if not get_parent().is_connected("open_doors", self, "_on_open_doors"):
		get_parent().connect("open_doors", self, "_on_open_doors")

func _on_open_doors() -> void :
	monitoring = false
	reward_door.queue_free()
	reward_door_2.queue_free()
	Tools.timer(0.5, "deactivate_particles", self)

func _on_DoorDestroyer_body_entered(body: Node) -> void :
	if "ThunderDancerCharged" in body.name and is_instance_valid(reward_door):
		monitoring = false
		reward_door.queue_free()
		reward_door_2.queue_free()
		Tools.timer(0.5, "deactivate_particles", self)

func deactivate_particles() -> void :
	troia_particles.emitting = false
	troia_particles_2.emitting = false
