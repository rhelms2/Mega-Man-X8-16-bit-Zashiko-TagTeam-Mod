extends Area2D

export var bound_x := false
export var bound_y := true

var following_player
var needs_translation = false
onready var camera_limits = $camera_limits
onready var limit_left = camera_limits.global_position.x - camera_limits.shape.extents.x
onready var limit_right = camera_limits.global_position.x + camera_limits.shape.extents.x
onready var limit_up = camera_limits.global_position.y - camera_limits.shape.extents.y
onready var limit_down = camera_limits.global_position.y + camera_limits.shape.extents.y

func _ready() -> void:
# warning-ignore:return_value_discarded
	Event.listen("new_camera_bounds_set",self,"new_bounds_set")
# warning-ignore:return_value_discarded
	Event.listen("camera_movement_concluded",self,"done_moving")
# warning-ignore:return_value_discarded
	connect("body_entered",self,"update_camera_bounds")

func new_bounds_set(current_bounds) -> void:
	if current_bounds != self and following_player:
		following_player = false

func update_camera_bounds(_collider) -> void:
	if not following_player:
		following_player = true
		#print("Camera_Bounds: " + _collider.get_parent().name + " entered Camera Change zone")
		if bound_x:
			Event.emit_signal("new_camera_limits", limit_left, limit_right)
			Event.emit_signal("new_camera_bounds_set",self)
		if bound_y:
			
			#if get_camera_bounds_down() > limit_down:
				#GameManager.camera.set_abrupt_time()
	#			print("Moving camera from: " + str(get_camera_position()) + " to: " + str(limit_down- 112 ))
	#			Event.emit_signal("camera_move_y", limit_down- 112 )
	#			GameManager.camera.following_target = true
	#		else:
			Event.emit_signal("new_camera_limits", 0, 0, limit_up, limit_down)
			Event.emit_signal("new_camera_bounds_set",self)
		

func done_moving():
	if needs_translation:
		Event.emit_signal("new_camera_limits", 0, 0, limit_up, limit_down)
		needs_translation = false

func get_camera_position() -> float:
	return GameManager.camera.global_position.y

func get_camera_bounds_down() -> float:
	return GameManager.camera.global_position.y + 112
