extends AnimatedSprite

onready var blockage: Node2D = $"../../Scenery/GatewayTiled/Blockage"
onready var collider: CollisionShape2D = $"../../Scenery/GatewayTiled/Blockage/staticBody2D/collisionShape2D"

var active: bool = false


func _ready() -> void :
	if GatewayManager.has_defeated_copy_sigma():
		activate()

func activate() -> void :
	active = true
	visible = true

func set_alarm_off() -> void :
	active = false
	play("down")
	Event.emit_signal("gateway_final_section")
	blockage.visible = true
	collider.set_deferred("disabled", false)

func _on_area2D_body_entered(body: Node) -> void :
	if active:
		set_alarm_off()
