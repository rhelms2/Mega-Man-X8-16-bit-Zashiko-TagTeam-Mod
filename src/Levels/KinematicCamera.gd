extends KinematicBody2D

onready var camera2D = $camera2D
var focus

var focus_ahead := 0.0
var camera_ahead := false
var speed

func _ready():
	#GameManager.camera = self
# warning-ignore:return_value_discarded
	Event.listen("screenshake",self,"add_trauma")
# warning-ignore:return_value_discarded
	Event.listen("new_camera_focus",self,"change_camera_focus")
# warning-ignore:return_value_discarded
	Event.listen("camera_move",self,"move_camera")
# warning-ignore:return_value_discarded
	Event.listen("camera_move_y",self,"move_camera_y")
# warning-ignore:return_value_discarded
	Event.listen("camera_ahead",self,"on_camera_ahead")
# warning-ignore:return_value_discarded
	Event.listen("camera_center",self,"on_camera_center")
# warning-ignore:return_value_discarded
	Event.listen("camera_follow_target",self,"camera_follow_target")
# warning-ignore:return_value_discarded
	Event.listen("new_camera_limits",self,"set_limits")
# warning-ignore:return_value_discarded
	#tween.connect("tween_completed",self,"movement_concluded")
	call_deferred("set_focus")

func set_focus():
	focus = GameManager.player

func _physics_process(delta: float) -> void:
	if focus:
		var focus_position = calculate_focus_position(delta)
		var distance = global_position.distance_to(focus_position)
		var direction = global_position.direction_to(focus_position) * distance
		speed = Vector2(direction.x * 45, direction.y * 80)
		speed = move_and_slide(speed)
			
	pass

func calculate_focus_position(delta) -> Vector2:
	var focus_distance_factor := 6
	var focus_ahead_speed_factor := 2
	if camera_ahead:
		focus_ahead -= (focus_ahead - focus.get_horizontal_speed()/focus_distance_factor ) * delta * focus_ahead_speed_factor
	else:
		focus_ahead = 0
	return Vector2(focus.global_position.x + focus_ahead, focus.global_position.y)

func change_camera_focus(new_focus : Node):
	Log.msg("Camera: Changing focus to: " + new_focus.name)
	#Log.msg("at : " +str(new_focus.position))
	focus = new_focus
	
func add_trauma():
	print_debug("Camera: calling method not implemented yet: add_trauma")
	pass
func move_camera():
	print_debug("Camera: calling method not implemented yet: move_camera")
	pass
func move_camera_y():
	print_debug("Camera: calling method not implemented yet: move_camera_y")
	pass
func on_camera_ahead():
	camera_ahead = true
	pass
func on_camera_center():
	camera_ahead = false
	print_debug("camera center")
	pass
func camera_follow_target():
	print_debug("Camera: calling method not implemented yet: camera_follow_target")
	pass
func set_limits():
	print_debug("Camera: calling method not implemented yet: set_limits")
	pass
