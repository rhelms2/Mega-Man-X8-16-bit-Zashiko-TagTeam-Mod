extends Optic360


func on_ready() -> void:
	pass

func activate() -> void:
	rotate_laser()

func rotate_laser() -> void:
	Tools.tween(self,"rotation_degrees",rotation_order[1],duration + 0.5,Tween.EASE_IN_OUT,Tween.TRANS_SINE)

func disappear_and_throw_leaves() -> void:
	#rotation_degrees = 0
	animated_sprite.play("end")
	line.visible = false
	collision.visible = false
	animated_sprite.visible = false
	damage_on_touch.deactivate()

func deactivate() -> void:
	disappear_and_throw_leaves()
	Tools.tween(collision_noise,"volume_db",-80.0,0.35)
