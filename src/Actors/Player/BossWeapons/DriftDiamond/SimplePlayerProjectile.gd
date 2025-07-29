extends GenericProjectile
class_name SimplePlayerProjectile

export  var pop_in_time: float = 0.048

var ending: bool = false


func _Setup() -> void :
	if is_instance_valid(animatedSprite):
		animatedSprite.visible = false

func _Update(_delta: float) -> void :
	if not animatedSprite.visible and timer > pop_in_time and not ending:
		enable_visuals()
	if ending and timer > 1:
		destroy()

func enable_visuals() -> void :
	Log("Enabling Visuals")
	animatedSprite.visible = true

func _OnHit(_target_remaining_HP) -> void :
	Log("On hit")
	disable_visuals()

func stop() -> void :
	set_vertical_speed(0)
	set_horizontal_speed(0)

func _OnDeflect() -> void :
	disable_visuals()
	stop()

func disable_visuals() -> void :
	ending = true
	timer = 0
	stop()
	Log("Disabling Visuals")
	if is_instance_valid(animatedSprite):
		animatedSprite.visible = false
	disable_damage()
	
func enable_damage() -> void :
	$collisionShape2D.set_deferred("disabled", false)

func disable_damage() -> void :
	$collisionShape2D.set_deferred("disabled", true)

func _OnScreenExit() -> void :
	ending = true

func is_collided_moving() -> bool:
	return get_last_slide_collision().collider_velocity != Vector2.ZERO

func has_hit_scenery() -> bool:
	return is_on_floor() or is_on_wall() or is_on_ceiling()
