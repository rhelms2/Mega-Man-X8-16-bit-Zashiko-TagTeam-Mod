extends Node2D



onready var animatedSprite: AnimatedSprite = get_parent().get_node("animatedSprite")
onready var hoverSprite: AnimatedSprite = animatedSprite.get_node("HoverEffect")
onready var y_offset_deafult: int = - 2
onready var x_offset: int = 0
onready var y_offset: int = y_offset_deafult
onready var extra_x_offset: int = 0
onready var extra_y_offset: int = 0


func get_offset() -> void :
	var current_animation = animatedSprite.animation
	var is_facing_left = animatedSprite.scale.x < 0
	extra_x_offset = 0
	extra_y_offset = 0
	match current_animation:
		"beam":
			x_offset = 0
			y_offset = - 9
		"beam_in":
			x_offset = 0
			y_offset = - 9
		"beam_equip":
			x_offset = 0
			y_offset = - 9
		"walk":
			x_offset = 0
			y_offset = - 2
		"slide":
			x_offset = 3
			y_offset = - 1
		"shot_slide":
			x_offset = 3
			y_offset = - 1
		"hover":
			x_offset = 0
			var hover_offset = 0
			if hoverSprite.frame == 0:
				hover_offset = 0
			if hoverSprite.frame == 1 or hoverSprite.frame == 3:
				hover_offset = - 1
			if hoverSprite.frame == 2:
				hover_offset = - 2
				
			y_offset = y_offset_deafult + hover_offset
			hoverSprite.offset.y = y_offset_deafult + hover_offset

		"shot_air":
			x_offset = 0
			var hover_offset = 0
			if hoverSprite.frame == 0:
				hover_offset = 0
			if hoverSprite.frame == 1 or hoverSprite.frame == 3:
				hover_offset = - 1
			if hoverSprite.frame == 2:
				hover_offset = - 2
			
			y_offset = y_offset_deafult + hover_offset
			hoverSprite.offset.y = y_offset_deafult + hover_offset

		"shot":
			x_offset = 0
			y_offset = y_offset_deafult
		_:
			x_offset = 0
			y_offset = y_offset_deafult
	animatedSprite.offset.x = x_offset + extra_x_offset
	animatedSprite.offset.y = y_offset + extra_y_offset

func _physics_process(_delta: float) -> void :
	get_offset()
