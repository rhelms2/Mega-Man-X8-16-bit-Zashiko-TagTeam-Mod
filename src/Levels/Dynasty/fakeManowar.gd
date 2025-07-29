extends AnimatedSprite
export  var duration: = 12.0
onready var path: PathFollow2D = $".."
var started: = false

func move() -> void :
		var tween: = create_tween().set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN_OUT)

		tween.tween_property(path, "unit_offset", 1.0, duration)

		tween.tween_callback(self, "queue_free")

func _on_trigger_zone_body_entered(_body: Node) -> void :
	if not started and not "manowar_weapon" in GameManager.collectibles:
		move()
		started = true
