extends Node2D

export(PackedScene) var shards
export var active := false
export var debug_logs := false
export var interval_between_shots := 2.5
var created_shards = []
var timer := 0.0
onready var actual_snow = $actual_snow
onready var character = get_parent().get_parent()
export var shot_creation_height := -180
var shot_position_y := 0.0
const sequence := [0,1,-1,.5,-.5,0,.25,-.25,1,-1,-.75,.75]
var last_pos := 0

func get_next_pos() -> float:
	if last_pos + 1 > sequence.size() - 1:
		last_pos = -1
	var pos = last_pos
	last_pos += 1
	return sequence[pos]
	

func _ready() -> void:
	character.listen("zero_health",self,"deactivate")
	
func deactivate():
	Log("Deactivated. disabling IceShards...")
	for shard in created_shards:
		if is_instance_valid(shard):
			shard.emit_hit_particle()
			shard.disable_visual_and_mechanics()
		Log(" ...Shard Disabled")
	Log(" Stopping snow and returning it to it's original parent")
	actual_snow.emitting = false
	#get_tree().current_scene.remove_child(actual_snow)
	#add_child(actual_snow)
	active = false

func activate():
	if not active:
		active = true
		actual_snow.emitting = true
		adjust_snow_position()
		Log("Activated")
		Tools.timer(interval_between_shots,"create_ice",self)

func adjust_snow_position():
	remove_child(actual_snow)
	get_tree().current_scene.add_child(actual_snow)
	actual_snow.global_position.x = GameManager.camera.global_position.x
	actual_snow.global_position.y = GameManager.camera.global_position.y - 190
	shot_position_y = character.global_position.y + shot_creation_height
func create_ice():
	if active:
		fire(shards, GameManager.camera.global_position, 1, Vector2 (0,20))
		Log("Created new IceShard")
		Tools.timer(interval_between_shots,"create_ice",self)
	
func fire(projectile, shot_position, _dir := 0, velocity_override := Vector2 (0,0)):
	var shot = projectile.instance()
	var direction
	if _dir != 0:
		direction = _dir
	else:
		direction = character.get_facing_direction()
	get_tree().current_scene.add_child(shot)
	var random_pos_x = GameManager.camera.global_position.x + (130 * get_next_pos())
	#var random_pos_x = GameManager.camera.global_position.x + rand_range(-150, 150)
	
	shot.global_position = Vector2(random_pos_x, shot_position_y)
	#shot.projectile_setup(direction, Vector2 (shot_position.x, shot_position.y))
	if velocity_override.y != 0:
		shot.set_vertical_speed(velocity_override.y)
	
	shot.connect("zero_health", self, "remove_shard_from_list",[shot])
	created_shards.append(shot)
	
	#print("Shot created at " + str(shot.global_position.y))

func remove_shard_from_list(shard): #on_projectile_end
	if shard in created_shards:
		created_shards.erase(shard)
	Log("Shard ended, removed from list")

func Log(message):
	if debug_logs:
		print_debug(get_parent().name + "." + name + ": " + message)
