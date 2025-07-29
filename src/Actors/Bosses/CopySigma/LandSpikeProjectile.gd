extends GenericProjectile
onready var vanish: AudioStreamPlayer2D = $vanish
export  var mini_projectile: PackedScene
var exploded: = false
onready var fire_1: Particles2D = $fire1
onready var fire_2: Particles2D = $fire2
onready var fire_3: Particles2D = $fire3
var zero: bool = false


func _Update(delta: float) -> void :
	if not exploded and is_on_wall():
		explode()

func explode() -> void :
	fire_1.emitting = false
	fire_2.emitting = false
	fire_3.emitting = false
	exploded = true
	animatedSprite.play("explode")
	disable_damage()
	Tools.timer(1, "destroy", self)
	vanish.play_rp()
	create_mini_projectile()

func create_mini_projectile():
	var projectile = mini_projectile.instance()
	get_tree().current_scene.add_child(projectile, true)
	projectile.set_global_position(global_position)
	projectile.set_creator(creator)
	projectile.initialize(facing_direction)
	projectile.set_vertical_speed( - 150)
	if zero:
		projectile.zero = zero
		projectile.set_vertical_speed( - 250)

func _OnHit(_target_remaining_HP) -> void :
	pass

