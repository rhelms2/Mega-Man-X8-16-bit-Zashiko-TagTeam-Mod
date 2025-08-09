extends VBoxContainer





onready var time_label = $Time


func _ready():
	time_label.text = IGT.time_formatting(IGT.in_game_timer)
	time_label.rect_scale = Vector2(0.8, 0.8)





