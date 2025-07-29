extends Node2D

var compiled: bool = false
var show_debug_messages: bool = false
var particles_cached: int = 0
var folder: String = "res://src/Effects/Materials"

signal particle_cache_finished


func _ready() -> void :
	call_deferred("cache_materials")

func cache_materials(debug: bool = false) -> void :
	show_debug_messages = debug
	for file in get_files(folder):
		add_material_to_cache(file)
	finish_caching()

func add_material_to_cache(file) -> void :
	var mat = load(folder + "/" + file)
	var particle: = Particles2D.new()
	Log("Adding to cache: " + file)
	if mat is ParticlesMaterial:
		particle.set_process_material(mat)
	else:
		particle.set_material(mat)
	particle.set_one_shot(true)
	particle.set_amount(1)
	particle.set_lifetime(0.25)
	particle.set_emitting(true)
	if GameManager.camera:
		GameManager.camera.add_child(particle)
		particle.global_position = GameManager.camera.get_camera_screen_center()
	else:
		get_tree().current_scene.add_child(particle)
	particles_cached += 1

func finish_caching() -> void :
	
	compiled = true
	emit_signal("particle_cache_finished")
	

func get_files(path) -> Array:
	var files = []
	var dir = Directory.new()
	dir.open(path)
	dir.list_dir_begin(true)
	var file = dir.get_next()
	while file != "":
		files += [file]
		file = dir.get_next()
	return files

func Log(message) -> void :
	if show_debug_messages:
		print_debug("Cache: " + str(message))
