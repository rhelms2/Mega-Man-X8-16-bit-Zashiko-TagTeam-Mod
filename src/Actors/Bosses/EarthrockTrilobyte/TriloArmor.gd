extends Actor

signal spawned(projectile)
signal bounced

func _ready() -> void:
	Event.connect("gateway_boss_defeated",self,"on_gateway_boss_defeated")

func start(projectile) -> void:
	emit_signal("spawned",projectile)

func catch() -> void:
	queue_free()


func _on_bounce() -> void:
	emit_signal("bounced")

func on_gateway_boss_defeated(boss_name : String):
	if boss_name == "trilobyte":
		queue_free()
