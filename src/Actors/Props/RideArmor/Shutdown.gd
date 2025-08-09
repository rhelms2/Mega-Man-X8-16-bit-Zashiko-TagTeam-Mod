extends NewAbility

onready var physics = Physics.new(get_parent())
onready var animation = AnimationController.new($"../animatedSprite", self)

func should_execute() -> bool:
	return current_conflicts.size() == 0

func _Setup() -> void:
	#animation.play("deactivated")
	pass

func _Update(delta) -> void:
	physics.process_gravity(delta)

func _on_Eject_stop(_ability_name) -> void:
	_on_signal()
