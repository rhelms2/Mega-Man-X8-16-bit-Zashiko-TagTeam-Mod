extends Node

export var armor_sprites : Resource
export var naked_sprites : Resource
onready var animated_sprite: AnimatedSprite = $"../animatedSprite"
var executing:= false
onready var enemy_shield: Node2D = $"../EnemyShield"
onready var armor_detector: CollisionShape2D = $"../ArmorDetector/collisionShape2D"
onready var damage: Node2D = $"../Damage"

func _on_EnemyShield_guard_broken(_projectile) -> void:
	if executing:
		animated_sprite.change_frames(naked_sprites)
		armor_detector.disabled = false

func _on_Trilobyte_transformed() -> void:
	enemy_shield.activate()
	enemy_shield.activate_breakable()
	damage.ignore_nearby_hits = true
	executing = true

func _on_Trilobyte_ended_transform() -> void:
	enemy_shield.deactivate()
	armor_detector.disabled = true
	damage.ignore_nearby_hits = false
	executing = false

func _on_EnemyShield_catch() -> void:
	if executing:
		animated_sprite.change_frames(armor_sprites)
		armor_detector.disabled = true
