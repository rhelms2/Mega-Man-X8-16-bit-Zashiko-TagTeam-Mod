extends Particles2D

onready var character = get_parent()

func _process(_delta) -> void:
	synchronize_part_animations()

		
func synchronize_part_animations()-> void:
	var animatedSprite = character.get_node("animatedSprite")
	var frame_texture = animatedSprite.get_sprite_frames().get_frame("test", 0)
	texture = frame_texture
