extends PizzaAbility
class_name PizzaDeflect

export  var wait_duration: float = 3.0

onready var _ai: = get_parent().get_node("AI")


func _Setup() -> void :
	attack_stage = 0
	retract_projectile()

func _Update(_delta: float) -> void :
	if timer > wait_duration:
		EndAbility()

func retract_projectile() -> void :
	var tween = get_tree().create_tween()
	tween.tween_callback(self, "toggle_projectile_damage", [false])
	tween.tween_callback(self, "deactivate_touch_damage")
	tween.tween_property(projectile, "position", Vector2(0.0, 13.0), 0.5)
	tween.tween_callback(self, "hide_projectile")
	tween.tween_callback(self, "play_animation_once", ["close"])

func _on_hittable_area_body_shape_entered(body_rid: RID, body: Node, body_shape_index: int, local_shape_index: int) -> void :
	if active:
		if body.is_in_group("Player Projectile"):
			_ai.activate_ability(_ai._on_get_hit)
			retract_projectile()
