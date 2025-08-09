extends Attack
class_name ProjectileShot

export var sound2 : AudioStream
export(PackedScene) var projectile
var shot_positions = []

func _ready() -> void:
	for child in get_children():
		if not (child is AudioStreamPlayer2D):
			shot_positions.append(child)

func fire() -> void:
	play_sound(sound)
	for shot_pos in shot_positions:
		var _shot = projectile.instance()
		get_tree().current_scene.add_child(_shot)
		position_shot(_shot, shot_pos)

func fire_condition(trigger) -> bool:
	if "prepare" in trigger:
		play_sound(sound2)
	return "fire" in trigger

func position_shot(shot, shot_pos) -> void:
	shot.transform = global_transform
	shot.projectile_setup(owner.get_facing_direction(), shot_pos.position)
