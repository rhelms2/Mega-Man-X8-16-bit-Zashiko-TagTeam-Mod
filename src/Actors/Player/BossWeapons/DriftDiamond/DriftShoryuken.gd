extends SimplePlayerProjectile


const damage_frequency: = 0.06
var next_damage_time: = 0.0
var target_list = []
var character: Character
signal finish
signal disabled
onready var tween: = TweenController.new(self, false)
onready var remains_particles: Particles2D = $remains_particles
onready var particles: Particles2D = $particles2D
onready var dash_particle: Sprite = $dash_particle
onready var collision: CollisionShape2D = $collisionShape2D

func _ready() -> void :
	tween.connect_reset("finish")
	Event.listen("damage", self, "finish")
	Event.listen("player_death", self, "finish")
	if GameManager.is_player_in_scene():
		character = GameManager.player
		character.listen("cutscene_deactivate", self, "finish")

func connect_disable_unneeded_object() -> void :
	pass

func _Setup() -> void :
	call_deferred("position_things")
	Tools.timer(0.1, "emit", dash_particle)
	next_damage_time = 0

func position_things() -> void :
	Log("Initializing Shoryuken, facing dir: " + str(get_facing_direction()))
	dash_particle.position.x = dash_particle.position.x * get_facing_direction()
	collision.position.x = collision.position.x * get_facing_direction()
	

func _Update(_delta: float) -> void :
	global_position = GameManager.get_player_position()

func hit(_body) -> void :
	if active:
		Log("Hit " + _body.name)
		var target_hp = _DamageTarget(_body)
		_OnHit(target_hp)
	
func finish() -> void :
	disable_damage()
	particles.emitting = false
	remains_particles.emitting = true
	call_deferred("disable_visuals")
	ending = true
	emit_signal("disabled")
	Tools.timer(2.5, "destroy", self)

func _OnDeflect() -> void :
	pass

func deflect(_v) -> void :
	pass
	
func _OnHit(_target_remaining_HP) -> void :
	pass
