extends BikeMovement
class_name HyperDash

export var duration := 0.75
export var charges := 0
onready var effect := get_node("hyperdash_effect")
onready var particles = get_parent().get_node("animatedSprite").get_node("particles2D")

var initial_vertical_position : float
var changed_vertical_position := false

signal hyperdash

func _ready() -> void:
# warning-ignore:return_value_discarded
	character.listen("death",self,"on_land")

func get_shot_adust_position() -> Vector2:
	return Vector2(-5, -20)

func _Setup():
	initial_vertical_position = global_position.y
	changed_vertical_position = false
	disable_camera_offset()
	set_vertical_speed(0)
	emit_particles(particles)
	effect.set_modulate(Color.white)
	effect.scale.x = character.get_facing_direction()
	charges -=1
	effect.visible = true
	character.disable_floor_snap()
	set_actual_speed(horizontal_velocity * character.get_facing_direction() )
	emit_signal("hyperdash")

func _StartCondition() -> bool:
	return not character.is_on_floor() and charges > 0

func _Update(_delta: float) -> void:
	delta = _delta
	if not character.is_executing("Riden"):
		if not character.has_health() and effect.visible:
			effect.visible = false
	process_speed()
	force_movement_regardless_of_direction(get_actual_speed())
	if has_changed_vertical_position():
		process_gravity(_delta, 700)

func has_changed_vertical_position() -> bool:
	if changed_vertical_position:
		return true
	elif initial_vertical_position != global_position.y:
		changed_vertical_position = true
		return true
	
	return false

func _Interrupt():
	emit_particles(particles,false)
	
func _physics_process(delta: float) -> void:
	if not executing and character.is_on_floor():
		on_land()
	elif effect.visible and not executing and not character.is_on_floor():
		effect.set_modulate(Color(1,1,1, effect.modulate.a - delta * 8))

func on_land():
	if charges < 1:
		charges = 1
	if effect.visible:
		effect.visible = false

func _EndCondition() -> bool:
	if character.is_colliding_with_wall() != 0:
		if character.is_colliding_with_wall() == character.get_facing_direction():
			effect.visible = false
			return true
	return timer > duration
