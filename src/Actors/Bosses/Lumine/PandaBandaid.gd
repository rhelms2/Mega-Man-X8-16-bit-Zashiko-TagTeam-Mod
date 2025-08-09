extends CollisionShape2D


func _ready() -> void:
	pass


func _on_Panda_transformed() -> void:
	set_deferred("disabled",false)
	pass # Replace with function body.
