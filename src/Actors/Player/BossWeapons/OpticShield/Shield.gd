extends Node2D
export  var projectile: PackedScene
export  var duration: = 10.0
var active: = false
var fired_laser: = false
var timer: = 0.0
var creator
var tween: SceneTreeTween
var destroy_timer: = 0.35
onready var destroy_tween: = TweenController.new(self, false)
onready var front_shield: AnimatedSprite = $front_shield
onready var back_shield: AnimatedSprite = $back_shield
onready var light: Light2D = $light
onready var shot_sound: AudioStreamPlayer2D = $shot_sound

func _ready() -> void :
	back_shield.frame = 4
	global_position = GameManager.get_player_position()
	Event.connect("player_death", self, "queue_free")
	Event.connect("stage_teleport", self, "rotate_expire")
	Event.connect("stage_rotate", self, "rotate_expire")

func rotate_expire():
	set_pause_mode(Node.PAUSE_MODE_PROCESS)
	expire()

func initialize(_facing_direction) -> void :
	active = true
	tween = create_tween()
	front_shield.modulate = Color(12, 12, 12, 1)
	back_shield.modulate = Color(12, 12, 12, 1)
	tween.set_parallel()
	tween.tween_property(front_shield, "modulate", Color(1, 1, 1, 1), 0.25).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(back_shield, "modulate", Color(1, 1, 1, 1), 0.25).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)

func set_creator(_creator: Node) -> void :
	creator = _creator
	_creator.connect("damage", self, "expire")

func _physics_process(delta: float) -> void :
	
	global_position = GameManager.get_player_position()
	timer += delta
	if timer > duration:
		expire()
	destroy_after_time()

func expire(_discard = null, _discard2 = null) -> void :
	if active:
		active = false
		if tween:
			tween.kill()
			front_shield.modulate = Color(1, 1, 1, 1)
			back_shield.modulate = Color(1, 1, 1, 1)
		tween = create_tween()
		tween.set_parallel()
		tween.tween_property(front_shield, "modulate", Color(0, 1, 0, 0), 0.25)
		tween.tween_property(back_shield, "modulate", Color(0, 1, 0, 0), 0.25)
		tween.set_parallel(false)
		light.dim(0.3, 0)
		Tools.timer(0.35, "destroy", self)
	
func _on_area2D_body_entered(body: Node) -> void :
	if active:
		if body.is_in_group("Enemies") or body.is_in_group("Bosses"):
			return
		if body.active:
			react(body)

func react(body: Node) -> void :
	blink()
	call_deferred("fire_laser", body)
	call_deferred("deflect_projectile", body)
	destruction_countdown()

func blink() -> void :
	shot_sound.play_rp()
	back_shield.play("expand")
	back_shield.frame = 0
	front_shield.visible = false
	light.dim(0.3, 0)

func destruction_countdown() -> void :
	destroy_timer = 0.4
	destroy_tween.reset()
	destroy_tween.attribute("destroy_timer", 0, 0.4)
	
func destroy_after_time() -> void :
	if destroy_timer <= 0:
		
		destroy()

func deflect_projectile(body):
	if body.is_in_group("Enemy Projectile"):
		if "deflect" in body:
			body.deflect()
		else:
			body.destroy()

func fire_laser(body):
	if not fired_laser:
		fired_laser = true
		var shot = projectile.instance()
		get_tree().current_scene.add_child(shot, true)
		shot.set_global_position(global_position)
		shot.set_creator(creator)
		shot.initialize(1)
		
		var target = body
		if "creator" in body:
			target = body.creator
		if is_instance_valid(target):
			shot.rotate(get_angle_to(target.global_position))

func _on_area2D_area_entered(_area: Area2D) -> void :
	pass

func destroy() -> void :
	queue_free()
