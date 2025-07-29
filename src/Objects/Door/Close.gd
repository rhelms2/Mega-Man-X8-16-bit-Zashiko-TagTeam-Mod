extends NewAbility
class_name DoorClose

onready var animation: AnimationController = AnimationController.new($"../animatedSprite", self)
onready var collider: CollisionShape2D = $"../collisionShape2D"

var player


func _Setup() -> void :
	player = GameManager.player
	$close.play()
	animation.play("closing")
	animation.on_finish("on_finished_animation", self)
	player.stop_forced_movement()
	player.cutscene_deactivate()

func on_finished_animation() -> void :
	if is_executing():
		GameManager.unpause("Door")
		Event.emit_signal("camera_follow_target")
		Event.emit_signal("door_transition_end")
		EndAbility()

func _Interrupt() -> void :
	collider.set_deferred("disabled", false)
	player.stop_forced_movement()
	if not player.is_executing("Ride"):
		player.start_listening_to_inputs()
