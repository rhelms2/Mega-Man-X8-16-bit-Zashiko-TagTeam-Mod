extends Node
onready var megaman: Sprite = $megaman
onready var megaman2: Sprite = $megaman2
onready var x8_big: Sprite = $x8_big
onready var x8_outer: Sprite = $x8_outer
onready var x8_color: Sprite = $x8_color
onready var x8_shineleft: Sprite = $x8_shineleft
onready var x8_shineright: Sprite = $x8_shineright
onready var x8_shinefull: Sprite = $x8_shinefull
onready var twish: AudioStreamPlayer = $twish

const white_half: = Color(1, 1, 1, 0.5)
const white_zero: = Color(0.5, 0.5, 1, 0)
var tween: SceneTreeTween
export  var dark_megaman_color: Color
export  var fade_color: Color
export  var start_megaman_position: Vector2
export  var final_megaman_position: Vector2
onready var blackness: Sprite = $blackness
onready var demo: Label = $demo_02

var timer: = 0.0
var step: = 0
func next_step() -> void :
	step += 1
	timer = 0
	

func _ready() -> void :
	for child in get_children():
		if child is Sprite:
			child.visible = false
		else:
			break
	
	set_physics_process(false)

func _physics_process(delta: float) -> void :
	timer += delta
	appear_megaman_logo()
	appear_x8()
		
	pass

func appear_x8() -> void :
	if step == 8 and timer > 1:
		x8_outer.scale = Vector2(0, 0)
		x8_outer.modulate = fade_color
		x8_outer.visible = true
		tween = create_tween()

		tween.set_parallel()

		tween.tween_property(x8_outer, "modulate", Color.white, 0.2)

		tween.tween_property(x8_outer, "scale", Vector2.ONE, 0.35).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
		next_step()
	elif step == 9 and timer > 0.032:
		x8_big.scale = Vector2(4, 4)
		x8_big.modulate = fade_color
		x8_big.visible = true
		var tween2 = create_tween()
		tween2.set_parallel()
		tween2.tween_property(x8_big, "modulate", Color.white, 0.2)
		tween2.tween_property(x8_big, "scale", Vector2(0.5, 0.5), 0.35).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
		next_step()
		
	elif step == 10 and timer > 1.25:
		activate_shine(x8_shineleft)
		activate_shine(x8_shineright)
		activate_shine(x8_shinefull)
		tween = create_tween()

		tween.set_parallel()

		tween.tween_property(x8_shinefull, "modulate", Color(1, 3, 5, 1), 0.75)
		
		next_step()
		
	elif step == 11 and timer > 0.75:
		twish.play()
		x8_big.visible = false
		x8_outer.visible = false
		var tween2 = create_tween()
		tween2.set_parallel()
		tween2.tween_property(blackness, "modulate", Color(80, 80, 80, 1), 0.75)
		
		next_step()
		
	elif step == 12 and timer > 0.75:
		x8_color.visible = true
		x8_color.modulate = Color(4, 8, 16, 1)
		var tween3 = create_tween()
		tween3.set_parallel()
		tween3.tween_property(x8_color, "modulate", Color.white, 5).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
		tween3.tween_property(x8_shinefull, "modulate", white_zero, 2.5)
		tween3.tween_property(blackness, "modulate", Color.white, 0.75)
		next_step()
	elif step == 13 and timer > 1.25:
		appear(demo)
		next_step()

func activate_shine(object) -> void :
	object.modulate = Color.white
	object.modulate.a = 0
	object.visible = true

func appear_megaman_logo() -> void :
	if step == 0 and timer > 0.5:
		send_downwards(megaman)
		next_step()
	
	elif step == 1 and timer > 0.3:
		fade(megaman)
		send_downwards(megaman2)
		next_step()

	elif step == 2 and timer > 0.3:
		send_downwards(megaman)
		fade(megaman2)
		next_step()

	elif step == 3 and timer > 0.3:
		fade(megaman)
		send_downwards(megaman2)
		next_step()

	elif step == 4 and timer > 0.3:
		send_downwards(megaman)
		fade(megaman2)
		next_step()
	
	elif step == 5 and timer > 0.25:
		fade(megaman)
		send_downwards(megaman2)
		next_step()

	elif step == 6 and timer > 0.25:
		send_downwards(megaman)
		fade(megaman2)
		next_step()
	
	elif step == 7 and timer > 0.25:
		send_downwards(megaman2)
		next_step()
	

func send_downwards(object, duration: = 0.3) -> void :
	object.z_index = - 1
	object.modulate = dark_megaman_color
	object.position = start_megaman_position
	object.visible = true
	tween = create_tween()

	tween.set_parallel()

	tween.tween_property(object, "modulate", Color.white, duration)

	tween.tween_property(object, "position:x", final_megaman_position.x, duration)

	tween.tween_property(object, "position:y", final_megaman_position.y, duration).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)

func fade(object, duration: = 0.3) -> void :
	object.z_index = 0
	tween = create_tween()

	tween.tween_property(object, "modulate", fade_color, duration)
		
	
func appear(object) -> void :
	object.modulate = Color( - 1, - 1, 0, 0)
	object.visible = true
	var t = create_tween()
	t.tween_property(object, "modulate", Color.white, 1)
