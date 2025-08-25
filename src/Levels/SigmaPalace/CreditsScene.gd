extends Node2D

export  var song: AudioStream

onready var tween: TweenController = TweenController.new(self, false)
onready var visuals: Node2D = $Visuals
onready var credits_bg: Sprite = $CreditsBG
onready var musicplayer: AudioStreamPlayer = $"Music Player"
onready var screencover: Sprite = $screencover
onready var credits: Node2D = $Credits
onready var credits_part1: RichTextLabel = $Credits / richTextLabel
onready var credits_part2: RichTextLabel = $Credits / richTextLabel2
onready var bottom_cover: Sprite = $bottom_cover
onready var top_cover: Sprite = $top_cover
onready var loop: AudioStreamPlayer2D = $Visuals / ElevatorPlatform / loop
onready var _x_sprite: AnimatedSprite = $Visuals / ElevatorPlatform / X
onready var _axl_sprite: AnimatedSprite = $Visuals / ElevatorPlatform / Axl
onready var _zero_sprite: AnimatedSprite = $Visuals / ElevatorPlatform / Zero
onready var finalrta = $FinalTime / RTADisplay / Time
onready var finaltime = $FinalTime / IGTDisplay / Time
onready var bitmap_font: BitmapFont = preload("res://src/Fonts/x8bitmapfontfinal.fnt")

var scroll_speed: float = 1.0
var base_duration: float = 158.0
var total_height: float = 0
var fade_out_duration: float = 6.0

func axl_credits():
	CharacterManager.set_axl_colors(_axl_sprite)

func zero_credits():
	CharacterManager.set_zero_colors(_zero_sprite)

func _ready() -> void :
	axl_credits()
	zero_credits()
	
	Tools.timer(1, "fade_in", self)
	Tools.timer(0.02, "start", self)
	var final_rta = IGT.time_formatting(IGT.rta_timer)
	finalrta.text = final_rta
	var final_time = IGT.time_formatting(IGT.in_game_timer)
	finaltime.text = final_time

	Tools.timer(0.35, "start_music", self)
	Tools.timer(3.0, "roll_up_credits", self)

func start():
	move_to_the_side()
	move_credits_in()

func start_music():
	musicplayer.play_song(song)

func move_to_the_side():
	tween.create(Tween.EASE_IN_OUT, Tween.TRANS_SINE)
	tween.add_attribute("position:x", - 100, 6.0, visuals)

func move_credits_in():
	tween.create(Tween.EASE_IN_OUT, Tween.TRANS_SINE)
	tween.add_attribute("position:x", 180, 6.0, credits_bg)
	

func turn_on_covers():
	var final_y = bottom_cover.position.y
	bottom_cover.position.y += 16
	tween.create(Tween.EASE_OUT, Tween.TRANS_SINE)
	tween.add_attribute("position:y", final_y, 2.0, bottom_cover)
	
	final_y = top_cover.position.y
	top_cover.position.y -= 16
	tween.create(Tween.EASE_OUT, Tween.TRANS_SINE)
	tween.add_attribute("position:y", final_y, 2.0, top_cover)
	bottom_cover.visible = true
	top_cover.visible = true

func fade_in():
	
	screencover.modulate = Color.black
	tween.attribute("modulate:a", 0.0, 3.0, screencover)





	
func _process(delta: float) -> void :
	if CharacterManager.credits_seen:
		if Input.is_action_pressed("pause"):
			fade_out_duration = 1.0
			fade_out()

func roll_up_credits():
	var font_size = bitmap_font.get_height()

	var lines_part1 = credits_part1.get_line_count()
	var total_lines = lines_part1

	var total_height = total_lines * font_size

	var buffer = 55 * font_size
	total_height += buffer

	var base_duration = 158.0
	var duration = base_duration / scroll_speed

	credits.position.x = 296
	tween.attribute("position:y", - total_height, duration, credits)
	tween.add_callback("fade_out")

func fade_out():
	screencover.visible = true
	tween.attribute("modulate:a", 1.0, fade_out_duration, screencover)
	tween.add_wait(3)
	tween.attribute("volume_db", - 80, fade_out_duration, loop)
	CharacterManager.credits_seen = true
	CharacterManager._save()
	if IGT.clocked_all_stages():
		tween.add_callback("go_to_igt",GameManager)
	else:
		tween.add_callback("go_to_disclaimer",GameManager)
