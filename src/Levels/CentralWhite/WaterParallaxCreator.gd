extends ParallaxBackground

export  var water_piece: NodePath
export  var number_of_pieces: = 72
var pieces = []

func _ready() -> void :
	if not visible:
		return
	var i = 1
	var y = 0
	pieces.append(get_node(water_piece))
	while i <= number_of_pieces:
		var new_piece: ParallaxLayer = get_node(water_piece).duplicate()
		var sprite: Sprite = new_piece.get_child(0)
		var visual_y = clamp(ceil(float(i) / 6), 0, 10)
		if i > 4:
			new_piece.motion_scale.x += float(i) / (number_of_pieces * 2)
		new_piece.motion_offset.y += float(i) * 2
		sprite.region_rect.position.y = visual_y
		sprite.region_rect.position.x = round(rand_range( - 32, 32))
		sprite.flip_h = randi() %2 > 0
		add_child(new_piece)
		pieces.append(new_piece)
		i += 1

func _physics_process(delta: float) -> void :
	if not visible:
		return
	for piece in pieces:
		if piece.motion_scale.x > 4.0 / (number_of_pieces * 2):
			piece.motion_offset.x -= 30 * piece.motion_scale.x * delta
