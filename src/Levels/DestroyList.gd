extends Node

export var list : Array

onready var objects_to_destroy : Array

func _ready() -> void:
	for nodepath in list:
		objects_to_destroy.append(get_node(nodepath))
	

func destroy() -> void:
	for object in objects_to_destroy:
		if is_instance_valid(object):
			object.call_deferred("queue_free")
	
	call_deferred("queue_free")
