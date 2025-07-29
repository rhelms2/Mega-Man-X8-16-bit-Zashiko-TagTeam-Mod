extends AnimatedSprite

onready var death_plane: Area2D = $death_plane
onready var detector_collider: CollisionShape2D = $damage_detector / collisionShape2D
onready var remains_particles: Particles2D = $remains_particles
onready var _break: AudioStreamPlayer2D = $break
onready var current_rotation = get_parent().rotation_degrees

var destroyed: bool = false


func _on_damage_detector_body_entered(body: Node) -> void :
	if destroyed:
		return
	if "BlastLaunch" in body.name:
		body.hit(self)
		call_deferred("destroy")
	elif "Juuhazan_Charged_B" in body.name:
		call_deferred("destroy")
	elif "Youdantotsu" in body.name:
		call_deferred("destroy")
	elif "Enkoujin_Charged_B" in body.name:
		call_deferred("destroy")
	elif "NovaStrike" in body.name:
		call_deferred("destroy")
	elif "IntenseExplosion" in body.name:
		call_deferred("destroy")
	elif "CrystalBouncerCharged" in body.name:
		call_deferred("destroy")
	elif "FireDashCharged" in body.name:
		call_deferred("destroy")
	elif "Hurtbox" in body.name:
		if "RideArmor" in body.get_parent().name:
			call_deferred("destroy")
	elif "RideArmorPunch" in body.name:
		call_deferred("destroy")

func destroy() -> void :
	destroyed = true
	death_plane.deactivate()
	_break.play_rp()
	detector_collider.disabled = true
	play(animation + "_destroyed")
	remains_particles.rotation_degrees = - current_rotation
	remains_particles.emitting = true

func damage(_d = null, _s = null) -> float:
	return 1.0
