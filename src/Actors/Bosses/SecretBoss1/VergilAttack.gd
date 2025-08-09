extends AttackAbility
onready var damage: Node2D = $"../Damage"
onready var damage_on_touch: Node2D = $"../DamageOnTouch"
onready var disappear: AudioStreamPlayer2D = $disappear

export var _slash : PackedScene
onready var slashes: AudioStreamPlayer2D = $slashes


var angles = [33,-33,90,44,-44,25,-25,0,90,44,-25,-33]
#var last_hit : EnemyMeleeAttack

func _ready() -> void:
	pass

func _Setup() -> void:
	turn_and_face_player()
	play_animation("slash_prepare")
	foward_pos = 48


func _Update(delta) -> void:
	process_gravity(delta)
	if attack_stage == 0 and has_finished_last_animation():
		play_animation("slash_loop")
		damage.deactivate()
		damage_on_touch.deactivate()
		next_attack_stage()

	elif attack_stage == 1 and timer > .25:
		play_animation("slash_disappear")
		disappear.play()
		slashes.play()
		next_attack_stage()
	
	elif attack_stage == 2 and timer > .1:
		create_slash(0)
		origin_pos = global_position
		var i = 0.075
		var h = 0
		while i < .75:
			Tools.timer_p(i,"create_slash",self,angles[h])
			i += 0.075
			h += 1
		force_movement(105)
		next_attack_stage()

	elif attack_stage == 3 and timer > 1.55:
		play_animation("jump_land")
		damage.activate()
		damage_on_touch.activate()
		decay_speed(1,.25)
		next_attack_stage()
	
	elif attack_stage == 4 and has_finished_last_animation():
		EndAbility()

var origin_pos := Vector2.ZERO
var foward_pos := 8
func create_slash(degrees : float):
	var slash = _slash.instance()
	get_tree().current_scene.add_child(slash,true)
	if not facing_a_wall():
		slash.set_global_position(origin_pos + Vector2(foward_pos * get_facing_direction(),0)) 
	else:
		slash.set_global_position(global_position)
	slash.rotate_degrees(degrees)
	Tools.timer(.85,"activate",slash)
	foward_pos += 8
	


func _Interrupt() -> void:
	._Interrupt()
