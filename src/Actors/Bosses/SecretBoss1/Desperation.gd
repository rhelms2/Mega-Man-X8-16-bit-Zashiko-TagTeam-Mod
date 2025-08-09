extends AttackAbility

var images: Array
const move_duration: = 0.5
export  var _slash: PackedScene
onready var tween: = TweenController.new(self, false)
onready var damage: Node2D = $"../Damage"
onready var damage_on_touch: Node2D = $"../DamageOnTouch"
var angles = [0, 33, - 33, 90, 44, - 44, 25, - 25, 0, 90, 44, - 25, - 33]
onready var disappear: AudioStreamPlayer2D = $disappear
onready var charge: AudioStreamPlayer2D = $charge
onready var cuts_prepare: AudioStreamPlayer2D = $cuts_prepare

func _ready() -> void :
	for object in get_children():
		if object is AnimatedSprite:
			images.append(object)
			object.visible = false

func _Setup() -> void :
	turn_and_face_player()
	play_animation("desperation")
	charge.play()
	call_deferred("set_scale_x")

func set_scale_x():
	scale.x = get_facing_direction()

func _Update(delta: float) -> void :
	process_gravity(delta)
	if attack_stage == 0 and timer > 0.4:
		emit_clones()
		force_movement( - 15)
		call_deferred("decay_speed", 1, 1.5)
		next_attack_stage()
	
	elif attack_stage == 1 and timer > 1.5:
		vanish_clones()
		play_animation("vanish")
		disappear.play()
		damage.deactivate()
		damage_on_touch.deactivate()
		force_movement(0)
		next_attack_stage()
	
	elif attack_stage == 2 and timer > 1.0:
		cuts_prepare.play()
		create_slash(0)
		var i = 0.075
		var h = 0
		while i < 5:
			Tools.timer_p(i, "create_slash", self, angles[h])
			i += 0.075
			h += 1
			if h > angles.size() - 1:
				h = 0
		next_attack_stage()

	elif attack_stage == 3 and timer > 7:
		play_animation("jump_land")
		damage.activate()
		damage_on_touch.activate()
		decay_speed(1, 0.25)
		next_attack_stage()
		
	elif attack_stage == 4 and timer > 1.25:
		EndAbility()

func _Interrupt():
	._Interrupt()
	damage.activate()
	damage_on_touch.activate()
	vanish_clones()

func emit_clones():
	var clone_pos: = Vector2.ZERO
	var wait_time: = 0.05
	for clone in images:
		clone.visible = false
		if "_vanish" in clone.animation:
			clone.play(clone.animation.substr(0, 2))
		clone_pos = clone.position
		clone.position = Vector2.ZERO
		tween.create(Tween.EASE_OUT, Tween.TRANS_CUBIC)
		tween.add_wait(wait_time)
		tween.add_callback("set_visible", clone, [true])
		tween.add_attribute("position", clone_pos, move_duration, clone)
		wait_time += 0.12

func vanish_clones():
	for clone in images:
		clone.play(clone.animation + "_vanish")

func create_slash(degrees: float):
	var slash = _slash.instance()
	get_tree().current_scene.add_child(slash, true)
	slash.set_global_position(GameManager.get_player_position())
	slash.rotate_degrees(degrees)
	Tools.timer(0.85, "activate", slash)
