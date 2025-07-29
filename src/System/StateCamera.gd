extends Camera2D
class_name StateCamera

const width: = 398
const height: = 224
onready var coll: CollisionShape2D = $area_limit_detector / collisionShape2D

var modes = []
var current_mode_x
var current_mode_y

var custom_limits_left: = - 1000000000.0
var custom_limits_right: = 1000000000.0
var custom_limits_top: = - 1000000000.0
var custom_limits_bot: = 1000000000.0

export  var ignore_limits: = false
var locked_camera: = false

signal start_translate_x(target_position)
signal start_translate_y(target_position)
signal start_zonetranslate_x(target_position)
signal start_zonetranslate_y(target_position)
signal start_doortranslate_x(target_position)
signal start_doortranslate_y(target_position)
signal start_follow_x(target)
signal start_follow_y(target)
signal start_transmission_x(target_position)
signal start_transmission_y(target_position)
signal translation_started
signal translation_finished

var trauma = 0.0
var decay = 1
var trauma_power = 3
const max_offset: = Vector2(4, 4)

var camera_offset: Vector2
onready var debugt: RichTextLabel = $debugtext
onready var offsetter: Node = $Offset
onready var debug2: RichTextLabel = $debugtext2
onready var debugtext_3: RichTextLabel = $debugtext3

var ignore_translate: = false

var areas = []

func _ready() -> void :
	GameManager.camera = self
	connect_events()
	call_deferred("set_gamemanager_camera")
	call_deferred("go_to_player")

func set_gamemanager_camera() -> void :
	GameManager.camera = self

func connect_events() -> void :
	Event.listen("screenshake", self, "add_trauma")

func go_to_player() -> void :
	current_mode_x = null
	current_mode_y = null
	global_position = player_pos()
	call_deferred("set_ignore_translate", false)

func go_to_position(pos) -> void :
	current_mode_x = null
	current_mode_y = null
	global_position = pos
	call_deferred("set_ignore_translate", false)


func _ignore_limits() -> void :
	ignore_limits = true

func enable_limits() -> void :
	ignore_limits = false


func set_ignore_translate(b: bool) -> void :
	ignore_translate = b

func _process(delta: float) -> void :
	var new_pos: = global_position
	new_pos = process_x(new_pos, delta)
	new_pos = process_y(new_pos, delta)
	new_pos = process_offset(new_pos, delta)
	new_pos = process_screenshake(new_pos, delta)
	debug_information()
	global_position = new_pos

func process_x(new_position, delta) -> Vector2:
	if current_mode_x:
		new_position.x = current_mode_x.update(delta).x
	elif not locked_camera:
		emit_signal("start_follow_x", GameManager.player)
	return new_position

func process_y(new_position, delta) -> Vector2:
	if current_mode_y:
		new_position.y = current_mode_y.update(delta).y
	elif not locked_camera:
		emit_signal("start_follow_y", GameManager.player)
	return new_position

func process_offset(new_position, delta) -> Vector2:
	new_position = offsetter.update(new_position, delta)
	return new_position

func process_screenshake(new_position: Vector2, delta) -> Vector2:
	trauma = max(trauma - decay * delta, 0)
	var amount = pow(trauma, trauma_power)
	offset.y = max_offset.y * amount * rand_range( - 1, 1)
	return new_position

func add_trauma(amount):
	trauma = min(trauma + amount, 1.0)
	trauma = clamp(trauma, 0.1, 1.5)

func on_area_exit(area: Area2D) -> void :
	if area in areas:
		areas.erase(area)
		if not is_door_translating():
			update_area_limits()
			if not ignore_translate:
				start_zonetranslate(get_nearest_position())

func on_area_enter(area: Area2D) -> void :
	if not area.disabled:
		include_area_limit(area)

func include_area_limit(area: Area2D) -> void :
	if not area in areas:
		areas.append(area)
	if not is_door_translating():
		update_area_limits(area)
		if not ignore_translate:
			start_translate(get_nearest_position())

