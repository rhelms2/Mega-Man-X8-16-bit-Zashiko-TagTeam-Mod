extends Enemy

onready var particles_2d: Particles2D = $particles2D
onready var fire_2: Particles2D = $animatedSprite/fire2
onready var fire_3: Particles2D = $animatedSprite/fire3
onready var fire_1: Particles2D = $animatedSprite/fire1
onready var particles :=[particles_2d,fire_1,fire_2,fire_3]
onready var fire_loop: AudioStreamPlayer2D = $fire_loop
onready var damage_on_touch: Node2D = $DamageOnTouch

func _ready() -> void:
	pass

func on_boss_death():
	damage_on_touch.deactivate()
	modulate = Color(1,1,1,0.01)
	animatedSprite.playing = false
	fire_loop.stop()
	for p in particles:
		p.emitting = false
	$sublight.visible = false
	Tools.timer(4,"end",self)

func end():
	queue_free()
