extends NewAbility

export var punch_projectile : PackedScene

onready var physics = Physics.new(get_parent())
onready var animation = AnimationController.new($"../animatedSprite", self)
onready var tween = TweenController.new(self)
onready var punch_sfx: AudioStreamPlayer2D = $punch
onready var punch_position: Node2D = $punch_position
onready var wind: Sprite = $wind

var next_punch := false
var another_punch := "punch_1"
var last_projectile

func _on_fire() -> void:
	if not is_executing():
		_on_signal()
	else:
		next_punch = true

func _Setup() -> void:
	punch_sfx.play_rp(0.05,0.85)
	animation.play(another_punch)
	set_next_time_punch(get_other(another_punch))
	Tools.timer(0.03,"create_punch_projectile",self)
	tween.method("set_horizontal_speed",physics.get_horizontal_speed(),0,0.35,physics)
	
func _Update(_delta) -> void:
	physics.process_gravity(_delta)
	if next_punch:
		throw_punch()
	
	elif not animation.is_playing("punch_1") and not animation.is_playing("punch_2"):
		EndAbility()

func throw_punch() -> void:
	if animation.has_finished("punch_1"):
		throw_next("punch_1")
	
	elif animation.has_finished("punch_2"):
		throw_next("punch_2")

func throw_next(punch) -> void:
	if not animation.is_playing(get_other(punch)):
		animation.play(get_other(punch))
		set_next_time_punch(punch)
		next_punch = false
		punch_sfx.play_rp(0.05,0.85)
		create_punch_projectile()
		#Tools.timer(0.03,"create_punch_projectile",self)

func set_next_time_punch(punch) -> void:
	another_punch = punch

func get_other(punch) -> String:
	if punch == "punch_1":
		return "punch_2"
	return "punch_1"

func create_punch_projectile() -> void:
	last_projectile = instantiate(punch_projectile)
	Tools.timer(0.1,"destroy",last_projectile)
	wind.emit()

func instantiate(scene : PackedScene) -> Node2D:
	var instance = scene.instance()
	add_child(instance,true)
	instance.set_global_position(punch_position.global_position) 
	instance.set_creator(character)
	instance.initialize(character.get_facing_direction())
	return instance

func _on_land() -> void:
	if is_executing():
		EndAbility()

func _Interrupt() -> void:
	#animation.play("recover",1)
	pass
	#if is_instance_valid(last_projectile):
	#	last_projectile.destroy()

func _on_new_direction(dir) -> void:
	scale.x = dir


func _on_knockback() -> void:
	if tween.is_valid():
		tween.reset()
		physics.set_horizontal_speed(0)
