extends Node

const sections := 13
var in_game_timer: float = 0.0
var stage_timer: float = 0.0
var should_run: bool = true
var rta_timer: float = 0.0
var should_run_rta: bool = true
var times : Dictionary = {}

var current_section: String

func _process(delta: float) -> void :
	if should_run_rta:
		rta_timer += delta

func reset_rta():
	rta_timer = 0.0
	should_run_rta = false

func _ready():
	set_pause_mode(Node.PAUSE_MODE_PROCESS)
	var time = GlobalVariables.get("igt")
	set_time(time if time != null else 0.0)

func set_timer_running(_should_run):
	should_run = _should_run

func save_time():
	IGT.should_run = false
	GlobalVariables.set("igt", IGT.in_game_timer)
	Savefile.save(Savefile.save_slot)

func add_time(section,delta):
	if times.has(section):
		times[section] += delta
	else:
		times[section] = 0.0

func reset():
	times.clear()

func clocked_all_stages() -> bool:
	return times.size() == sections


func set_time(time):
	in_game_timer = time

func reset_stage_timer():
	stage_timer = 0.0

func time_formatting(accumulated_time):
	
	var hours = int(accumulated_time) / 3600
	var minutes = (int(accumulated_time) %3600) / 60
	var seconds = int(accumulated_time) %60

	
	var milliseconds = int(accumulated_time * 100) %100

	
	var hours_str = str(hours).pad_zeros(2)
	var minutes_str = str(minutes).pad_zeros(2)
	var seconds_str = str(seconds).pad_zeros(2)
	var milliseconds_str = str(milliseconds).pad_zeros(2)

	
	var time_string = hours_str + ":" + minutes_str + ":" + seconds_str + "." + milliseconds_str
	return time_string
