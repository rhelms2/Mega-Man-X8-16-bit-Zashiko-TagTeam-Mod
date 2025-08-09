extends TileMap

var rotate := false
var delay := 0.0
var last_rotate := 0.0
onready var parent = get_parent()

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("alt_fire"):
		rotate = true
		get_tree().paused = true
		delay = 0.1
		Event.emit_signal("stage_rotate")
	
	if delay > 0:
		delay += delta
		
	if rotate and delay > 0.25:
		rotation_degrees += delta * 85
		$X.rotation_degrees -= delta * 85

		if rotation_degrees >= last_rotate + 90:
			last_rotate += 90
			$X.rotation_degrees = -last_rotate
			rotation_degrees = last_rotate
			rotate = false
			GameManager.unpause("XXX")
			delay = 0
			Event.emit_signal("stage_rotate_end")
