extends Node2D

export var gravitybox : PackedScene
var floor_position := 0.0
onready var throw: AudioStreamPlayer2D = $throw

func _ready() -> void:
	$animatedSprite.playing = true
	if not GameManager.precise_is_on_screen(global_position):
		global_position.y = GameManager.camera.global_position.y - (224/2) + 48
	Tools.timer(0.2,"play_rp",throw)

func _on_animatedSprite_animation_finished() -> void:
	var b = gravitybox.instance()
	b.global_position = global_position
	b.floor_position = floor_position
	get_tree().current_scene.add_child(b)
	visible = false
	Tools.timer(0.5,"queue_free",self)
