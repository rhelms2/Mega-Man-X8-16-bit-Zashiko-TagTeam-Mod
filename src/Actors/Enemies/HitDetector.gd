extends Node2D
class_name HitDetector

export var debug_logs := false
onready var hittable_area := get_node("hittable_area")
onready var hit_sound := get_node("hitSound")
var character
var colliding_projectiles = []

export var active := true

func _ready() -> void:
	var parent = get_parent()
	if parent is Actor or parent is GenericProjectile:
		character = parent
	elif call_deferred("has_creator"):
		character = parent.creator
	else:
		character = parent.get_parent()
# warning-ignore:return_value_discarded
	if character is Actor:
		character.listen("zero_health",self,"deactivate")
	connect_player_death()
	connect_area_events()

func connect_player_death() -> void:
	Event.listen("player_death",self,"deactivate")

func _physics_process(_delta: float) -> void:
	if active:
		if colliding_projectiles.size() > 0:
			if should_react():
				react(character)

func should_react() -> bool: #should react
	#lógica de definição de possibilidade de hit/deflect
	#ex.: está visível na tela? se sim, hit
	return true

func react(_body: Node) -> void:
	for projectile in colliding_projectiles:
		pass 
	#hit, deflect ou similares
	pass

func _on_area2D_body_entered(_body: Node) -> void:
	if active:
		Log("Detected collision:" + _body.name)
		if _body.is_in_group("Player Projectile"):
			if not _body in colliding_projectiles:
				colliding_projectiles.append(_body)
				Log("Collider is a projectile.")

func _on_area2D_body_exited(_body: Node) -> void:
	if _body in colliding_projectiles:
		colliding_projectiles.erase(_body)

func activate() -> void:
	Log("Activating")
	active = true

func deactivate() -> void:
	Log("Dectivating")
	active = false

func connect_area_events():
	hittable_area.connect("body_entered",self,"_on_area2D_body_entered")# warning-ignore:return_value_discarded
	hittable_area.connect("body_exited",self,"_on_area2D_body_exited")# warning-ignore:return_value_discarded

func has_creator() -> bool:
	if "creator" in get_parent():
		return get_parent().creator != null
	return false
	
func Log(message) -> void:
	if debug_logs:
		print_debug(character.name + "." + name + ": " +str(message))
