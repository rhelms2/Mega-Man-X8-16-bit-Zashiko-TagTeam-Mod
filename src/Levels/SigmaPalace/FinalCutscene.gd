extends Node2D
onready var firenoise: AudioStreamPlayer2D = $firenoise

export  var charge_color1: Color
export  var charge_color2: Color
export  var song_intro: AudioStream
export  var song_loop: AudioStream
export  var text_second_dialog: Resource
onready var dialog_box: Label = $DialogBox
onready var screencover: Sprite = $screencover
onready var x: AnimatedSprite = $X
onready var axl: AnimatedSprite = $Axl
onready var zero: AnimatedSprite = $Zero
onready var charge_shot: AnimatedSprite = $ChargeShot
onready var charge_shot_particles = $ChargeShot / particles2D
onready var lumine: AnimatedSprite = $Lumine
onready var tentacles = $LumineTentacles
onready var lflash: Sprite = $Lumine / flash
onready var remains: Particles2D = $Lumine / remains_particles
onready var explosions: Particles2D = $Lumine / explosions
onready var explode: AudioStreamPlayer2D = $Lumine / explode
onready var shot: AudioStreamPlayer2D = $ChargeShot / shot
onready var charge: AudioStreamPlayer2D = $X / charge
onready var explode_2: AudioStreamPlayer2D = $Lumine / explode2
onready var beam_outvfx: AudioStreamPlayer2D = $X / beam_out
onready var charge_vfx: AnimatedSprite = $X / ChargeVFX
onready var musicplayer: AudioStreamPlayer = $"Music Player"
onready var shockwave: Sprite = $Lumine / shockwave
onready var burnt_floor: Sprite = $Lumine / burnt_floor
onready var shot2: AudioStreamPlayer2D = $X / shot

onready var ascend_value = 2
var beamed_out: bool = false

onready var tween: = TweenController.new(self, false)
onready var tweenx: = TweenController.new(self, false)
onready var tweenaxl: = TweenController.new(self, false)
onready var tweenzero: = TweenController.new(self, false)

onready var damage_sfx = $damage
onready var saber_sfx = $saber

onready var explosion = $explosion

var cutscene_stage = 0

var second_dialog: = false

signal movement_finished(sprite, animation)

var tenctacle_spawn: bool = false
var tenctacle_spawned: bool = false
var tentacle_scale = 0
var tentacle_scale_max = 0.7
var tentacle_alpha = 0.3

func show_tentacle():
	lumine.animation = "final"

func _ready() -> void :
	screencover.visible = true
	tween.attribute("volume_db", - 35, 2, firenoise)
	Tools.timer(2, "fade_in", self)
	Tools.timer(8, "start_dialog", self)
	Event.connect("character_talking", self, "on_talk")
	if Configurations.exists("SongRemix"):
		if Configurations.get("SongRemix"):
			song_intro = load("res://Remix/Songs/Lumine Ending - Loop.ogg")
			song_loop = load("res://Remix/Songs/Lumine Ending - Loop.ogg")
			song_loop.loop = true

func on_talk(character_name: String):
	if cutscene_stage <= 0:
		if character_name == "MegaMan X":
			x.play("talk")
		else:
			x.play("idle")
		if character_name == "Axl":
			axl.play("talk")
		else:
			axl.play("idle")
		if character_name == "Zero":
			zero.play("talk")
		else:
			zero.play("idle")
	else:
		if character_name == "MegaMan X":
			x.play("crouch_talk")
		else:
			x.play("crouch")
		

func start_dialog():
	musicplayer.play_song(song_loop, song_intro)
	dialog_box.startup()
func fade_in():
	tween.attribute("modulate:a", 0.0, 5.0, screencover)

func _on_dialog_concluded() -> void :
	if not second_dialog:
		var params = {
			"sprite": axl, 
			"animation": "walk_slow", 
			"x": 256, 
			"y": axl.position.y, 
			"duration": 4
		}
		Tools.timer_array(self, 1.0, "move_to_position", params)
		Tools.timer(4.4, "show_tentacle", self)
	else:
		Tools.timer(1.0, "fade_out", self)


func move_to_position(data: Dictionary):
	var sprite = data["sprite"]
	var animation = data["animation"]
	var _x = data["x"]
	var _y = data["y"]
	var duration = data["duration"]
	sprite.animation = animation
	tween.attribute("position:x", _x, duration, sprite)
	tween.attribute("position:y", _y, duration, sprite)
	var callback_data = {"sprite": sprite, "animation": "recover"}
	tween.add_callback("on_movement_completed", self, [callback_data])
	connect("movement_finished", self, "finished_movement")

