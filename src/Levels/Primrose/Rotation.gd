extends Node2D

export  var able_to_rotate: = true
const rotation_duration: = 1.5
var objects_to_counter_rotate: Array
var objects_to_rotate: Array
var tween: SceneTreeTween

func _ready() -> void :
	Event.listen("rotate_stage_in_degrees", self, "rotate_stage_in_degrees")
	Event.listen("rotate_exception", self, "add_to_counter_rotate")
	Event.listen("rotate_inclusion", self, "add_to_rotate")

func add_to_counter_rotate(object) -> void :
	objects_to_counter_rotate.append(object)
	
func add_to_rotate(object) -> void :
	objects_to_rotate.append(object)

func rotate_stage_in_degrees(degrees: float, room: Node2D) -> void :
	if able_to_rotate:
		Event.emit_signal("stage_rotate")
		call_deferred("after_rotate_stage_signal", degrees, room)

func after_rotate_stage_signal(degrees: float, room: Node2D) -> void :
	pause_and_prepare_camera()
	setup_rotation_tween(degrees, room)
	setup_objects_rotation(degrees)
	setup_counter_rotation(degrees)
	setup_callbacks_after_rotation()
	

func pause_and_prepare_camera() -> void :
	GameManager.primrose_pause()
	set_camera_to_process()

func setup_rotation_tween(degrees: float, room: Node2D) -> void :
	tween = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
	tween.set_pause_mode(SceneTreeTween.TWEEN_PAUSE_PROCESS)
	tween.set_parallel()
	tween.tween_property(room, "rotation_degrees", room.rotation_degrees + degrees, rotation_duration)

func setup_counter_rotation(degrees: float) -> void :
	for object in objects_to_counter_rotate:
		tween.tween_property(object, "rotation_degrees", object.rotation_degrees - degrees, rotation_duration)
	objects_to_counter_rotate.clear()
	
func setup_objects_rotation(degrees: float) -> void :
	for object in objects_to_rotate:
		tween.tween_property(object, "rotation_degrees", object.rotation_degrees + degrees, rotation_duration)
	objects_to_rotate.clear()

func setup_callbacks_after_rotation() -> void :
	tween.set_parallel(false)
	tween.tween_callback(self, "emit_rotate_end")
	tween.tween_callback(GameManager, "primrose_unpause")
	tween.tween_callback(GameManager, "end_cutscene")
	tween.tween_callback(self, "set_camera_to_inherit")

func emit_rotate_end() -> void :
	Event.emit_signal("stage_rotate_end")

func set_camera_to_process() -> void :
	
	GameManager.camera.start_translate(GameManager.get_player_position())
	GameManager.camera.set_pause_mode(Node.PAUSE_MODE_PROCESS)
func set_camera_to_inherit() -> void :
	GameManager.camera.set_pause_mode(Node.PAUSE_MODE_INHERIT)
	
	
