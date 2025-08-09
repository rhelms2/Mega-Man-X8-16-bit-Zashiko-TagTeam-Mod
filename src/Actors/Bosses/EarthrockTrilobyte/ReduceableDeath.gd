extends BossDeath

var reduceable_time := 1.0

func reduce_final_timer() -> void:
	if executing:
		reduceable_time -= 0.1
		if reduceable_time <= 0.0:
			Achievements.unlock("PELEDOSGAMES")
	else:
		reduceable_time -= 0.001
	reduceable_time = clamp(reduceable_time,0.0,1.0)
	

func _EndCondition() -> bool:
	return elapsed_explosion_time >= explosion_time + 2.12 + reduceable_time and background_alpha <= 0

func _on_created_armor(armor : Node2D) -> void:
	armor.connect("bounced",self,"reduce_final_timer")
