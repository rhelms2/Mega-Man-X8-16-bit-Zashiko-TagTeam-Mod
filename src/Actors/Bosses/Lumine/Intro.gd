extends GenericIntro

export  var song_intro: AudioStream
export  var song_loop: AudioStream
export  var boss_bar: Texture

onready var sprite: AnimatedSprite = $"../animatedSprite"
onready var tween: TweenController = TweenController.new(self, false)
onready var space: Node = $"../Space"
onready var rotating_crystals: Node2D = $"../RotatingCrystals"
onready var song_remix_loop: AudioStream = preload("res://Remix/Songs/Lumine Battle 1 - Loop.ogg")


func _ready() -> void :
	if Configurations.exists("SongRemix"):
		if Configurations.get("SongRemix"):
			song_intro = load("")
			song_loop = song_remix_loop
			song_loop.loop = true

func connect_start_events() -> void :
	call_deferred("prepare_for_intro")
	Tools.timer(1, "execute_intro", self)
	

func prepare_for_intro() -> void :
	sprite.position.y = - 250
	character.global_position.y = raycast_downward(256)["position"].y
	Log("Preparing for Intro")

func _Update(delta):
	if attack_stage == 0:
		play_animation("intro_descent")
		tween.create(Tween.EASE_OUT,Tween.TRANS_QUAD)
		tween.add_attribute("position:y",0,3.0,sprite)
		tween.add_callback("next_attack_stage")
		next_attack_stage()
	
	# attack_stage == 1 is descent
	
	elif attack_stage == 2:
		play_animation("intro_idle")
		next_attack_stage()
		
	elif attack_stage == 3 and timer > 1:
		play_animation("open")
		start_dialog_or_go_to_attack_stage(5)
		
	elif attack_stage == 4:
		if seen_dialog():
			next_attack_stage()
			
	elif attack_stage == 5 and timer > 0.75:
		play_animation("fly_start")
		go_to_center()
		rotating_crystals.expand_crystals()
		GameManager.music_player.play_song_wo_fadein(song_loop,song_intro)
		Event.emit_signal("set_boss_bar",boss_bar)
		Event.emit_signal("boss_health_appear", character)
		next_attack_stage()
	
	# attack_stage == 6 is going to center
	
	elif attack_stage == 7:
		#GameManager.player.stop_forced_movement()
		#Tools.timer(0.1,"stop_forced_movement",)
		EndAbility()
			

func go_to_center() -> void:
	var pos = space.get_center()
	var time_to_return = space.time_to_position(pos,60)
	tween.create(Tween.EASE_IN_OUT,Tween.TRANS_QUAD)
	tween.add_attribute("global_position",pos,time_to_return,character)
	tween.add_callback("next_attack_stage")
