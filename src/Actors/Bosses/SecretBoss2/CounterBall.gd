extends Node2D

onready var sprite: AnimatedSprite = $ball
onready var touch_damage: Node2D = $DamageOnTouch
onready var laser_damage: Node2D = $laser / damage
onready var hittable_area: Area2D = $EnemyShield / hittable_area
onready var laser: AnimatedSprite = $laser
onready var shield: Node2D = $EnemyShield
onready var shot_sfx: AudioStreamPlayer2D = $prepare
onready var tween: = TweenController.new(self, false)
onready var orbtween: = TweenController.new(self, false)
var active: = false
var onscreen: = false
onready var move_sfx: AudioStreamPlayer2D = $move_sfx

func _ready() -> void :
	laser.visible = false
	oscilatte_center()
	Tools.timer(8 + rand_range( - 1.2, 1.2), "expire", self)
	move_sfx.play_r()
	Event.connect("first_secret2_death", self, "queue_free")

func move(destination: Vector2):
	tween.reset()
	tween.create(Tween.EASE_IN_OUT, Tween.TRANS_SINE)
	tween.add_attribute("position", destination, 1.0 + rand_range(0.0, 0.2))
	Tools.timer(0.5, "activate", self)

func activate():
	if not expiring:
		active = true
		shield.activate()

func _on_area2D_body_entered(_body: Node) -> void :
	counter()

func oscilatte_center():
	orbtween.reset()
	orbtween.create(Tween.EASE_IN_OUT, Tween.TRANS_SINE)
	orbtween.add_attribute("position:y", - 3.0, 0.6, sprite)
	orbtween.add_attribute("position:y", 3.0, 1.2, sprite)
	orbtween.add_attribute("position:y", 0.0, 0.6, sprite)
	orbtween.add_callback("oscilatte_center")

func counter():
	if active:
		orbtween.reset()
		tween.reset()
		active = false
		hittable_area.monitoring = false
		aim_laser()
		sprite.visible = false
		Tools.timer(1.25, "queue_free", self)

func aim_laser():
	orbtween.reset()
	tween.reset()
	if onscreen:
		laser.visible = true
		laser.frame = 0
	laser.look_at(GameManager.get_player_position())
	Tools.timer(0.16, "fire_laser", self)
	
func fire_laser():
	orbtween.reset()
	tween.reset()
	if onscreen:
		laser_damage.activate()
		laser.play("fire")
	else:
		laser.visible = false
	sprite.visible = true
	sprite.play("explode")
	touch_damage.activate()
	shot_sfx.play_r()


var expiring: = false
func expire():
	if hittable_area.monitoring:
		active = false
		expiring = true
		hittable_area.monitoring = false
		tween.attribute("modulate:a", 0.0, 0.3)
		tween.callback("queue_free")

func _on_EnemyShield_shield_hit(projectile) -> void :
	if not "GigaCrash" in projectile.name and not "DamageArea" in projectile.name:
		counter()

func _on_screen_entered() -> void :
	onscreen = true
	pass


func _on_screen_exited() -> void :
	onscreen = false
	pass