func clear_area_limits() -> void :
	var reset_limits: = [ - 1000000000.0, 1000000000.0, - 1000000000.0, 1000000000.0]
	areas.clear()
	set_limits(reset_limits)

func start_translate(_position: Vector2) -> void :
	if needs_to_translate_on_x_axis():
		current_mode_x = null
		emit_signal("start_translate_x", _position)
	if needs_to_translate_on_y_axis():
		current_mode_y = null
		emit_signal("start_translate_y", _position)

func start_zonetranslate(_position: Vector2) -> void :
	if needs_to_translate_on_x_axis():
		current_mode_x = null
		emit_signal("start_zonetranslate_x", _position)
	if needs_to_translate_on_y_axis():
		current_mode_y = null
		emit_signal("start_zonetranslate_y", _position)

func start_door_translate(_position: Vector2, post_door_limits, should_lock: = false) -> void :
	
	current_mode_x = null
	current_mode_y = null
	if not post_door_limits in areas:
		areas.append(post_door_limits)
	toggle_lock_camera(should_lock)
	update_area_limits(post_door_limits)
	emit_signal("start_doortranslate_x", _position)
	emit_signal("start_doortranslate_y", _position)

func update_area_limits(recent_area = null) -> void :
	if not recent_area and areas.size() > 0:
		recent_area = areas[0]
		
	if recent_area:
		var combined_limits: = []
		combined_limits.append(recent_area.get_limit_left())
		combined_limits.append(recent_area.get_limit_right())
		combined_limits.append(recent_area.get_limit_top())
		combined_limits.append(recent_area.get_limit_bottom())
		combined_limits = combine_area_limits(combined_limits)
		set_limits(combined_limits)

func remove_disabled_areas() -> void :
	for area in areas:
		if area.disabled:
			
			areas.erase(area)

func combine_area_limits(limits: Array) -> Array:
	remove_disabled_areas()
	for area in areas:
		if area.get_limit_left() < limits[0]:
			limits[0] = area.get_limit_left()
		if area.get_limit_right() > limits[1]:
			limits[1] = area.get_limit_right()
		if area.get_limit_top() < limits[2]:
			limits[2] = area.get_limit_top()
		if area.get_limit_bottom() > limits[3]:
			limits[3] = area.get_limit_bottom()
	return limits

func get_current_limits() -> Array:
	remove_disabled_areas()
	
	var limits: = [areas[0][0], areas[0][1], areas[0][2], areas[0][3]]
	for area in areas:
		if area.get_limit_left() < limits[0]:
			limits[0] = area.get_limit_left()
		if area.get_limit_right() > limits[1]:
			limits[1] = area.get_limit_right()
		if area.get_limit_top() < limits[2]:
			limits[2] = area.get_limit_top()
		if area.get_limit_bottom() > limits[3]:
			limits[3] = area.get_limit_bottom()
	return limits

func force_update_limits():
	set_limits(get_current_limits())

func set_limits(limits: Array):
	custom_limits_left = limits[0]
	custom_limits_right = limits[1]
	custom_limits_top = limits[2]
	custom_limits_bot = limits[3]

func _physics_process(_delta: float) -> void :
	adjust_collisor_position()

func is_door_translating() -> bool:
	if current_mode_x:
		return current_mode_x.name == "DoorTranslateX"
	return false

func adjust_collisor_position() -> void :
	coll.global_position = GameManager.get_player_position()

func set_mode(mode_name: String, target) -> void :
	var mode = get_node(mode_name)
	mode.activate(target)

func include_mode(new_mode) -> void :
	modes.append(new_mode)

func emit_start_translate() -> void :
	emit_signal("translation_started")

func emit_finish_translate() -> void :
	emit_signal("translation_finished")

func toggle_lock_camera(v: bool) -> void :
	locked_camera = v
func lock_camera() -> void :
	locked_camera = true
