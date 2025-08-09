extends GenericProjectile
onready var anim: AnimatedSprite = $animatedSprite
var dying := false
onready var collider: CollisionShape2D = $area2D/collisionShape2D
onready var fire_1: Particles2D = $fire1
onready var fire_2: Particles2D = $fire2
onready var fire_3: Particles2D = $fire3

func _Setup():
	set_vertical_speed(-255)
	anim.playing = true
	
func _on_animatedSprite_animation_finished() -> void:
	if anim.animation == "start":
		anim.play("loop")
	elif timer > 0.35:
		if anim.animation == "loop":
			anim.play("end")
			phoenix_end()

func _OnHit(_target_remaining_HP) -> void: #override
	pass

func phoenix_end() -> void:
	if not dying:
		dying = true
		collider.disabled = true
		fire_1.emitting = false
		fire_2.emitting = false
		fire_3.emitting = false
		var tween = get_tree().create_tween()
		tween.tween_property(self,"velocity",Vector2.ZERO,0.35)
		tween.tween_callback(self,"destroy")
