extends EnemyShield

func _ready() -> void:
	pass

func activate() -> void:
	.activate()
	character.add_invulnerability(name)
	
func deactivate() -> void:
	.deactivate()
	character.remove_invulnerability(name)
