extends TileMap

onready var tween = $tween

func _ready() -> void:
	tween.interpolate_property(self, "position",
			Vector2(position.x, position.y), Vector2(position.x + 200, position.y), 6,
			Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()
	
func _physics_process(delta: float) -> void:
	velocity = move_and_slide()
