extends NewAbility

onready var physics = Physics.new(get_parent())
onready var animation = AnimationController.new($"../animatedSprite", self)
onready var tween = TweenController.new(self)

func should_execute() -> bool:
	return active and character.ride.is_executing() and current_conflicts.size() == 0

func _Setup() -> void:
	if animation.is_currently("punch_1") or animation.is_currently("punch_2"):
		animation.play("recover",1)
	elif not animation.is_currently("activate") and not animation.is_currently("recover"):
		animation.play("recover")
	physics.set_vertical_speed(0)
	if abs(physics.get_horizontal_speed()) > 90:
		tween.method("set_horizontal_speed",physics.get_horizontal_speed(),0,0.35,physics)
	else:
		physics.set_horizontal_speed(0)

func _on_knockback() -> void:
	if tween.is_valid():
		tween.reset()
		physics.set_horizontal_speed(0)

func connect_conflicts() -> void:
	var exceptions := ["Ride","Shot","Death"]
	for ability in character.get_all_abilities():
		if not ability.name in exceptions:
			ability.connect("start",self,"_on_hard_conflict")
			ability.connect("stop",self,"_on_hard_conflict_stop")
