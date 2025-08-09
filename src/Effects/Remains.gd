extends Particles2D

func start():
	Tools.timer(2.0,"queue_free",self)
	emitting = true
	get_node("remains_particles").emitting = true
