class_name PitchStreamPlayer2D extends AudioStreamPlayer2D
export  var minimum_time: = 0.0
var can_play: = true
onready var original_pitch = pitch_scale

func play_once(random_pitch: = 0.07) -> void :
	if not playing:
		play_rp(random_pitch)

func play_rp(random_pitch: = 0.07, base_pitch: = 1.0) -> void :
	if can_play:
		pitch_scale = base_pitch
		pitch_scale += rand_range( - random_pitch, random_pitch)
		play()
		handle_minimun_time()
		
func play_r(random_pitch: = 0.03) -> void :
	if can_play:
		pitch_scale = original_pitch
		pitch_scale += rand_range( - random_pitch, random_pitch)
		play()
		handle_minimun_time()

func handle_minimun_time() -> void :
	if minimum_time > 0:
		can_play = false
		Tools.timer(minimum_time, "time_done", self)

func time_done() -> void :
	can_play = true

func fade_out(duration: = 0.25) -> void :
	var tween: = create_tween()

	tween.tween_property(self, "volume_db", - 80, duration)
	
