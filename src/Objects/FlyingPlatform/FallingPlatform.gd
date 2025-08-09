extends KinematicBody2D

onready var collision_shape_2d: CollisionShape2D = $collisionShape2D
onready var animated_sprite: AnimatedSprite = $animatedSprite

var falling: bool = false
var falling_speed: float = 2.0
var tween: SceneTreeTween


func _ready() -> void :
	Event.listen("player_death", self, "stop_tween")

func _on_area2D_body_entered(_body: Node) -> void :
	if not falling:
		falling = true
		tween = get_tree().create_tween()
		animated_sprite.play("dying")
		tween.tween_property(self, "position:y", position.y, 0.5)
		tween.tween_property(self, "global_position:y", global_position.y + 300.0, falling_speed).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CUBIC)
		tween.tween_callback(self, "disable_everything")

func disable_everything() -> void :
	collision_shape_2d.disabled = true
	animated_sprite.visible = false
	
func stop_tween() -> void :
	pass
