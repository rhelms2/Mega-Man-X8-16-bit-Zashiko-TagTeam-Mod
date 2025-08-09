extends EnemyShot
class_name MultipleShot

export var use_shot_position := false
export var extra_projectiles : Array
onready var prepare: AudioStreamPlayer2D = $prepare
onready var turn: AudioStreamPlayer2D = $turn
var played_sound := false


var turning := false

func fire(projectile, _shot_position, _notused := 0, _nonused := Vector2.ZERO) -> void:
	instantiate_projectile2(projectile)
	for p in extra_projectiles:
		instantiate_projectile2(p)

func instantiate_projectile2(scene : PackedScene) -> void:
	var projectile = instantiate(scene) 
	projectile.set_creator(self)
	projectile.initialize(character.get_facing_direction())
	if use_shot_position:
		projectile.global_position = actual_fire_pos
	
func _Setup():
	attack_stage = 0
	turning = false
	played_sound = false
	if get_player_direction_relative() != character.get_facing_direction():
		play_animation("turn")
		turn.play()
		turning = true


func _Update(_delta) -> void:
	if turning:
		if has_finished_last_animation():
			set_direction(get_player_direction_relative())
			play_animation("prepare")
			turning = false
	else:
		if not played_sound:
			prepare.play()
			played_sound = true
		._Update(_delta)