func on_movement_completed(callback_data):
	var sprite = callback_data["sprite"]
	var animation = callback_data["animation"]
	emit_signal("movement_finished", sprite, animation)

func finished_movement(sprite, animation):
	
	match cutscene_stage:
		0:
			sprite.animation = animation
			cutscene_phase_1()
		1:
			cutscene_phase_2()
		2:
			start_charge()


class CutsceneMovement:
	var sprite: Node2D
	var target_position: Vector2
	var start_position: Vector2
	var movement_duration: float
	var elapsed_time: float
	var animation: String
	var y_amplitude: float

var movements: Array = []
var processing: bool = false

func move_to_position_lerp(params: Dictionary) -> void :
	processing = true
	var movement = CutsceneMovement.new()
	movement.sprite = params["sprite"]
	movement.target_position = Vector2(params["x"], params["y"])
	movement.movement_duration = params["duration"]
	movement.start_position = movement.sprite.position
	movement.elapsed_time = 0.0
	movement.animation = params.get("animation", "")
	movement.y_amplitude = params.get("y_amplitude", 50)
	if movement.animation != "":
		movement.sprite.play(movement.animation)
	movements.append(movement)
	
func parabolic_interpolate(progress: float, start_position: Vector2, target_position: Vector2, amplitude: float) -> Vector2:
	var new_x = lerp(start_position.x, target_position.x, progress)
	var t = 0.0
	if start_position.x != target_position.x:
		t = (new_x - start_position.x) / (target_position.x - start_position.x)
	var height = amplitude * ( - 4 * pow(t - 0.5, 2) + 1)
	return Vector2(new_x, start_position.y - height)

func _process(delta):
	for movement in movements:
		movement.elapsed_time += delta
		var progress = movement.elapsed_time / movement.movement_duration
		if progress >= 1.0:
			movement.sprite.position = movement.target_position
			movement.sprite.set("moving", false)
			finished_movement(movement.sprite, movement.animation)
			progress = 0.0
			movements.erase(movement)
		else:
			var new_position = parabolic_interpolate(progress, movement.start_position, movement.target_position, movement.y_amplitude)
			movement.sprite.position = new_position

func change_animation(params: Dictionary):
	var sprite = params["sprite"]
	var animation = params["animation"]
	var sfx = params["sfx"]
	if sprite != null and animation != "":
		sprite.play(animation)
	if sfx != null:
		sfx.play()

func cutscene_phase_1():
	cutscene_stage += 1
	var params = {
		"sprite": axl, 
		"animation": "damage", 
		"x": 195, 
		"y": axl.position.y, 
		"duration": 0.7, 
		"y_amplitude": 40
	}
	move_to_position_lerp(params)
	params = {
		"sprite": axl, 
		"animation": "balance", 
		"sfx": null
	}
	Tools.timer_array(self, 0.4, "change_animation", params)
	damage_sfx.play()
	
	params = {
		"sprite": x, 
		"animation": "jump", 
		"x": 170, 
		"y": x.position.y, 
		"duration": 0.65, 
		"y_amplitude": 45
	}
	Tools.timer_array(self, 0.05, "move_to_position_lerp", params)
	params = {
		"sprite": x, 
		"animation": "fall", 
		"sfx": null
	}
	Tools.timer_array(self, 0.45, "change_animation", params)
	x.z_index = 2
	
	params = {
		"sprite": zero, 
		"animation": "jump", 
		"x": 264, 
		"y": zero.position.y, 
		"duration": 0.5, 
		"y_amplitude": 30
	}
	Tools.timer_array(self, 0.2, "move_to_position_lerp", params)
	params = {
		"sprite": zero, 
		"animation": "saber_jump", 
		"sfx": saber_sfx
	}
	Tools.timer_array(self, 0.45, "change_animation", params)
	Tools.timer(0.55, "single_explosion", self)
func single_explosion() -> void :
	tentacles.visible = false
	explosion.emitting = true
	explode_2.play()
	lumine.animation = "final_cut"

func cutscene_phase_2():
	cutscene_stage += 1
	var params = {
		"sprite": axl, 
		"animation": "final", 
		"x": 165, 
		"y": 189, 
		"duration": 0.25
	}
	move_to_position(params)
	params = {
		"sprite": x, 
		"animation": "crouch", 
		"x": 145, 
		"y": 189, 
		"duration": 0.25
	}
	move_to_position(params)
	params = {
		"sprite": zero, 
		"animation": "recover", 
		"x": zero.position.x, 
		"y": zero.position.y, 
		"duration": 0.5
	}
	move_to_position(params)




