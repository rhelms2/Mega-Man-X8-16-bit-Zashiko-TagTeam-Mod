extends SaberZeroHitbox
class_name EnkoukyakuZeroHitbox

onready var light: Light2D = $light

var light_color: Color = Color.orange
var light_range: Vector2 = Vector2(2, 2.5)


func _ready() -> void :
	pass

func hit(target) -> void :
	if active:
		if saber_rehit != 0:
			if "saber_rehit" in target:
				if target.saber_rehit <= 0:
					if target is BossDamage:
						target.saber_rehit = saber_rehit * 2
						Event.emit_signal("saber_has_hit_boss")
					else:
						target.saber_rehit = saber_rehit
						
					target.damage(damage, self)
					show_damage_values()
					spawn_saber_effect(target)
					Event.emit_signal("hit_enkoukyaku")
			else:
				target.damage(damage, self)
				Event.emit_signal("hit_enkoukyaku")

func deflect_projectile(body) -> void :
	if body.is_in_group("Enemy Projectile"):
		if body.has_method("_OnHit"):
			body._OnHit(self)
			return
		body.destroy()
