extends AnimatedSprite

onready var character: KinematicBody2D = $"../.."
onready var boss_ai: Node2D = $"../../BossAI"
onready var animated_sprite: AnimatedSprite = $".."
onready var shot_sound: AudioStreamPlayer2D = $shot_sound

export (PackedScene) var projectile
var shot
var timer := 0.0
var last_shot_time := 0.0
var time_between_shots := 1
var height_correction := 10
var horizontal_correction := 18
var death := false
var direction := -1

var sync_animations = [
	"missileclaw_prepare", 
	"missileclaw_fire",
	"shieldclaw_prepare",
	"shieldclaw", "missileclaw_recover", "shieldclaw_end"]
var end_animations = ["idle"]

var active := false

func _ready() -> void:
	character.listen("zero_health", self, "on_death")
	
func on_death() -> void:
	deactivate()
	death = true
	material = animated_sprite.material

func activate() -> void:
	active = true
	timer = 0
	last_shot_time = 0
	visible = true
	if direction == -1:
		horizontal_correction = -18
		scale.x = -1
	else:
		horizontal_correction = 18
		scale.x = 1
	play("open")
	
func deactivate() -> void:
	active = false
	play("close")

func hide() -> void:
	deactivate()
	visible = false

func _process(_delta: float) -> void:
	if GameManager.is_player_in_scene():
		if GameManager.get_player_position().x < global_position.x:
			direction = -1
		else:
			direction = 1

func _physics_process(delta: float) -> void:
	handle_activation() 
	if active:
		timer += delta
		if timer > last_shot_time + time_between_shots:
			play_random_fire()
			frame = 0
			last_shot_time = timer
			var target_dir = (GameManager.get_player_position() - global_position).normalized()
			shot = instantiate(projectile) 
			shot.set_creator(get_parent())
			shot.global_position = Vector2(global_position.x + horizontal_correction, global_position.y + height_correction)
			shot.initialize(-1)
			shot.set_horizontal_speed(shot.speed * target_dir.x)
			shot.set_vertical_speed(shot.speed * target_dir.y)
			shot_sound.play()
			

func play_random_fire():
	if rand_range(-1,1) > 0:
		play("fire1")
		height_correction = -10
	else:
		play("fire2")
		height_correction = 10

func handle_activation() -> void:
	if death:
		return
	if animated_sprite.animation in sync_animations:
		if not active:
			activate()
	elif animated_sprite.animation in end_animations:
		if active:
			deactivate()
	else:
		hide()
	
func instantiate(scene : PackedScene) -> Node2D:
	var instance = scene.instance()
	get_tree().current_scene.add_child(instance,true)
	instance.set_global_position(global_position) 
	return instance
