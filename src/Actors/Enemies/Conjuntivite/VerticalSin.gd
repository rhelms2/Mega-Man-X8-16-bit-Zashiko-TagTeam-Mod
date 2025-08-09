extends AttackAbility

export var h_frequency := 1
export var h_range := 32
export var v_frequency := 1
export var v_range := 32
var initial_pos : Vector2

func _Setup() -> void:
	initial_pos = character.global_position
	timer = 0

func _ready() -> void:
	initial_pos = character.global_position
	character.global_position.y -= v_range
	character.global_position.x += h_range
	Event.connect("stage_rotate_end",self,"_Setup")

func _Update(_delta) -> void:
		character.global_position.y = initial_pos.y + ((sin(timer * v_frequency) * v_range))
		character.global_position.x = initial_pos.x - ((sin(timer * h_frequency) * h_range))
