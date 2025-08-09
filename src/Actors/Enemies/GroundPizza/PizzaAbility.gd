extends AttackAbility
class_name PizzaAbility

onready var damage_on_touch: DamageOnTouch = $"../DamageOnTouch"

var projectile: Area2D


func _ready() -> void :
	set_projectile()

func set_projectile() -> void :
	projectile = $"../Projectile_DoT/projectile"

func toggle_projectile_damage(b: bool) -> void :
	projectile.monitoring = b
	projectile.monitorable = b

func hide_projectile() -> void :
	projectile.visible = false

func projectile_active() -> bool:
	return projectile.monitorable

func unhide_projectile() -> void :
	projectile.visible = true

func deactivate_touch_damage() -> void :
	damage_on_touch.active = false

func activate_touch_damage() -> void :
	damage_on_touch.active = true