func start_charge() -> void :
	x.frames = load("res://src/Actors/Player/x_sprites/x_leftarm.res")
	x.play("crouch")
	x.material.set_shader_param("Color", charge_color1)
	x.material.set_shader_param("Charge", 1.0)
	charge.play()
	charge_vfx.visible = true
	Tools.timer(0.5, "next_charge", self)
func next_charge() -> void :
	x.material.set_shader_param("Color", charge_color2)
	charge_vfx.play("Heavy")
	charge_vfx.modulate = Color.khaki
	Tools.timer(1.0, "fire", self)
func fire() -> void :
	charge_shot.visible = true
	shot.play()
	x.material.set_shader_param("Charge", 0.0)
	charge_vfx.visible = false
	charge.stop()
	Tools.timer(0.16, "play", shot2, null, true)
	tween.attribute("position:x", 600, 1.0, charge_shot)
	Tools.timer(1.0, "end_fire", self)
func end_fire() -> void :
	x.play("crouch")
	x.frames = load("res://src/Actors/Player/x_sprites/x.res")
	zero.flip_h = true
func _on_area2D_body_entered(_body: Node) -> void :
	quick_pause()


func quick_pause() -> void :
	lflash.start()
	lumine.material.set_shader_param("Flash", 1.0)
	GameManager.pause("lumine_explosion")
	explode.play()
	Tools.timer(0.85, "unquickpause", self, null, true)
	Tools.timer(0.03, "lumine_explosion", self)
func unquickpause() -> void :
	GameManager.unpause("lumine_explosion")
func lumine_explosion() -> void :
	explosions.emitting = true
	lumine.self_modulate.a = 0.0
	remains.emitting = true
	Tools.timer(1.5, "lumine_explosion_finish", self)
	burnt_floor.visible = true
	emit_shockwave()
	remaining_explosions()
var extra_explosions: = true
func remaining_explosions():
	if extra_explosions:
		explode_2.play_rp()
		Tools.timer(0.4, "remaining_explosions", self)
func lumine_explosion_finish():
	extra_explosions = false
	explosions.emitting = false
	remains.emitting = false
	Tools.timer(1.0, "after_explosion", self)
func emit_shockwave():
	shockwave.visible = true
	tween.attribute("scale:y", 10, 0.3, shockwave)
	tween.attribute("scale:x", 0.4, 0.3, shockwave)
	tween.attribute("modulate:a", 0, 0.4, shockwave)
	
	
func after_explosion():
	x.play("crouch")
	x.frames = load("res://src/Actors/Player/x_sprites/x.res")
	Tools.timer(0.5, "start_second_dialog", self)
func start_second_dialog():
	second_dialog = true
	dialog_box.dialog_tree = text_second_dialog
	dialog_box.startup()



func beam_out():
		beam_outvfx.play()
		x.play("beam_in", true)
		Tools.timer(0.15, "pull_x_up", self)
		axl.play("beam_out")
		Tools.timer(0.25, "pull_axl_up", self)
		zero.play("beam_out")
		Tools.timer(0.25, "pull_zero_up", self)

func pull_x_up():
	x.play("beam")
	tweenx.attribute("position:y", - 600, 1.0, x)
	Tools.timer(1.0, "fade_out", self)
func pull_axl_up():
	if not beamed_out:
		beam_outvfx.play()
		beamed_out = true
	axl.play("beam")
	tweenaxl.attribute("position:y", - 600, 1.0, axl)
	Tools.timer(1.0, "fade_out", self)
func pull_zero_up():
	if not beamed_out:
		beam_outvfx.play()
		beamed_out = true
	zero.play("beam")
	tweenzero.attribute("position:y", - 600, 1.0, zero)
	Tools.timer(1.0, "fade_out", self)
	
func fade_out():
	screencover.visible = true
	screencover.material.blend_mode = 0
	screencover.modulate = Color.black
	screencover.modulate.a = 0.0
	tween.attribute("modulate:a", 1.0, 3.0, screencover)
	tween.attribute("volume_db", - 50, 10.0, musicplayer)
	tween.attribute("volume_db", - 80, 6, firenoise)
	tween.add_callback("go_to_elevator_cutscene", GameManager)
	musicplayer.fade_in = false
	second_dialog = true


