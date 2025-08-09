extends Camera2D
class_name X8Camera

const width: = 398
const height: = 224

var modes = []
var current_mode
var current_mode_x
var current_mode_y

signal start_translate(target_position)
signal start_translate_x(target_position)
signal start_translate_y(target_position)
signal translation_started_x
signal translation_finished
signal translation_started_y
signal translation_finished_y

func _ready() -> void :
	GameManager.camera = self

func _process(delta: float) -> void :
	var new_position: = global_position
	
	if current_mode_x:
		new_position.x = current_mode_x.update(delta).x
	else:
		set_mode("FollowPlayerX", GameManager.player)

	if current_mode_y:
		new_position.y = current_mode_y.update(delta).y
	else:
		set_mode("FollowPlayerY", GameManager.player)
		
	global_position = new_position

func set_mode(mode_name: String, target) -> void :
	var mode = get_node(mode_name)
	mode.activate(target)

func include_mode(new_mode) -> void :
	modes.append(new_mode)

func emit_start_translate() -> void :
	emit_signal("translation_started")
	
func emit_finish_translate() -> void :
	emit_signal("translation_finished")

func start_translate(_position: Vector2) -> void :
	emit_signal("start_translate", _position)

func start_translate_x(_position: Vector2) -> void :
	emit_signal("start_translate_x", _position)

func start_translate_y(_position: Vector2) -> void :
	emit_signal("start_translate_y", _position)
	
func set_position(pos: Vector2) -> void :
	global_position = pos

func set_x(pos: float) -> void :
	global_position.x = pos

func set_y(pos: float) -> void :
	global_position.y = pos
