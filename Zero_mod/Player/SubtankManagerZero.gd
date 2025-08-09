extends Node

var subtanks = []
onready var player: Character = get_parent()
signal max_subtank_used

func _ready() -> void :
	Event.listen("add_to_subtank", self, "add_health")
	Event.listen("use_any_subtank", self, "on_use_any_subtank")
	Event.listen("use_subtank", self, "on_use_subtank")
	subtanks = get_children()
	listen_to_max_use()

func add_health(amount, has_played_sound: = false) -> void :
	var remaining_charge = amount
	var sound = has_played_sound
	for subtank in subtanks:
		if remaining_charge == 0:
			break
		elif subtank.active:
			remaining_charge = subtank.add_health(remaining_charge, sound)
			sound = false

func on_use_subtank(requested_id) -> void :
		for subtank in subtanks:
			if subtank.get_id() == requested_id:
				subtank.use()
				return

func on_use_any_subtank() -> void :
		for subtank in subtanks:
			if subtank.active and subtank.current_health > 0:
				get_tree().call_deferred("set_pause", true)
				subtank.use()
				yield(subtank, "finished_healing")
				yield(get_tree().create_timer(0.1), "timeout")
				get_tree().call_deferred("set_pause", false)
				break

func listen_to_max_use() -> void :
	for subtank in subtanks:
		subtank.connect("used_at_max_capacity", self, "on_subtank_max_use")

func on_subtank_max_use() -> void :
	emit_signal("max_subtank_used")
