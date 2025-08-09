extends Camera2D

export var decay = 0.8  # How quickly the shaking stops [0, 1].
export var max_offset = Vector2(0, 15)  # Maximum hor/ver shake in pixels.
export var max_roll = 0.0  # Maximum rotation in radians (use sparingly).
var target : Node  # Assign the node this camera will follow.

var following_target := true

export var trauma = 0.0  # Current shake strength.
var trauma_power = 2  # Trauma exponent. Use [2, 3].
var timer := 0.0
var shake_step := 0.032
var shake_time := 0.0

var camera_ahead := false
var camera_ahead_movement := 0.0
var camera_ahead_distance := 50.0

var new_limit_left := 0.0

var abrupt_movement_time := 0.0

onready var drag_top := drag_margin_top
onready var drag_bottom := drag_margin_bottom
var should_reduce_drag := false

onready var original_drag_down := drag_margin_bottom
onready var original_drag_top := drag_margin_top

onready var original_limit_right := limit_right
onready var original_limit_down := limit_bottom
onready var original_limit_left := limit_left
onready var original_limit_top := limit_top

func _ready():
	timer += 0.5
	Engine.set_target_fps(Engine.get_iterations_per_second())
	GameManager.camera = self
	Event.listen("screenshake",self,"add_trauma")
	Event.listen("new_camera_focus",self,"change_camera_focus")
	Event.listen("camera_move",self,"move_camera")
	Event.listen("camera_move_y",self,"move_camera_y")
	Event.listen("camera_ahead",self,"on_camera_ahead")
	Event.listen("camera_center",self,"on_camera_center")
	Event.listen("camera_follow_target",self,"camera_follow_target")
	Event.listen("new_camera_limits",self,"set_limits")

func camera_follow_target():
	following_target = true
	
func on_camera_ahead():
	camera_ahead = true
	camera_ahead_movement = 1

func set_camera_ahead(ahead):
	camera_ahead_distance = ahead

func on_camera_center():
	Log.msg("Camera: Centering camera")
	camera_ahead = false
	pass


func pause_drag():
	should_reduce_drag = true
	limit_left = -10000000
	limit_right = 10000000
	limit_bottom = 10000000
	limit_top= -10000000

func set_limits(new_left = null, new_right = null, new_top = null, new_bottom = null):
	if new_left != null:
		limit_left= new_left
	
	if new_right != null:
		limit_right = new_right
	
	if new_top != null:
		limit_top= new_top
		
	if new_bottom != null:
		limit_bottom = new_bottom

func move_camera(new_pos : Vector2, timing := 2.1):
		following_target = false
		var tween = create_tween()
		tween.tween_property(self, "position", new_pos, timing)

func lerp_drag(destiny_value := 0.2): #default is 0.2
	var tween = create_tween()
	tween.tween_property(self, "drag_margin_top", destiny_value, 0.5)
	tween.parallel().tween_property(self, "drag_margin_bottom", destiny_value, 0.5)


func move_camera_y(new_pos : float, timing := 0.5):
		following_target = false
		var final_pos = Vector2 (global_position.x, new_pos)
		var tween = create_tween()
		tween.tween_property(self, "position", final_pos, timing)
		tween.tween_property(self, "drag_margin_top", 0.2, 0.1)
		tween.parallel().tween_property(self, "drag_margin_bottom", 0.2, 0.1)


func resume_drag():
	drag_margin_top = drag_top
	drag_margin_bottom = drag_bottom
	should_reduce_drag = false

func reduce_drag(_delta):
	if should_reduce_drag:
		drag_margin_bottom = lerp(drag_margin_bottom, 0, 0.01) 
		drag_margin_top = lerp(drag_margin_top, 0, 0.01) 
	else:
		drag_margin_bottom = lerp(drag_margin_bottom, original_drag_down,0.01) 
		drag_margin_top = lerp(drag_margin_top, original_drag_top, 0.01) 

func add_trauma(amount):
	trauma = min(trauma + amount, 1.0)
	clamp(trauma, 0.1, 0.5)

func set_abrupt_time():
	abrupt_movement_time = timer

func round_position_on_pause():
	if position.x != round(position.x) and get_tree().paused == true:
		position.x = round(position.x)
		position.y = round(position.y)
		return

func _process(delta: float) -> void:
	timer += delta
	follow_target(delta)
	handle_trauma(delta)

func follow_target(delta):
	if following_target and target:
		var step = smoothstep(abrupt_movement_time, abrupt_movement_time + 0.75, timer)
		global_position.x = lerp(global_position.x, target.global_position.x + camera_ahead_movement, step) 
		global_position.y = target.global_position.y
		clamp_position_based_on_limits()
		handle_camera_ahead(delta)
		reduce_drag(delta)

func clamp_position_based_on_limits():
	if global_position.x < limit_left + 398/2:
		global_position.x = limit_left + 398/2
	if global_position.x > limit_right - 398/2:
		global_position.x = limit_right - 398/2
	

func handle_camera_ahead(delta):
	if camera_ahead and target.is_in_group("Bike"):
		if target.get_facing_direction() > 0:
			if global_position.x < target.global_position.x + camera_ahead_distance * target.get_facing_direction():
				camera_ahead_movement +=  abs(target.get_actual_speed()/3) * target.get_facing_direction() * delta
		else:
			if global_position.x > target.global_position.x + camera_ahead_distance * target.get_facing_direction():
				camera_ahead_movement += abs(target.get_actual_speed()/3) * target.get_facing_direction() * delta
	else:
		if abs(camera_ahead_movement) > 0.1:
			camera_ahead_movement = camera_ahead_movement * 0.92

func handle_trauma(delta):
	if trauma:
		trauma = max(trauma - decay * delta, 0)
		if timer > shake_time:
			shake()
			shake_time += shake_step
	

func change_camera_focus(new_focus : Node) -> void:
	Log.msg("Camera: Changing focus to: " + new_focus.name)
	Log.msg("at : " +str(new_focus.position))
	target = new_focus

func _on_debug_text():
	pass

func shake():
	var amount = pow(trauma, trauma_power)
	offset.x = max_offset.x * amount * rand_range(-1, 1)
	offset.y = max_offset.y * amount * rand_range(-1, 1)

func check_for_boundaries() -> void:
	pass
#	
