extends Ability
class_name Ride

var rider : Node = null
var recent_rider : Node = null
var rider_original_parent : Node
onready var mount_audio := $audioStreamPlayer2D

export var destroy_damage := 8
onready var area2D := get_parent().get_node("area2D")

func _ready() -> void:
# warning-ignore:return_value_discarded
	area2D.connect("body_entered",self,"_on_area2D_body_entered")
# warning-ignore:return_value_discarded
	area2D.connect("body_exited",self,"_on_area2D_body_exited")
# warning-ignore:return_value_discarded
	character.listen("death",self,"_on_death")

func _on_area2D_body_entered(_body: Node) -> void:
	if active:
		if is_able_to_ride(_body):
				make_rider(_body)

func is_able_to_ride(_body) -> bool:
	if GameManager.player:
		if not GameManager.player.listening_to_inputs:
			return false
	if character.has_health() and not get_tree().paused:
		if _body.is_in_group("Props"):
			return false
		elif _body.is_in_group("Player") and GameManager.player.ride == null:
			var collider = _body.get_character()
			if collider.listening_to_inputs and rider == null and collider != character and collider != recent_rider:
				var non_states := ["Ride","Forced","Finish","Intro"]
				if not collider.is_executing_either(non_states):
					return true
	return false

func _on_area2D_body_exited(_body: Node) -> void:
	if _body.is_in_group("Player"):
		if _body.get_character() == recent_rider:
			recent_rider = null

func make_rider(_body: Node) -> void:
	rider = _body.get_character()
	recent_rider =  _body.get_character()
	rider.ride = character
	parent_rider_to_self()
	rider.emit_signal("land")
	rider.call_deferred("ride",character)
	rider.disable_collision()
	character.start_listening_to_inputs()
	_OnPlayerAssumeControl()
	Log("Controlled by " + rider.name)
	ExecuteOnce()

func parent_rider_to_self():
	rider_original_parent = rider.get_parent()
	#rider_original_parent.remove_child(rider)
	rider_original_parent.call_deferred("remove_child", rider)
	get_parent().call_deferred("add_child", rider)

func eject():
	remove_rider()
	_Eject()
	rider = null

func enemy_eject():
	remove_rider()
	rider = null

func _OnPlayerAssumeControl() -> void: #override me
	pass

func _Eject() -> void: #override me
	pass

func force_eject():
	Log("Explosion force ejected rider.")
	remove_rider()
	if is_instance_valid(rider):
		rider.damage(destroy_damage, rider)
	rider = null

func remove_rider():
	if is_instance_valid(rider):
		Log("Ejecting: " + rider.name)
		return_rider_to_original_parent()
		rider.enable_collision()
		rider.eject(character)
	character.stop_listening_to_inputs()


func return_rider_to_original_parent():
	get_parent().remove_child(rider)
	rider_original_parent.add_child(rider)
	rider.global_position = global_position

func _on_death():
	stop_sound()
	if executing and not rider == null:
		force_eject()

func _StartCondition():
	return rider != null
	
func _EndCondition():
	return rider == null

func _Setup():
	get_parent().get_node("Enemy Collision Detector").add_to_group("Player")#TODO: Call deferred

func _Interrupt():
	get_parent().get_node("Enemy Collision Detector").remove_from_group("Player")#TODO: Call deferred

func _Update(_delta: float) -> void:
	if is_instance_valid(GameManager.player):
		if GameManager.player.current_health == 0:
			character.emit_zero_health_signal()
	if is_trying_to_eject():
		eject()

func is_trying_to_eject() -> bool:
	if character.listening_to_inputs and rider != null:
		return Input.is_action_pressed("move_up") and Input.is_action_just_pressed("jump")
	return false
