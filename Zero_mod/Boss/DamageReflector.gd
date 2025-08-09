extends Node2D

onready var character: = get_parent()
onready var effect: = character.get_node("animatedSprite/effectSprite")
onready var effect_sfx: = character.get_node("awakened_sfx")
onready var damage_sfx: = character.get_node("damage")
onready var shot_sfx: AudioStreamPlayer2D = $prepare
onready var dmg: = character.get_node("Damage")
onready var shield: Node2D = $EnemyShield

var deflects_max: int = 4
var deflects: = deflects_max
var target: Vector2
var active: = false
var shield_rehit_timer: float = 0.0
var shield_rehit_time: float = 0.1

signal started_deflect
signal deflected
signal resetted
signal vanished
signal shield_broken


func _ready() -> void :
	Tools.timer(0.1, "deactivate_damage", self)
	set_physics_process(true)

func reset():
	deflects = deflects_max
	deactivate_damage()
	emit_signal("resetted")

func deactivate_damage():
	shield.activate()
	if dmg != null:
		dmg.deactivate()

func activate_damage():
	shield.deactivate()
	if dmg != null:
		dmg.activate()

func get_player_position():
	target = GameManager.get_player_position()

func _start_blink_effect(blinks: int) -> void :
	for child in get_children():
		if child is Timer:
			child.stop()
			child.queue_free()
	if blinks <= 0:
		effect.animation = "default"
		return
	if effect.animation == "default":
		effect.animation = "hit"
	else:
		effect.animation = "default"
	Tools.timer_p(0.025, "_start_blink_effect", self, [blinks - 1])

func update_effect_speed(_current: int, _max: int) -> void :
	var max_speed = 2.0
	if _max == 0:
		effect.speed_scale = 1.0
		return
	var ratio = float(_current - 1) / float(_max)
	var speed = max_speed - ratio
	effect.speed_scale = clamp(speed, 1.0, max_speed)

func counter_attack():
	emit_signal("deflected")
	shot_sfx.play_r()
	update_effect_speed(deflects, deflects_max)
	if deflects < 20:
		_start_blink_effect(deflects * 2)
	if deflects == 0:
		damage_sfx.play()
		activate_damage()
		effect.visible = false
		effect_sfx.stop()
		emit_signal("shield_broken")

func _physics_process(delta: float) -> void :
	if shield_rehit_timer > 0:
		shield_rehit_timer -= delta

func _on_shield_hit(projectile) -> void :
	if shield_rehit_timer <= 0:
		if active and deflects > 0:
			shield_rehit_timer = shield_rehit_time
			if "GigaCrash" in projectile.name:
				deflects = 0
				activate_damage()
				emit_signal("vanished")
				pass
			elif not "DamageArea" in projectile.name:
				deflects -= 1
				emit_signal("started_deflect")
				get_player_position()
				counter_attack()

func deactivate():
	active = false
	shield.deactivate()

func activate():
	active = true
	effect.visible = true
	effect_sfx.play()
	effect.speed_scale = 1.0




