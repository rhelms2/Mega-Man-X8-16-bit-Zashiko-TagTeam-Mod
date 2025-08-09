extends NewAbility

onready var physics = Physics.new(get_parent())
onready var dmg: AudioStreamPlayer2D = $dmg
onready var tween = TweenController.new(self)

var damage_direction := 0

signal knockback

func _on_damage(_value, inflicter) -> void:
	define_damage_direction(inflicter)
	_on_signal()
	
func should_execute() -> bool:
	return current_conflicts.size() == 0

func _Setup() -> void:
	dmg.play_rp(0.05, 0.85)
	character.flash(0.064)
	character.blink()
	tween.method("set_bonus_horizontal_speed",-250*damage_direction,0,0.15,physics)
	tween.end_ability()
	emit_signal("knockback")

func _Interrupt() -> void:
	physics.set_bonus_horizontal_speed(0)

func define_damage_direction(inflicter) -> void:
	damage_direction = physics.get_direction_relative(inflicter)
