extends MusicPlayer

#export var miniboss_intro : AudioStream
#export var miniboss_song : AudioStream

func play_miniboss_song():
	Log("Starting Miniboss Song")
	volume_db = volume
	queue_loop_if_needed(miniboss_intro,miniboss_song)
	fade_out = false
	slow_fade_out= false
	play()
