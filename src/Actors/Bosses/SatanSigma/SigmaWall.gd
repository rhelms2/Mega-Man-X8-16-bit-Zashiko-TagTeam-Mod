extends Node2D
export var direction := 0
onready var sprite: Sprite = $sprite
onready var smoke: Particles2D = $smoke
onready var tween := TweenController.new(self,false)
onready var collider: CollisionShape2D = $staticBody2D/collisionShape2D
onready var rise: AudioStreamPlayer2D = $rise

onready var remains: Particles2D = $explosion_remains
onready var end_smoke: Particles2D = $end_smoke
onready var explosions: Particles2D = $explosions
onready var explode_sfx: AudioStreamPlayer2D = $explode_sfx



func _ready() -> void:
	sprite.region_rect.position.y = -289.0
	smoke.emitting = false
	Event.listen("sigma_walls",self,"activate")
	Event.listen("sigma_desperation",self,"on_desperation")
	Event.listen("boss_death_screen_flash",self,"queue_free")

func activate():
	smoke.emitting = true
	rise.play()
	tween.create(Tween.EASE_OUT,Tween.TRANS_CIRC)
	tween.add_attribute("region_rect:position:y",0.0,1.8,sprite)
	tween.add_callback("stop_smoke")
	collider.set_deferred("disabled",false)

func stop_smoke():
	smoke.emitting = false

func on_desperation(attack_direction : int):
	if direction == attack_direction:
		explosions.emitting = true
		end_smoke.emitting = true
		Tools.timer(1.65,"explode",self)
		Tools.timer(2,"end_explosion_vfx",self)
		emit_explode_sound()
		start_blink()
	
func end_explosion_vfx():
	explosions.emitting = false

func explode():
	smoke.emitting = false
	end_smoke.emitting = false
	remains.emitting = true
	collider.set_deferred("disabled",true)
	sprite.visible = false
	
func emit_explode_sound():
	if explosions.emitting == true:
		explode_sfx.play_rp()
		Tools.timer(0.17,"emit_explode_sound",self)

var blinking = false

func start_blink():
	if not blinking:
		blinking = true
		blink()

func blink():
	if blinking:
		if sprite.modulate.a == 1:
			sprite.modulate.a = 0
		else:
			sprite.modulate.a = 1
		Tools.timer(0.032,"blink",self)
	else:
		sprite.modulate.a = 1.0
