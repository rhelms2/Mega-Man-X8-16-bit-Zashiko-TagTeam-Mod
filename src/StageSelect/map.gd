extends Sprite

const positions: = [ - 139, - 71, 227, 352]
const duration: = 1.0
const speed: = 90.0
var going_bottom: = false

onready var tween: = TweenController.new(self, false)

func _on_reposition_map(destination: Vector2) -> void :
	if is_destination_bottom(destination):
		if going_bottom:
			pass
		else:
			tween.reset()
			tween.attribute("position:y", positions[0], get_duration(positions[0]))
			going_bottom = true
		
	elif destination.y == 217:
		tween.attribute("position:y", positions[1], get_duration(positions[1]))
		going_bottom = false
	elif destination.y == - 123:
		tween.attribute("position:y", positions[2], get_duration(positions[2]))
		going_bottom = false
	elif destination.y == - 266:
		tween.attribute("position:y", positions[3], get_duration(positions[3]))
		going_bottom = false

func get_duration(destination_position: float) -> float:
	return abs(position.y - destination_position) / speed

func is_destination_bottom(destination: Vector2) -> bool:
	return destination.y > 217
