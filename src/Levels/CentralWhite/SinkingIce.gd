extends TileMap

export var biker : PackedScene
var falling := false
var timer := 0.0
var tween
onready var splash_2: AnimatedSprite = $splash2
onready var water: TileMap = $water
onready var box: = $rigidBody2D
signal sunk(object)
signal spawned(object)

func _physics_process(delta: float) -> void:
	if timer >= 0.01:
		timer += delta
	if timer > 2:
		done()
		timer = 0

func sink() -> void:
	splash_2.frame = 0
	if tween:
		tween.kill()
	tween = create_tween()
	tween.tween_property(self,"global_position:y",global_position.y+300.0,2).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CUBIC)
	tween.tween_callback(self,"done")

func blink() -> void:
	timer = 0.01

func spawn() -> void:
	var instance = biker.instance()
	var spawn_pos = Vector2(global_position.x-512,global_position.y-64)
	get_tree().current_scene.add_child(instance,true)
	instance.set_global_position(global_position) 
	instance.set_direction(1)
	emit_signal("spawned",instance)

func return_to_original_position():
	box.position.y = 0
	emit_signal("sunk",self)
	

func done() -> void:
	call_deferred("return_to_original_position")

func stop_any_tweens() -> void:
	if tween:
		tween.kill()
	box.position.y = 0
