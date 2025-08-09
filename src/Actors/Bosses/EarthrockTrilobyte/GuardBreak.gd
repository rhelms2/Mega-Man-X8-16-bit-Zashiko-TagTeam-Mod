extends Node

export var armor_scene : PackedScene
onready var character := get_parent()
onready var break_vfx: AnimatedSprite = $"../break_vfx"
var armor : Node2D
signal removed_armor
signal created_armor(armor)

func _on_guard_break(projectile) -> void:
	if not is_instance_valid(armor):
		armor = armor_scene.instance()
		get_tree().current_scene.add_child(armor,true)
		armor.set_global_position(character.global_position)
		armor.start(projectile)
		break_vfx.frame = 0
		emit_signal("removed_armor")
		emit_signal("created_armor",armor)

func _on_Trilobyte_ended_transform() -> void:
	if is_instance_valid(armor):
		armor.queue_free()
