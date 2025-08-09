extends Node

export var current_health := 32

signal zero_health
signal reduced_health

func set_health_to_zero() -> void:
	_on_DamageReceiver_received_damage(current_health,self)

func _on_DamageReceiver_received_damage(damage, _inflicter) -> void:
	current_health -= damage
	if current_health <= 0:
		emit_signal("zero_health")
	else:
		emit_signal("reduced_health")
