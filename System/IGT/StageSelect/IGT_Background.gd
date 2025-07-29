extends ColorRect

onready var rta_time = $RTAContainer / TotalTime


func _process(_delta):
	rta_time.text = IGT.time_formatting(IGT.rta_timer)

func _ready():
	if Configurations.get("ShowIGT"):
		self.visible = true
	else:
		self.visible = false
	Configurations.listen("value_changed", self, "on_showigt")

func on_showigt(key) -> void :
	if key == "ShowIGT":
		if Configurations.get(key):
			show_igt()
		else:
			show_igt(false)

func show_igt(show = true) -> void :
	self.visible = show
