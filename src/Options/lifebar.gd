extends NinePatchRect
onready var current: TextureProgress = $current

onready var original_pos = Vector2(rect_position.x, rect_size.x)
var original_max_health = CharacterManager.starting_max_health
var complete_max_health

func _ready() -> void :
	complete_max_health = original_max_health + (CharacterManager.heart_tank_buff_amt * 8)
	pass

func _process(_delta: float) -> void :
	if visible and GameManager.player and is_instance_valid(GameManager.player):
		current.value = complete_max_health * inverse_lerp(0, complete_max_health, GameManager.player.current_health)
		
		var s = GameManager.player.max_health - original_max_health
		if s > 0 and rect_position.x != original_pos.x - s:
			rect_position.x = original_pos.x - s
			rect_size.x = original_pos.y + s * 2
		
