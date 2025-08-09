extends EnemyDeath


func _ready() -> void:
	Event.connect("stage_rotate",self,"ons")
	pass

func emit_remains_particles():
	if GameManager.is_on_screen(global_position) and death_particle:
		var particle = death_particle.duplicate()
		character.get_parent().add_child(particle)
		particle.global_transform = character.global_transform
		particle.start()
		particle.rotation_degrees = GameManager.player.rotation_degrees