func unlock_camera() -> void :
	locked_camera = false

func player_pos() -> Vector2:
	return GameManager.get_player_position() + camera_offset

func needs_to_translate_on_x_axis() -> bool:
	return is_over_left_limit(player_pos()) or is_over_right_limit(player_pos()) or is_too_far_x()
func needs_to_translate_on_y_axis() -> bool:
	return is_over_top_limit(player_pos()) or is_over_bottom_limit(player_pos()) or is_too_far_y()

func is_too_far_x(distance = 10) -> bool:
	return abs(global_position.x - player_pos().x) > distance
func is_too_far_y(distance = 10) -> bool:
	return abs(global_position.y - player_pos().y) > distance

func get_nearest_position(pos = null) -> Vector2:
	if not pos:
		pos = player_pos()
	
	if is_over_left_limit(pos):
		pos.x = custom_limits_left + float(width) / 2
	elif is_over_right_limit(pos):
		pos.x = custom_limits_right - float(width) / 2
	if is_over_top_limit(pos):
		pos.y = custom_limits_top + float(height) / 2
	elif is_over_bottom_limit(pos):
		pos.y = custom_limits_bot - float(height) / 2
	return pos

func get_nearest_position_inside_camera(pos = null) -> Vector2:
	if not pos:
		pos = global_position
	
	if pos.x < custom_limits_left:
		pos.x = custom_limits_left
	elif pos.x >= custom_limits_right:
		pos.x = custom_limits_right
	if pos.y < custom_limits_top:
		pos.y = custom_limits_top
	elif pos.y >= custom_limits_bot:
		pos.y = custom_limits_bot
	return pos

func is_over_left_limit(pos = player_pos()) -> bool:
	if ignore_limits:
		return false
	return get_raw_left_limit(pos) < custom_limits_left
func is_over_right_limit(pos = player_pos()) -> bool:
	if ignore_limits:
		return false
	return get_raw_right_limit(pos) >= custom_limits_right
func is_over_top_limit(pos = player_pos()) -> bool:
	if ignore_limits:
		return false
	return get_raw_top_limit(pos) < custom_limits_top
func is_over_bottom_limit(pos = player_pos()) -> bool:
	if ignore_limits:
		return false
	return get_raw_bottom_limit(pos) > custom_limits_bot

func is_constrained_horizontally() -> bool:
	if ignore_limits:
		return false
	return custom_limits_right - custom_limits_left <= width

func is_constrained_vertically() -> bool:
	if ignore_limits:
		return false
	return custom_limits_bot - custom_limits_top <= height

func get_raw_left_limit(pos) -> float:
	return pos.x - float(width) / 2
func get_raw_right_limit(pos) -> float:
	return pos.x + float(width) / 2
func get_raw_top_limit(pos) -> float:
	return pos.y - float(height) / 2
func get_raw_bottom_limit(pos) -> float:
	return pos.y + float(height) / 2

func get_boundary_position_left() -> float:
	return custom_limits_left + float(width) / 2
func get_boundary_position_right() -> float:
	return custom_limits_right - float(width) / 2
func get_boundary_position_top() -> float:
	return custom_limits_top + float(height) / 2
func get_boundary_position_bot() -> float:
	return custom_limits_bot - float(height) / 2

func debug_information() -> void :
	if GlobalVariables.get("ShowDebug"):
		debugt.text = ""
		if current_mode_x:
			debugt.text += ("modeX: " + current_mode_x.name + "\n")
		if current_mode_y:
			debugt.text += ("modeY: " + current_mode_y.name + "\n")
		debugt.text += str(round(global_position.x)) + ", " + str(round(global_position.y)) + "\n"
		for each in areas:
			debugt.text += each.name + " "
		debug2.text = str(get_boundary_position_left()) + "\n" + str(get_boundary_position_right()) + "\n" + str(get_boundary_position_top()) + "\n" + str(get_boundary_position_bot())
