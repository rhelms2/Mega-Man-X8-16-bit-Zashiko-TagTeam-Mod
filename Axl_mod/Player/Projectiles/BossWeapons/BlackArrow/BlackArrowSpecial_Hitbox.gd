extends Actor

const bypass_shield: bool = true

export  var timer: = 0.025
export  var damage: = 1.0
export  var damage_to_bosses: = 1.0
export  var damage_to_weakness: = 1.0
export  var break_guards: = false
export  var break_guard_damage = 0

onready var collision_shape = $collisionShape2D

var upgraded: bool = false
var hit_time: = 0.0


func _ready() -> void :
	pass

func _physics_process(delta: float) -> void :
	timer -= delta
	if timer <= 0:
		queue_free()

func activate() -> void :
	active = true

func deactivate() -> void :
	active = false

func deflect(_var) -> void :
	pass

func _OnHit(_var) -> void :
	pass

func hit(_body) -> void :
	if active:
		_body.damage(damage, self)
		deactivate()

func leave(_target) -> void :
	pass
