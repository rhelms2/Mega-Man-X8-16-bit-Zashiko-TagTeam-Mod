extends MusicPlayer

export  var lava_intro: AudioStream
export  var lava_song: AudioStream


func play_lava_song() -> void :
	volume_db = volume + 5
	play_song(lava_song, lava_intro)
