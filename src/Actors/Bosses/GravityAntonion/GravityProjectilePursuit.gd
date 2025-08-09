extends AttackAbility
var pursuit_speed:= 30.0
onready var damage_on_touch: Node2D = $"../DamageOnTouch"

func _Setup() -> void:
	character.modulate = Color(15,10,20,1)
	tween_attribute("modulate",Color.white,1.0,character)
	tween_attribute("pursuit_speed",1.0,7.0)
	Tools.timer(0.45, "activate_damage",self)
	
func _Update(_delta) -> void:
	pursuit()
	if timer > 7:
		character.current_health = 0
		EndAbility()

func activate_damage() -> void:
	if executing:
		damage_on_touch.activate()

func pursuit() -> void:
	var target_direction = (GameManager.get_player_position() - global_position).normalized()
	force_movement_regardless_of_direction(pursuit_speed * target_direction.x)
	set_vertical_speed(pursuit_speed * target_direction.y)
