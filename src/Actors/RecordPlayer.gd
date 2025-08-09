extends AnimatedSprite

var recording = []
var game_frame := 0

func _ready() -> void:
	if GameManager.time_attack:
		frame = 0
		Event.listen("gameplay_start",self,"play_recording")

func play_recording():
	if GameManager.best_recording.size() > 0:
		recording = GameManager.best_recording
		print("RecPlayer: Load succesful.")
		return
	else:
		print("RecPlayer: Not able to load.")

func _physics_process(_delta: float) -> void:
	if GameManager.time_attack:
		if  has_recording() and not is_ahead():
			global_position = recording[game_frame].position
			
			if animation != recording[game_frame].animation:
				play(recording[game_frame].animation)
			
			game_frame += 1
	

func has_recording() -> bool:
	return recording.size() > 0 and game_frame < recording.size()-1

func is_ahead() -> bool:
	if OS.get_ticks_msec() - GameManager.get_stage_start_msec() < recording[game_frame].time:
		print("RecPlayer: Is ahead.")
		return true
	return false
