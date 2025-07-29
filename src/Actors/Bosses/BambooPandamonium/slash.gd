extends Node2D
class_name BambooSlash

onready var slash_hitbox: Node2D = $SlashHitbox
onready var animated_sprite: AnimatedSprite = $animatedSprite

signal activated

func _ready() -> void:
	animated_sprite.frame = 0
	animated_sprite.playing = true

func activate(duration := 0.55) -> void:
	z_index += 1
	animated_sprite.play("fire")
	animated_sprite.frame = 0
	slash_hitbox.activate()
	emit_signal("activated")
	Tools.timer(duration,"queue_free",self)

func rotate_degrees(degrees : float) -> void:
	rotation_degrees = degrees

func set_character(character) -> void:
	slash_hitbox.set_character(character)

func set_combo(combo_hitbox):
	slash_hitbox.connect_combo(combo_hitbox)

func get_hitbox():
	return slash_hitbox
