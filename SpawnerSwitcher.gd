tool
class_name SpawnerSwitcher extends Node

var objects_node : Node2D
var spawners : Array

export var spawner_holders : Array

export var start := false
export var switch := false
export var delete := false

func _ready() -> void:
	print("SpawnerSwitcher added to scene")

func _process(_delta: float) -> void:
	if start:
		get_all_spawners()
		start = false
	
	if switch:
		switch_all_spawners()
		switch = false
	
	if delete:
		delete_all_spawners()
		delete = false

func get_all_spawners():
	spawners.clear()
# warning-ignore:unassigned_variable
	var objects : Array
	for nodepath in spawner_holders:
		objects.append_array(get_node(nodepath).get_children())
	
	for node in objects:
		if node is Spawner and not "Boss" in node.name and not "Vile" in node.name:
			spawners.append(node)
	print ("Got spawners. Total:" + str(spawners.size()))

func switch_all_spawners():
	var i = 0
	for spawner in spawners:
		create_object_in_scene(spawner)
		i += 1
	print ("Finished creating Objects: " + str(i))

func delete_all_spawners():
	var i = 0
	for spawner in spawners:
		spawner.queue_free()
		i += 1
	print ("Finished deleting spawners: " + str(i))

func create_object_in_scene(spawner : Spawner):
	var enemy : Enemy = spawner.object_to_spawn.instance()
	if spawner.set_direction_to_right:
		enemy.spawn_direction = 1
	else:
		enemy.spawn_direction = -1
	for key in spawner.custom_vars.keys():
		enemy.set(key,spawner.custom_vars[key])
	spawner.get_parent().add_child(enemy,true)
	enemy.position = spawner.position
	enemy.set_owner(get_tree().edited_scene_root)
