extends Ability
class_name Rider

var ride : Node
var ride_animator

func _ready() -> void:
	if active:
		character.listen("ride",self,"_on_ride")
		character.listen("eject",self,"_on_eject")
	
func _on_ride(riden_object : Node) -> void:
	if active and not executing:
		set_ride(riden_object)
		ExecuteOnce()

func _on_eject(_riden_object : Node) -> void:
	if active and executing:
		EndAbility()

func _Setup() -> void:
	character.deactivate()
	character.disable_floor_snap()
	character.position = Vector2(0,0)
	character.stop_all_movement()
	ride_animator = ride.get_node("animatedSprite")

func _Interrupt() -> void:
	equalize_character_and_ride_directions()
	character.activate()
	character.make_visible()
	execute_jump()
	set_ride(null)
	Event.emit_signal("new_camera_focus", character)
	Event.emit_signal("camera_center")

func set_ride(object) -> void:
	ride = object
	character.ride = object

func execute_jump() -> void:
	if character.listening_to_inputs and Input.is_action_pressed("dash"):
		character.force_execute("DashJump")
	else:
		character.force_execute("Jump")

func _Update(_delta) -> void:
	equalize_character_and_ride_directions()
	equalize_character_and_ride_animations()

func equalize_character_and_ride_directions() -> void:
	if character.get_facing_direction() != ride.get_facing_direction():
		character.set_direction(ride.get_facing_direction())

func equalize_character_and_ride_animations() -> void:
	character.play_animation_once(ride.get_animation())
func _EndCondition() -> bool:
	return false

func is_high_priority() -> bool:
	return true
