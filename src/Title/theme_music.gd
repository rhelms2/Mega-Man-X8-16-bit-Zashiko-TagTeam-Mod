extends SimpleMusicPlayer

onready var title_screen_remix: AudioStream = preload("res://Remix/Songs/Title Screen.ogg")


func _ready() -> void :
	Event.listen("fadeout_startmenu", self, "fade_out")
	if Configurations.exists("SongRemix"):
		if Configurations.get("SongRemix"):
			stream = title_screen_remix

func fade_out() -> void :
	var t = create_tween()
	t.tween_property(self, "volume_db", - 80, 4)
