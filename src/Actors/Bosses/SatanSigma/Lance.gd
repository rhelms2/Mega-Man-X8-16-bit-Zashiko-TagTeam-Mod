extends Node2D

onready var damage: Node2D = $DamageOnTouch
onready var animation := AnimationController.new($animatedSprite)
onready var state := AbilityStage.new(self,false)
onready var trail: AnimatedSprite = $trail
onready var trail_2: AnimatedSprite = $trail2
onready var trail_3: AnimatedSprite = $trail3
onready var trail_4: AnimatedSprite = $trail4
onready var long_damage: Node2D = $DamageOnTouch2
onready var firetip: Particles2D = $firetip
onready var fire: Particles2D = $evilfire_particles

onready var trails = [trail_4,trail_3,trail_2,trail]
var hidden_trails : Array
var timer := 0.0
var origin := Vector2.ZERO

func _ready() -> void:
	animation.play("start")
	
	var i = 0
	for each in trails:
		each.visible = false
		Tools.timer_p(0.01 + i,"activate_trail",self,each)
		i += 0.03

func hide_far_trails():
	if abs(global_position.x - origin.x) < 170 and \
	   abs(global_position.y - origin.y) < 170:
		hidden_trails = [trail_3,trail_4]
		
	elif abs(global_position.x - origin.x) < 280 and \
	   abs(global_position.y - origin.y) < 280:
		hidden_trails = [trail_4]
	

func set_lance_origin(pos):
	origin = pos

func activate_trail(_trail : AnimatedSprite):
	if not _trail in hidden_trails: 
		_trail.visible = true
		_trail.playing = true


func _physics_process(delta: float) -> void:
	timer += delta
	
	if state.is_initial() and animation.has_finished_last():
		animation.play("loop")
		long_damage.deactivate()
		state.next()
		
	elif state.currently_is(1) and timer > 2:
		animation.play("end")
		firetip.emitting = false
		fire.emitting = false
		damage.deactivate()
		state.next()
		
	elif state.currently_is(2) and timer > 1:
		queue_free()

func Log(_msg):
	pass
