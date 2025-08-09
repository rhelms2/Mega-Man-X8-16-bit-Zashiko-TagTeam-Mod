extends Camera2D


const width: = 398
const height: = 224
var trauma = 0.0
var decay = 1
var trauma_power = 3
const max_offset: = Vector2(4, 4)

func _ready() -> void :
	GameManager.camera = self
	connect_events()

func connect_events() -> void :
	Event.listen("screenshake", self, "add_trauma")
	
func add_trauma(amount):
	trauma = min(trauma + amount, 1.0)
	trauma = clamp(trauma, 0.1, 1.5)
