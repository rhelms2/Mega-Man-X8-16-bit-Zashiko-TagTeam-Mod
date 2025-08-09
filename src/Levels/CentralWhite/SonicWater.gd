extends Particles2D
onready var manta_ray: KinematicBody2D = $"../MantaRay"

func _physics_process(_delta: float) -> void:
	if is_instance_valid(manta_ray):
		visible = manta_ray.animatedSprite.visible
		modulate.a = inverse_lerp(-100,100,manta_ray.position.y)
		process_material.scale = clamp(inverse_lerp(-100,0,manta_ray.position.y),0,1.5)
		global_position.x = manta_ray.global_position.x
		emitting = manta_ray.global_position.y < global_position.y
	else:
		set_physics_process(false)
