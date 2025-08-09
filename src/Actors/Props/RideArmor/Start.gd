extends NewAbility

onready var animation = AnimationController.new($"../animatedSprite", self)
onready var physics = Physics.new(get_parent())
onready var startup: AudioStreamPlayer2D = $startup
onready var vento: Sprite = $vento

signal stand_up

func _Setup() -> void:
	animation.play("activate")
	startup.play_rp()
	Tools.timer(0.5,"emit",vento)
	emit_signal("stand_up")
	#Tools.timer(0.5,"emit_stand_up",self)

func _Update(_delta) -> void:
	physics.process_gravity(_delta)

func _EndCondition() -> bool:
	return timer > 0.9

func emit_stand_up() -> void:
	emit_signal("stand_up")

func on_new_direction(dir) -> void:
	scale.x = dir
