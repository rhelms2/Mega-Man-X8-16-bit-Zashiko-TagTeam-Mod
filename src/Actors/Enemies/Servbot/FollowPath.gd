extends AttackAbility
var saved_last_pos : Vector2
var path_speed : float = 45
var current_path_speed : float
onready var scream: AudioStreamPlayer2D = $audioStreamPlayer2D

onready var path : PathFollow2D
onready var spotlight: Light2D = $"../sublight"

var increase_pitch := false

func _ready() -> void:
	var meister = get_parent().get_parent()
	if meister is PathFollow2D:
		path = meister
	character.listen("got_hit",self,"speed_up")
	current_path_speed = path_speed

func speed_up() -> void:
	current_path_speed *= 2.5
	current_path_speed = clamp(current_path_speed,0,175)
	scream.play()
	scream.pitch_scale += 0.1

func _Update(delta: float) -> void:
	
	if is_player_nearby_horizontally(398):
		move_and_flicker(delta)
		if global_position.x > saved_last_pos.x:
			change_direction(1)
		else:
			change_direction(-1)
		saved_last_pos = global_position
			

func change_direction(new_dir : int) -> void:
	if character.get_direction() != new_dir:
		play_animation_once("turn")
	if has_finished_animation("turn"):
		set_direction(new_dir)
		play_animation_once("idle")
	
func move_and_flicker(delta) -> void:
	if path:
		timer += delta
		path.offset += delta * current_path_speed
		spotlight.energy = lerp(0.95, 1, sin(timer * 2))

func check_for_event_errors() -> void:
	pass
