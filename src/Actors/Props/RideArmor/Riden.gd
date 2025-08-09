extends Ride


func _ready() -> void:
	pass

func set_pitch_based_on_speed(_delta: float):
	return

func _physics_process(delta: float) -> void:
	process_gravity(delta)

func _Setup():
	#engine_started = true
	mount_audio.play()
	#audio.pitch_scale = 0.2
	get_parent().get_node("Enemy Collision Detector").add_to_group("Player")#TODO: Call deferred

func process_gravity(_delta:float, gravity := 800.0) -> void:
	character.add_vertical_speed(gravity * _delta)
	if character.get_vertical_speed() > character.maximum_fall_velocity:
		character.set_vertical_speed(character.maximum_fall_velocity) 
