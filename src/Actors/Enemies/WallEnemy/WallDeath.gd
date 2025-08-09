extends EnemyDeath
onready var bottom_sprite: AnimatedSprite = $"../bottomSprite"
onready var screw_texture: Line2D = $"../ScrewTexture"
onready var wall_area: StaticBody2D = $"../WallArea"

func extra_actions_after_death() -> void :
	bottom_sprite.visible = false
	screw_texture.visible = false
	
func extra_actions_at_death_start() -> void :
	wall_area.scale.y = 0
	pass
