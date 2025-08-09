extends Node2D

onready var capcom_logo: AnimatedSprite = $capcom_logo
onready var capcom_sound: AudioStreamPlayer = $capcom_sound
onready var inspired: Label = $inspired
onready var black: Sprite = $black
onready var intro_anim: Node2D = $IntroAnim

var timer: float = 0.0
var total_timer: float = 0.0
var step: int = 0
var finished: bool = false

signal finished


func next_step() -> void :
	step += 1
	timer = 0

func _input(event: InputEvent) -> void :
	if not finished:
		if event.is_action_pressed("ui_accept") or event.is_action_pressed("pause"):
			skip()

func skip() -> void :
	capcom_sound.volume_db = - 80
	finished = true
	set_physics_process(false)
	black.visible = true
	black.modulate = Color(0, 0, 0, 0)
	var music = $theme_music
	if not music.playing:
		music.play()
	$bg2.visible = true
	var t = create_tween()
	t.tween_property(black, "modulate", Color(0, 0, 0, 1), 0.5)
	t.tween_callback(self, "hide_intro")

func hide_intro() -> void :
	if is_instance_valid(intro_anim):
		intro_anim.queue_free()
	$MainMenu.start()
	capcom_logo.visible = false
	inspired.visible = false
	black.visible = false

func _ready() -> void :
	capcom_logo.modulate = Color(0, 0, 0, 1)
	inspired.modulate = Color( - 1, - 1, 0, 1)

func start() -> void :
	set_physics_process(true)

func _physics_process(delta: float) -> void :
	total_timer += delta
	timer += delta
	if step == 0:
		capcom_sound.play()
		var t = create_tween()
		t.tween_property(inspired, "modulate", Color.white, 1.35)
		next_step()
	elif step == 1 and timer > 1.3:
		var t = create_tween()
		t.tween_property(capcom_logo, "modulate", Color.white, 1.35)
		next_step()
	elif step == 2 and total_timer > 2.2:
		capcom_logo.play("shine")
		next_step()
	elif step == 3 and total_timer > 4.5:
		var t = create_tween()
		t.set_parallel()
		t.tween_property(inspired, "modulate", Color( - 1, - 1, 0, 1), 0.75)
		t.tween_property(capcom_logo, "modulate", Color( - 0.1, - 0.1, 0, 1), 0.75)
		next_step()
	elif step == 4 and timer > 1:
		black.visible = false
		capcom_logo.visible = false
		inspired.visible = false
		emit_signal("finished")
		$theme_music.play()
		next_step()

func _on_menuButton_button_down() -> void :
	skip()
	$menuButton.visible = false
