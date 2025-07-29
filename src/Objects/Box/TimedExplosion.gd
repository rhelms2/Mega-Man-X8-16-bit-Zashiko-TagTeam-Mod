extends Node

export  var active: = false
export  var blast_area: PackedScene
signal beep
signal exploded
var exploded: = false
var still_starting: = true

var timer: = 0.0
var flash_interval: = 0.35

func _ready() -> void :
	set_physics_process(false)
	Tools.timer(0.1, "finish_starting", self)

func activate() -> void :
	if still_starting:
		return
	if not active and not exploded:
		active = true
		beep()
		start_countdown()

func deactivate() -> void :
	active = false
	exploded = true

func start_countdown() -> void :
	set_physics_process(true)
	Tools.timer(2.0, "explode", self)

func _physics_process(delta: float) -> void :
	timer += delta
	if timer > flash_interval:
		beep()
		timer = 0.0
		flash_interval = clamp(flash_interval * 0.85, 0.064, 1)

func finish_starting() -> void :
	still_starting = false

func beep() -> void :
	if active:
		emit_signal("beep")

func explode() -> void :
	if not exploded:
		emit_signal("exploded")
		create_blast_area()
		exploded = true

func _on_EnemyShield_shield_hit(_projectile) -> void :
	activate()

func create_blast_area(instance_position: = get_parent().global_position):
	var instance = blast_area.instance()
	get_tree().current_scene.add_child(instance, true)
	instance.set_global_position(instance_position)


func _on_player_detector_body_entered(_body: Node) -> void :
	activate()


func _on_Health_zero_health() -> void :
	create_blast_area()
	exploded = true
	deactivate()
	pass
