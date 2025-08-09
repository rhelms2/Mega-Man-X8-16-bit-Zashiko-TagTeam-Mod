extends GenericIntro
onready var damage: Node2D = $"../Damage"
onready var damage_on_touch: Node2D = $"../DamageOnTouch"

var target := Vector2(400.0,-20)

func prepare_for_intro() -> void:
	animatedSprite.visible = false
	damage.call_deferred("deactivate")
	damage_on_touch.call_deferred("deactivate")
	set_direction(1)
	
func _Setup():
	play_animation("idle_loop")
	animatedSprite.visible = true
	damage.call_deferred("activate")
	damage_on_touch.call_deferred("activate")
	var tween = create_tween()
	character.position.x = -1200
	character.position.y = 80
	tween.tween_property(character,"position",target,4).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE)

func _Update(_delta) -> void:
	if attack_stage == 0 and character.position.x >= target.x:
		var tween = create_tween()
		tween.tween_property(character,"position",Vector2(0,0),4).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
		next_attack_stage()
	if attack_stage == 1 and character.position.x == 0:
		EndAbility()
		#character.emit_signal("intro_concluded")
