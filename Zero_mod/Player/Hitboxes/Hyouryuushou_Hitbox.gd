extends SaberZeroHitbox
class_name HyouryuushouZeroHitbox

const bypass_shield: bool = true

onready var pause_script: Script = preload("res://Zero_mod/System/PauseInstance.gd")

var pause_duration: float = 2.5


func hit(target) -> void :
	if active:
		
		if saber_rehit != 0:
			if "saber_rehit" in target:
				
				if target.saber_rehit <= 0:
					if target is BossDamage:
						target.saber_rehit = saber_rehit * 8
						Event.emit_signal("saber_has_hit_boss")
						target.damage(damage, self)
					else:
						target.saber_rehit = saber_rehit
						var existing_pause_node = target.get_parent().get_node_or_null("Pause Enemy")
						if existing_pause_node != null:
							target.damage(damage, self)
						else:
							var pause_node = Node.new()
							pause_node.set_name("Pause Enemy")
							pause_node.set_script(pause_script)
							pause_node.pause_duration = pause_duration
							pause_node.paused_color = Color("#84d6e7")
							pause_node.frozen = true
							target.get_parent().add_child(pause_node)
						
							target.damage(damage, self)
							pause_node.start_pause(target.get_parent(), 0, self)
					
					Event.emit_signal("saber_has_hit")
					show_damage_values()

func deflect_projectile(body) -> void :
	if body.is_in_group("Enemy Projectile"):
		if body.has_method("_OnHit"):
			body._OnHit(self)
			return
		body.destroy()
