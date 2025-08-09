extends SpecialAbilityAxl

onready var shooter: Node2D = $IceShooter
onready var particles: Array = get_all_particles()
onready var storm: AudioStreamPlayer2D = $storm
onready var snow_particles: Particles2D = $Snow
onready var sharp_particles: Particles2D = $IceShards

var storm_timer: float = 20.0


func deactivate() -> void :
	shooter.deactivate()
	queue_free()

func destroy(enemy) -> void :
	if typeof(enemy) == TYPE_STRING:
		if enemy == "boss":
			shooter.deactivate()
			queue_free()

func _physics_process(delta: float) -> void :
	._physics_process(delta)
	global_position = GameManager.camera.global_position
	snow_particles.global_position.x = character.global_position.x
	snow_particles.global_position.y = character.global_position.y + 12
	sharp_particles.global_position = character.global_position
	
	storm_timer -= delta
	if storm_timer <= 0:
		queue_free()

	if attack_stage == 0:
		screenshake()
		shooter.activate()
		storm.play()
		next_attack_stage()
		toggle_emit(particles, true)
	
	elif attack_stage == 1 and timer > 4.0:
		toggle_emit(particles, false)
		next_attack_stage()
