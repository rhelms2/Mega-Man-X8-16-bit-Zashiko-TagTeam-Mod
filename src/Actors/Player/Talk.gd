extends Node

export  var connect_at_start: = true
export  var character: = "MegaMan X"
export  var _animatedSprite: NodePath
onready var animated_sprite: = get_node(_animatedSprite)

func _ready() -> void :
	if connect_at_start:
		connect_talking()

func connect_talking():
		Event.listen("character_talking", self, "talk")

func talk(talking_character):
	if animated_sprite.animation == "idle" or animated_sprite.animation == "talk":
		if talking_character == character:
			if animated_sprite.animation != "talk":
				animated_sprite.play("talk")

		elif animated_sprite.animation != "idle":
			animated_sprite.play("idle")
