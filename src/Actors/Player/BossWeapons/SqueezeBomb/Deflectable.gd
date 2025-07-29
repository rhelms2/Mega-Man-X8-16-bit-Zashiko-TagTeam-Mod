extends WeaponDeflectable


func deflect(_body) -> void :
	projectile._OnDeflect()

func hit(_d = null) -> void :
	pass

func leave(_d = null) -> void :
	pass

func get_facing_direction() -> int:
	return projectile.get_facing_direction()
