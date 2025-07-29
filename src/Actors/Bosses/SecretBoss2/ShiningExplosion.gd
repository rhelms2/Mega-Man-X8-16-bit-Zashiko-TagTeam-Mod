extends Node2D

onready var warning: AnimatedSprite = $warning
onready var prepare_sfx: PitchStreamPlayer2D = $prepare
onready var damage: Node2D = $DamageOnTouch
onready var explosion: AnimatedSprite = $explosion
onready var explosion_sfx: PitchStreamPlayer2D = $explosion_sfx

var expiring := false

func _ready() -> void:
	prepare()
	Event.connect("first_secret2_death",self,"queue_free")
	
func expire():
	expiring = true
	
func prepare():
	warning.frame = 0
	prepare_sfx.play_r()
	Tools.timer(.45,"deal_damage",self)
	

func deal_damage() -> void:
	if not expiring:
		damage.activate()
		explosion_sfx.play_r(0.07)
		explosion.frame = 0
		Tools.timer(0.1,"deactivate",damage)
	Tools.timer(1,"queue_free",self)
