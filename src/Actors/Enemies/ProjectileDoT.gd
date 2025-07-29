extends DamageOnTouch
class_name ProjectileDOT

func should_deal_damage() -> bool:
	return target_list.size() > 0 and active

func _ready() -> void :
	if active:
		character.listen("hit", self, "deactivate")

func _on_area2D_body_entered(_body: Node) -> void :
	if active:
		if _body.is_in_group("Props") or _body.is_in_group("Player") and _body.get_character().listening_to_inputs:
			Log("Detected collision with " + _body.get_parent().name + "." + _body.name)
			hit(_body)

func _on_area2D_body_exited(_body: Node) -> void:
		leave(_body)

func deal_damage_to_targets_in_list():
	if target_list.size() > 0 and can_hit:
		for target in target_list:
			if is_instance_valid(target) and not target.is_invulnerable():
				Log("Dealing " + str(damage) + " damage to: " + target.name)
				get_parent().hit(target)

func play_shader():
	#nao sei pq isso esta aqui, deletar depois e ver o que acontece
	pass
