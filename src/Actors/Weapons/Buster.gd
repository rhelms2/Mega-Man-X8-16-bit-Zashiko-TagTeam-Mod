extends Weapon
class_name Buster


func _ready() -> void :
	._ready()
	Event.listen("shot_lemon", self, "on_lemon_shot_created")

func on_lemon_shot_created(emitter, shot: KinematicBody2D) -> void :
	if emitter != self:
		connect_shot_event(shot)

func add_projectile_to_scene(charge_level: int):
	var shot: KinematicBody2D = .add_projectile_to_scene(charge_level)
	if charge_level < 1:
		Event.emit_signal("shot_lemon", self, shot)

func has_ammo() -> bool:
	return shots_currently_alive < max_shots_alive

func connect_charged_shot_event(_shot: KinematicBody2D) -> void :
	_shot.connect("projectile_started", self, "on_charged_shot_created")
	_shot.connect("projectile_end", self, "on_charged_shot_end")
	if _shot.has_method("set_creator"):
		_shot.set_creator(arm_cannon.character)
	if _shot.has_method("initialize"):
		_shot.call_deferred("initialize", arm_cannon.character.get_facing_direction())
