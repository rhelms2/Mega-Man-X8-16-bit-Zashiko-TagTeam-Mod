extends AnimatedSprite

export var naked_sprites : Resource
var armor_sprites

func _ready() -> void:
	armor_sprites = frames


func _on_EnemyShield_activated() -> void:
	var f = frame
	frames = armor_sprites
	frame = f


func _on_EnemyShield_deactivated() -> void:
	var f = frame
	frames = naked_sprites
	frame = f
