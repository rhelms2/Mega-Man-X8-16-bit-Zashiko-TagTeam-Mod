extends Node2D

const bar_size: float = 60.0
const rankings: Dictionary = {"e": 0, "d": 1, "c": 2, "b": 3, "a": 4, "s": 5}
const rank_down: AudioStream = preload("res://src/Sounds/FX - Rank Down.ogg")
const rank_up: AudioStream = preload("res://src/Sounds/FX - Rank Up.ogg")
const get_b_rank: AudioStream = preload("res://src/Sounds/FX - Get B Rank.ogg")
const get_a_rank: AudioStream = preload("res://src/Sounds/FX - Get A Rank.ogg")
const get_s_rank: AudioStream = preload("res://src/Sounds/FX - Get S Rank.ogg")
const get_sss_rank: AudioStream = preload("res://src/Sounds/FX - Get SSS Rank.ogg")

export  var bar_s: Texture
export  var bar_a: Texture
export  var bar_b: Texture
export  var bar_c: Texture
export  var bar_d: Texture
export  var bar_e: Texture

onready var bars: Dictionary = {"e": bar_e, "d": bar_d, "c": bar_c, "b": bar_b, "a": bar_a, "s": bar_s}
onready var break_vfx: AnimatedSprite = $break_vfx
onready var original_position: Vector2 = position
onready var letter: AnimatedSprite = $letter
onready var bar: Sprite = $bar
onready var underbar: Sprite = $underbar
onready var tween: TweenController = TweenController.new(self, false)
onready var sound: AudioStreamPlayer2D = $sound
onready var kill_number_1: AnimatedSprite = $underbar / kills / number1
onready var kill_number_2: AnimatedSprite = $underbar / kills / number2
onready var timer_1: AnimatedSprite = $underbar / time / number1
onready var timer_2: AnimatedSprite = $underbar / time / number2
onready var timer_3: AnimatedSprite = $underbar / time / number3
onready var timer_4: AnimatedSprite = $underbar / time / number4

var current_rank: int = 0
var starting: bool = false


func _ready() -> void :
	for item in [letter, bar, underbar]:
		item.visible = false

func play(audio) -> void :
	sound.stream = audio
	sound.play()

func play_ranking_sound() -> void :
	if current_rank == 5:
		if should_play_sss_rank():
			play(get_sss_rank)
		else:
			play(get_s_rank)
	elif current_rank == 4:
		play(get_a_rank)
	elif current_rank <= 3:
		play(get_b_rank)

func should_play_sss_rank() -> bool:
	return false

func start() -> void :
	make_visible([letter, bar, underbar])
	set_ranking("e")
	letter.play("start")
	fill_bar(0)
	appear(underbar)
	visually_start_fill()
	set_timer_color(Color.white)

func set_kills_left(count: int) -> void :
	kill_number_1.frame = 0
	if count >= 10:
		kill_number_1.frame = int(str(count).left(1))
		kill_number_2.frame = int(str(count).right(1))
	else:
		kill_number_2.frame = count

func set_timer(seconds: float) -> void :
	if seconds > 99.9:
		timer_1.frame = 9
		timer_2.frame = 9
		timer_3.frame = 9
		timer_4.frame = 9
		
	elif seconds > 10:
		var s: = str(seconds)
		timer_1.frame = int(s.substr(0, 1))
		timer_2.frame = int(s.substr(1, 1))
		timer_3.frame = int(s.substr(3, 1))
		timer_4.frame = int(s.substr(4, 1))
	else:
		var s: = str(seconds)
		timer_1.frame = 0
		timer_2.frame = int(s.substr(0, 1))
		timer_3.frame = int(s.substr(2, 1))
		timer_4.frame = int(s.substr(3, 1))

func set_timer_color(color: Color) -> void :
	if timer_1.modulate != color:
		timer_1.modulate = color
		timer_2.modulate = color
		timer_3.modulate = color
		timer_4.modulate = color
		timer_3.modulate.a = 0.5
		timer_4.modulate.a = 0.5

func visually_start_fill() -> void :
	starting = true
	var tween = create_tween()
	tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
	tween.tween_method(self, "fill_bar", 100.0, 3.0, 1.25)
	tween.tween_callback(self, "finished_starting")

func finished_starting() -> void :
	starting = false

func make_visible(objects_to_appear: Array) -> void :
	for item in objects_to_appear:
		item.modulate = Color.white
		item.visible = true

func increase_ranking() -> void :
	tween.end()
	shake(letter, 8)
	flash(letter)
	flash(bar)

func decrease_ranking() -> void :
	tween.end()
	appear(letter)

func react() -> void :
	shake_horizontally(self)

func finish() -> void :
	if letter.animation == "e" or letter.animation == "start":
		letter.play("e")
	shake(letter)
	flash(letter)
	vanish(bar)
	vanish(underbar, 0.35)
	break_vfx.frame = 0
	play_ranking_sound()
	Tools.timer_p(3.0, "vanish", self, letter)

func on_death() -> void :
	vanish(letter)
	vanish(bar)
	vanish(underbar)

func vanish(obj, dur = 1.0) -> void :
	tween.create(Tween.EASE_OUT, Tween.TRANS_QUAD)
	tween.add_attribute("modulate:a", 0.0, dur, obj)

func on_fill_bar(amount) -> void :
	if starting:
		return
	fill_bar(amount)

func fill_bar(amount: float) -> void :
	if amount > 0 and amount < 3:
		amount = 3.0
	var c_size = lerp(0.0, 60.0, amount / 100.0)
	var offset = (bar_size - c_size) / 2
	bar.region_rect = Rect2(0, 0, ceil(c_size), 29)
	bar.position.x = - floor(offset)

func set_ranking(rank: String) -> void :
	letter.play(rank)
	set_bar(rank)
	if rankings[rank] > current_rank:
		increase_ranking()
	else:
		decrease_ranking()
	current_rank = rankings[rank]

func set_bar(rank) -> void :
	bar.texture = bars[rank]

func shake_horizontally(obj, intensity: = 2) -> void :
	var shake_dur: = 0.055
	tween.create()
	tween.add_attribute("position:x", original_position.x - intensity, shake_dur, obj)
	tween.add_attribute("position:x", original_position.x + intensity / 2, shake_dur, obj)
	tween.add_attribute("position:x", original_position.x - intensity / 4, shake_dur * 2, obj)
	tween.add_attribute("position:x", original_position.x, shake_dur * 2, obj)

func shake(obj, intensity: = 4) -> void :
	var shake_dur: = 0.05
	tween.create()
	tween.add_attribute("position:y", - intensity, shake_dur, obj)
	tween.add_attribute("position:y", intensity / 2, shake_dur, obj)
	tween.add_attribute("position:y", - intensity / 4, shake_dur * 2, obj)
	tween.add_attribute("position:y", 0, shake_dur * 2, obj)

func flash(obj, dur: float = 0.75, brightness: = Color(5, 5, 5, 1)) -> void :
	obj.modulate = brightness
	tween.create(Tween.EASE_OUT, Tween.TRANS_QUAD)
	tween.add_attribute("modulate", Color(1, 1, 1, 1), dur, obj)

func appear(obj, dur: float = 0.25) -> void :
	obj.modulate = Color(1, 1, 1, 0)
	tween.create(Tween.EASE_OUT, Tween.TRANS_QUAD)
	tween.add_attribute("modulate", Color(1, 1, 1, 1), dur, obj)
