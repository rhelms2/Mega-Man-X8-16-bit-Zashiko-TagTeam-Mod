extends GenericProjectile
var exploded: = false
onready var vanish: AudioStreamPlayer2D = $vanish
onready var fire_1: Particles2D = $animatedSprite / fire1
onready var fire_2: Particles2D = $animatedSprite / fire2
onready var fire_3: Particles2D = $animatedSprite / fire3

onready var animatedSprite_zero = $animatedSprite_zero
onready var fire_zero_1: Particles2D = $animatedSprite / fire1
onready var fire_zero_2: Particles2D = $animatedSprite / fire2
onready var fire_zero_3: Particles2D = $animatedSprite / fire3
var zero: bool = false


func set_direction(new_direction):
	facing_direction = new_direction
	if not animatedSprite:
		animatedSprite = get_node("animatedSprite")
	animatedSprite.scale.x = new_direction
	if not animatedSprite_zero:
		animatedSprite_zero = get_node("animatedSprite_zero")
	animatedSprite_zero.scale.x = new_direction

func _Update(delta: float) -> void :
	if zero:
		animatedSprite.hide()
		animatedSprite_zero.show()
		fire_zero_1.emitting = true
		fire_zero_2.emitting = true
		fire_zero_3.emitting = true
	if not exploded and is_on_ceiling():
		explode()

func _OnHit(_d) -> void :
	pass

func explode() -> void :
	fire_1.emitting = false
	fire_2.emitting = false
	fire_3.emitting = false
	animatedSprite.play("explode")
	exploded = true
	if zero:
		fire_zero_1.emitting = false
		fire_zero_2.emitting = false
		fire_zero_3.emitting = false
		animatedSprite_zero.play("explode")
	disable_damage()
	Tools.timer(1, "destroy", self)
	vanish.play_rp()

