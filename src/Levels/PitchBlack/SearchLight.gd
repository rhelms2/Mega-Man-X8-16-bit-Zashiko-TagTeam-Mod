extends Node2D

export  var _wall_enemies: Array
export  var debug: bool = false
export  var path_speed: float = 50.0
export  var inverse_speed: bool = false

onready var sublight: Light2D = $Spotlight1 / pathFollow2D / spotLight / sublight
onready var path: PathFollow2D = $Spotlight1 / pathFollow2D
onready var spotlight: Light2D = $Spotlight1 / pathFollow2D / spotLight

var timer: float = 0.0
var activated: bool = true
var dissipated: bool = false
var restoring: bool = false
var current_tween
var wall_enemies: Array
var bodies_in_spotlight: Array = []

signal alarm_activated


func _ready() -> void :
	Event.listen("alarm", self, "deactivate")
	for nodepath in _wall_enemies:
		wall_enemies.append(get_node(nodepath))

func _physics_process(delta: float) -> void :
	timer += delta
	if activated:
		move_and_flicker(delta)
		for body in bodies_in_spotlight:
			if body.has_method("is_invulnerable"):
				if not body.is_invulnerable():
					trigger_alarm()
					bodies_in_spotlight.erase(body)

func activate_doors() -> void :
	for wallenemy in wall_enemies:
		if is_instance_valid(wallenemy) and wallenemy.has_health():
			wallenemy._on_SearchLight_alarm_activated()

func move_and_flicker(delta: float) -> void :
	var speed = path_speed
	if inverse_speed:
		speed = path_speed * - 1
	
	path.offset += delta * speed
	spotlight.energy = lerp(0.85, 1, sin(timer * 120))
	sublight.energy = 0.5
	sublight.scale.x = lerp(2, 2.1, sin(timer * 120))

func activate() -> void :
	activated = true
	restoring = false
	timer = 0

func deactivate() -> void :
	activated = false
	timer = 0
	sublight.energy = 0
	spotlight.energy = 0
	Tools.timer(16, "restore_shape", self)
	Tools.timer(17, "activate", self)

func trigger_alarm() -> void :
	emit_signal("alarm_activated")
	Event.emit_signal("alarm")
	expand_shape()
	activate_doors()

func _on_playerDetector_body_entered(_body: Node) -> void :
	if activated:
		bodies_in_spotlight.append(_body)

func _on_playerDetector_body_exited(_body: Node) -> void :
	bodies_in_spotlight.erase(_body)

func expand_shape() -> void :
	spotlight.energy = 1
	
	var tween = get_tree().create_tween()
	current_tween = tween
	tween.tween_property(spotlight, "scale", Vector2(12, 12), 0.25).set_trans(Tween.TRANS_QUAD)
	tween.parallel().tween_property(spotlight, "energy", 0.0, 0.5)
	Tools.timer(16, "restore_shape", self)
	Tools.timer(17, "activate", self)

func restore_shape() -> void :
	restoring = true
	
	var tween = get_tree().create_tween()
	current_tween = tween
	spotlight.scale = Vector2(4, 4)
	tween.tween_property(spotlight, "energy", 0.5, 0.95).set_trans(Tween.TRANS_QUAD)
	tween.parallel().tween_property(spotlight, "scale", Vector2(1, 1), 0.95).set_trans(Tween.TRANS_QUAD)

func debug_print(message) -> void :
	if debug:
		print(name + ": " + str(message))
