extends Node2D

export  var boss_name: = "none"
export  var color: = Color.white

onready var active: AnimatedSprite = $active
onready var portal: Node2D = $Portal
onready var closed: CollisionShape2D = $staticBody2D / closed
onready var glass: Sprite = $glass
onready var particles: Particles2D = $remains_particles
onready var icebreak: AudioStreamPlayer2D = $icebreak


func _ready() -> void :
	active.modulate = color
	active.modulate.a = 0.8
	portal.connect("teleport_start", self, "on_teleport")
	Event.connect("gateway_crystal_get", self, "on_crystal_got")
	Event.connect("gateway_segment_cleared", self, "on_crystal_got")
	Event.connect("gateway_boss_defeated", self, "on_boss_defeated")
	Event.connect("gateway_lock_capsules", self, "on_lock")
	Event.connect("gateway_unlock_capsules", self, "unlock")
	Event.connect("gateway_full_reset", self, "full_lock")

func on_teleport():
	if boss_name == "none":
		push_error("Capsule without bossname set")
	else:
		Event.emit_signal("teleport_" + boss_name)

func on_lock():
	if is_active():
		lock()

func full_lock():
	closed.set_deferred("disabled", false)
	active.modulate.a = 0.3
	glass.visible = true
	portal.active = true
	active.visible = true

func lock():
	closed.set_deferred("disabled", false)
	active.modulate.a = 0.3
	glass.visible = true

func unlock():
	closed.set_deferred("disabled", true)
	active.modulate.a = 0.8
	glass.visible = false

func on_crystal_got(crystal_boss_name):
	if crystal_boss_name == boss_name:
		deactivate()

func on_boss_defeated(defeated_boss_name):
	if defeated_boss_name == boss_name:
		deactivate()

func deactivate():
	unlock()
	active.visible = false
	portal.active = false

func is_active() -> bool:
	return portal.active

func is_locked() -> bool:
	return not closed.disabled

func _on_projectile_entered(body: Node) -> void :
	if is_locked():
		if "BlastLaunch" in body.name:
			body.deflect(get_parent())
			break_lock()
		if "Saber" in body.name:
			if body.break_guards:
				body.deflect(get_parent())
				break_lock()
		if "Rekkyoudan" in body.name:
			if body.break_guards:
				body.deflect(get_parent())
				break_lock()
		if "Youdantotsu" in body.name:
			if body.break_guards:
				body.deflect(get_parent())
				break_lock()

func break_lock():
	unlock()
	icebreak.play()
	particles.emitting = true
	Event.emit_signal("screenshake", 2.0)
