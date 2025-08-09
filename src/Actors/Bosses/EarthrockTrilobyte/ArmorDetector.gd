extends Area2D

signal armor_catch(armor)
var armor


func _ready() -> void:
	set_physics_process(false)

func _on_body_entered(body: Node) -> void:
	set_physics_process(true)
	armor = body

func _on_body_exited(body: Node) -> void:
	set_physics_process(false)
	armor = null

func _physics_process(delta: float) -> void:
	emit_signal("armor_catch",armor)
