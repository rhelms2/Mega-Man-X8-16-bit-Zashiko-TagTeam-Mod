extends NewAbility

onready var animation = AnimationController.new($"../animatedSprite", self)
onready var collider: CollisionShape2D = $"../collisionShape2D"
onready var open: AudioStreamPlayer2D = $open

signal waiting

func _ready() -> void :
	animation.on_finish("on_finished_animation", self)

func _StartCondition() -> bool:
	if is_executing():
		return false
	return true

func _Setup() -> void :
	open.play()
	animation.play("opening")

func on_finished_animation() -> void :
	if is_executing() and animation.has_finished("opening"):
		collider.set_deferred("disabled", true)
		emit_signal("waiting")
		
func _Interrupt() -> void :
	open.play()
	animation.play("closing")
	collider.set_deferred("disabled", false)


func _on_player_present(_body) -> void :
	if is_executing():
		if character.close_after_freeway:
			EndAbility()
