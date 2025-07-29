extends Particles2D
onready var shutdown: AudioStreamPlayer2D = $"../shutdown"
onready var shutdown_2: AudioStreamPlayer2D = $"../shutdown2"
onready var startup: AudioStreamPlayer2D = $"../startup"
onready var startup_2: AudioStreamPlayer2D = $"../startup2"
onready var loop: AudioStreamPlayer2D = $"../loop"
export  var doorblock: NodePath

func play_start_sound() -> void :
	startup.play()
	startup_2.play()
	loop.play()
	
	get_node(doorblock).set_deferred("disabled", false)

func emit() -> void :
	emitting = true
	shutdown.play()
	shutdown_2.play()
	loop.stop()
