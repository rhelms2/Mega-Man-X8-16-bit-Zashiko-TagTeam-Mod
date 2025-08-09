extends Enemy

onready var damage_on_touch_damage = get_node("DamageOnTouch").damage
var floor_position: = 0.0


func emit_hit_particle():
	pass

func disable_visual_and_mechanics():
	current_health = 0
	pass

func hit(target):
	target.damage(damage_on_touch_damage, self)

func leave(_target):
	pass

func deflect(_body) -> void :
	pass
