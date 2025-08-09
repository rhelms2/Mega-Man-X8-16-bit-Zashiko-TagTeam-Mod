extends ChargedBuster
class_name LaserBuster

export var duration := 1.8
export var damage_frequency := 0.3
var timer := 0.0
var next_damage_time := 0.02
var ending := false
var target_list = []
onready var animatedBeam = animatedSprite.get_node("animatedSprite2")

func _ready() -> void:
	continuous_damage = true
# warning-ignore:return_value_discarded
	Event.listen("enemy_kill",self,"leave")

func references_setup(direction):
	scale.x = direction
	$audioStreamPlayer2D.stream = fire_sound
	$audioStreamPlayer2D.play()

func position_setup(spawn_point:Vector2, direction:int):
	position.x = position.x + (spawn_point.x + 30)  * direction
	position.y = position.y + spawn_point.y -1
	animatedSprite.set_frame(0)
	animatedBeam.set_frame(0)

func _physics_process(delta: float) -> void:
	timer += delta
	
	if not ending and timer > next_damage_time:
		if target_list.size() > 0:
			for target in target_list:
				if is_instance_valid(target):
					Log("Damaging " + str(target.name))
					target.damage(damage, self)
					#Event.emit_signal("hit_enemy")
			next_damage_time = timer + damage_frequency

	if timer > duration and not ending:
		Log("Ending")
		play_animation("end")
		animatedBeam.play("end")
		target_list.clear()
		ending = true
	
	if timer > duration + 0.5:
		queue_free()

func disable_particle_visual():
	pass

func deflect(_body):
	pass

func leave(_target):
	if _target in target_list:
		Log("Erasing target " + _target.name)
		target_list.erase(_target)
	
func launch_setup(_direction, _launcher_velocity := 0.0):
	pass
	
func hit(_body) -> void:
	if not (_body in target_list):
		Log("Added " + _body.name + " to the laser damage list")
		target_list.append(_body)

func play_animation(anim :String, frame:= 0) -> void:
	animatedSprite.play(anim)
	animatedSprite.set_frame(frame)
