extends AttackAbility

export var bomb :PackedScene
onready var tween := TweenController.new(self,false)
var can_drop := false

func _StartCondition() -> bool:
	return can_drop

func _Setup() -> void:
	$shot_sound.play()
	play_animation("drop")
	instantiate_projectile(bomb)
	#cria bomba

func _Update(_delta) -> void:
	if attack_stage == 0 and timer > 1.0:
		play_animation("run")
		tween.create()
		tween.set_ease(Tween.EASE_IN,Tween.TRANS_CUBIC)
		tween.add_attribute("global_position:y",global_position.y - 256,2.0,character)
		tween.add_callback("destroy",character)
		next_attack_stage()

func _Interrupt() -> void:
	tween.reset()


func _on_visibilityNotifier2D_screen_entered() -> void:
	can_drop = true
	pass # Replace with function body.


func _on_visibilityNotifier2D_screen_exited() -> void:
	can_drop = false
	pass # Replace with function body.
