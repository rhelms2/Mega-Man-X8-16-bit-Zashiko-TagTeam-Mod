extends Node2D
onready var sprite: Sprite = $sprite
onready var smoke: Particles2D = $smoke
onready var tween: = TweenController.new(self, false)
onready var collider: CollisionShape2D = $staticBody2D / collisionShape2D
onready var rise: AudioStreamPlayer2D = $rise
onready var close: AudioStreamPlayer2D = $close
onready var smoke_2: Particles2D = $smoke2

signal finished

func _ready() -> void :
	sprite.region_rect.position.y = 96
	smoke.emitting = false

func activate():
	Tools.timer(0.9, "close_door", self)

func close_door():
	smoke.emitting = true
	rise.play()
	tween.create(Tween.EASE_IN, Tween.TRANS_QUART)
	tween.add_attribute("region_rect:position:y", 0.0, 1.8, sprite)
	tween.add_callback("stop_smoke")
	collider.set_deferred("disabled", false)

func stop_smoke():
	smoke.emitting = false
	smoke_2.emitting = true
	close.play_rp()
	Event.emit_signal("screenshake", 2.0)
	Event.emit_signal("show_warning")
	var player = GameManager.player
	
	GameManager.player.set_direction(1, true)
	GameManager.player.animatedSprite.play("recover")
	emit_signal("finished")
