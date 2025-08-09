extends NewAbility

export var crosshair : PackedScene
export var laser_beam : PackedScene
export var boss : NodePath
export var interval := 4.0

func _Setup() -> void:
	create_target()
	Tools.timer(interval, "loop", self)

func loop() -> void:
	if executing:
		create_target()
		Tools.timer(interval, "loop", self)

func create_target() -> void:
	var t = instantiate(crosshair,GameManager.get_player_position())
	var _s = t.connect("fire",self,"create_beam")
	_s = get_node(boss).connect("zero_health",t,"queue_free")
	
func create_beam(beam_pos) -> void:
	var t = instantiate(laser_beam,beam_pos)
	t.set_floor_y()

func instantiate(scene : PackedScene, pos := global_position) -> Node2D:
	var instance = scene.instance()
	get_tree().current_scene.add_child(instance,true)
	instance.set_global_position(pos) 
	return instance
