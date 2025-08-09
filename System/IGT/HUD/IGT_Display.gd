extends ColorRect


onready var rta_time = $RTAContainer / TotalTime
onready var total_time = $TimeContainer / TotalTime
onready var stage_time = $marginContainer / StageTime

func _ready():
	pause_mode = Node.PAUSE_MODE_PROCESS
	if Configurations.get("ShowIGT"):
		self.visible = true
	else:
		self.visible = false

func _process(delta):
	rta_time.text = IGT.time_formatting(IGT.rta_timer)
	total_time.text = IGT.time_formatting(IGT.in_game_timer)
	if IGT.times.has(IGT.current_section):
		stage_time.text = IGT.time_formatting(IGT.times[IGT.current_section])
