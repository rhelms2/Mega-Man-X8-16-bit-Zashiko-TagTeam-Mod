extends WeaponAxl
class_name PistolAlternate

export  var weapon: Resource
export  var _sprites_weapon: SpriteFrames
export  var _sprites_weapon_B: SpriteFrames


func _ready() -> void :
	._ready()
	Event.listen("shot_lemon", self, "on_lemon_shot_created")

func on_lemon_shot_created(emitter, shot) -> void :
	if emitter != self:
		connect_shot_event(shot)

func add_projectile_to_scene(charge_level) -> void :
	var shot = .add_projectile_to_scene(charge_level)
	Event.emit_signal("shot_lemon", self, shot)
	connect_charged_shot_event(shot)

func has_ammo() -> bool:
	return charged_shots_currently_alive < max_charged_shots_alive

func connect_charged_shot_event(_shot) -> void :
	_shot.connect("projectile_started", self, "on_charged_shot_created")
	_shot.connect("projectile_end", self, "on_charged_shot_end")
	if _shot.has_method("set_creator"):
		_shot.set_creator(arm_cannon.character)
	if _shot.has_method("initialize"):
		_shot.call_deferred("initialize", arm_cannon.character.get_facing_direction())
