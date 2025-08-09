extends WeaponAxl
class_name Pistol

export  var weapon: Resource
export  var _sprites_weapon: SpriteFrames
export  var _sprites_weapon_B: SpriteFrames

var bullet_count: int = 0


func _ready() -> void :
	._ready()
	Event.listen("shot_lemon", self, "on_lemon_shot_created")

func fire(_charge_level: = 0) -> void :
	add_projectile_to_scene(0)
	reduce_ammo(ammo_per_shot)
	Event.emit_signal("shot", self)
	
func add_projectile_to_scene(charge_level: int) -> void :
	var shot_direction_node = character.get_node("ShotDirection")
	var _shot
	_shot = shots[charge_level].instance()
	var horizontal_dir = character.get_facing_direction()
	var vertical_dir = - 1
	if Input.is_action_pressed("move_up"):
		vertical_dir = - 1
	elif Input.is_action_pressed("move_down"):
		vertical_dir = 1
		
	character.get_node("offset manager").get_offset()
	shot_direction_node.projectile_speed_control(_shot, bullet_speed, horizontal_dir, vertical_dir)
	bullet_count += 1
	if bullet_count >= 8:
		_shot.blue_bullet = true
		bullet_count = 0
	get_tree().current_scene.add_child(_shot, true)
	position_shot(_shot)
	connect_shot_event(_shot)
	_shot.damage = projectile_damage
	_shot.damage_to_bosses = projectile_damage_to_bosses
	_shot.damage_to_weakness = projectile_damage_to_weakness
	Event.emit_signal("shot_lemon", self, _shot)

func on_lemon_shot_created(emitter, shot) -> void :
	if emitter != self:
		connect_shot_event(shot)

func has_ammo() -> bool:
	return shots_currently_alive < max_shots_alive

func connect_charged_shot_event(_shot) -> void :
	_shot.connect("projectile_started", self, "on_charged_shot_created")
	_shot.connect("projectile_end", self, "on_charged_shot_end")
	if _shot.has_method("set_creator"):
		_shot.set_creator(arm_cannon.character)
	if _shot.has_method("initialize"):
		_shot.call_deferred("initialize", arm_cannon.character.get_facing_direction())
