extends SaberZeroHitbox
class_name YoudantotsuZeroHitbox

const bypass_shield: bool = true


func deflect_projectile(body):
	if body.is_in_group("Enemy Projectile"):
		if body.has_method("_OnHit"):
			body._OnHit(self)
			return
		body.destroy()
