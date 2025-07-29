extends NewAbility

onready var animation = AnimationController.new($"../animatedSprite", self)
onready var collider: CollisionShape2D = $"../collisionShape2D"

func _ready() -> void :
	animation.on_finish("on_finished_animation", self)

func _StartCondition() -> bool:
	if is_executing():
		return false
	var non_states = ["Ride", "Finish"]
	return character.able_to_open and not GameManager.player.is_executing_either(non_states)

func _Setup() -> void :
	character._on_Lock()
	$open.play()
	animation.play("opening")
	GameManager.player.cutscene_deactivate()
	Event.emit_signal("disable_unneeded_objects")
	Event.emit_signal("door_transition_start")
	GameManager.pause("Door")

func on_finished_animation() -> void :
	if is_executing():
		collider.set_deferred("disabled", true)
		GameManager.unpause("Door")
		EndAbility()
