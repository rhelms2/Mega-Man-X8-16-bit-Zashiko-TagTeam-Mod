extends GenericIntro

onready var tween: TweenController = TweenController.new(self, false)
onready var battle_song: AudioStreamPlayer = $BattleSong
onready var song: AudioStreamPlayer = $song
onready var dmg: Node2D = $"../Damage"
onready var damage: Node2D = $"../DamageOnTouch"
export  var bar: Texture
onready var effect: = animatedSprite.get_node("effectSprite")
onready var sfx_dash: AudioStreamPlayer = get_parent().get_node("dash")
onready var sfx_jump: AudioStreamPlayer = get_parent().get_node("jump")
onready var sfx_land: AudioStreamPlayer = get_parent().get_node("land")

onready var sfx_awake: = $sfx_awake
onready var awakened_sfx: = get_parent().get_node("awakened_sfx")
onready var reflector: Node2D = $"../DamageReflector"

onready var battle_song_enhanced: = preload("res://System/BossMusic/x_vs_zero_intro.ogg")
onready var battle_loop_enhanced: = preload("res://System/BossMusic/x_vs_zero_loop.ogg")
onready var zero_song_enhanced: = preload("res://System/BossMusic/cannonball_intro.ogg")
onready var zero_loop_enhanced: = preload("res://System/BossMusic/cannonball_loop.ogg")

var time_offset: float = 0.0
var amplitude: float = 2.0
var speed: float = 1.0

onready var collision_shape: = get_parent().get_node("collisionShape2D")


func connect_start_events() -> void :
	Event.listen("teleport_to_secretboss", self, "prepare_for_intro")
	Event.listen("end_teleport_to_secretboss", self, "execute_intro")
	
func _ready() -> void :
	call_deferred("play_animation", "intro")
	Event.listen("character_talking", self, "talk")
	song.stream.loop = true
	awakened_sfx.stream.loop = true
	if CharacterManager.game_mode > 1:
		battle_song.stream = battle_song_enhanced
		battle_song.get_node("loop").stream = battle_loop_enhanced
	if CharacterManager.current_player_character == "Zero":
		battle_song.stream = zero_song_enhanced
		battle_song.get_node("loop").stream = zero_loop_enhanced

func prepare_for_intro() -> void :
	effect.visible = true

func enable_collision():
	collision_shape.disabled = false

func talk(character):
	if character == "Zero_Boss":
		play_animation_once("talk")
	else:
		play_animation_once("idle")

func _Setup():
	GameManager.start_cutscene()
	GameManager.dialog_box.emit_capsule_signal = false
	turn_player_towards_boss()
	song.play()
	awakened_sfx.play()
	Tools.timer(3.5, "enable_collision", self)
	GameManager.add_collectible_to_savedata("zero_seen")

func start_intro():
	song.play()

func _Update(delta):
	if attack_stage == 0:
		set_vertical_speed(50)
		reflector.deflects_max = 4
		reflector.deflects = reflector.deflects_max
		reflector.reset()
		reflector.activate()
		damage.activate()
		dmg.deactivate()
		dmg.remove_weaknesses()
		next_attack_stage()
		
	if attack_stage == 1:
		time_offset += delta * speed * 7
		animatedSprite.offset.y = 1 + amplitude * sin(time_offset)
		if character.is_on_floor():
			animatedSprite.offset.y = 1
			play_animation("intro_land")
			sfx_land.play()
			next_attack_stage()
		
	if attack_stage == 2 and has_finished_last_animation():
		play_animation("idle")
		start_dialog_or_go_to_attack_stage(3)

	elif attack_stage == 3:
		if seen_dialog():
			next_attack_stage()
			play_animation("awakened_start")

	elif attack_stage == 4 and has_finished_last_animation():
		play_animation("awakened_loop")
		screenshake(1.0)
		sfx_awake.play()
		song.stop()
		battle_song.loop.stream.loop = true
		battle_song.play()
		
		next_attack_stage()

	elif attack_stage == 5 and timer > 1.0:
		Event.emit_signal("set_boss_bar", bar)
		Event.emit_signal("boss_health_appear", character)
		next_attack_stage()

	elif attack_stage == 6 and timer > 1.2:
		dmg.call_deferred("deactivate")
		EndAbility()
