extends TextureRect

export  var speed = 50
var start_position = Vector2(127, 7)
var distance = 0
var max_movement = 13

func _ready():
	set_process(true)

func _process(delta):
	rect_position.x += speed * delta
	distance += speed * delta
	
	if distance >= max_movement:
		rect_position = start_position
		distance = 0
