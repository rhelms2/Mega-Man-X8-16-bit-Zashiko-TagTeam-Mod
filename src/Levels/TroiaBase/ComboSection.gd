extends Node2D

const rankings: Dictionary = {"e": 0, "d": 1, "c": 2, "b": 3, "a": 4, "s": 5}
const intro: AudioStream = preload("res://src/Sounds/OST - TroiaBase 2 - Intro.ogg")
const loop: AudioStream = preload("res://src/Sounds/OST - TroiaBase 2 - Loop.ogg")
const intro_16bit: AudioStream = preload("res://Remix/Songs/Troia Base 2 - Intro.ogg")
const loop_16bit: AudioStream = preload("res://Remix/Songs/Troia Base 2 - Loop.ogg")

export  var debug_logs: bool = false
export  var s_time_limit: float = 40.0
export  var s_ranking: float = 100.0
export  var a_ranking: float = 70.0
export  var b_ranking: float = 50.0
export  var c_ranking: float = 25.0
export  var d_ranking: float = 10.0

onready var player: KinematicBody2D = get_node_or_null("../../X")
onready var visual: Label = get_node_or_null("../../X/combo_label")
onready var visual_ranking: Node2D = $"../../StateCamera/VisualRanking"

var active: bool = false
var enemies_activated: bool = false
var decay: float = 0.0
var timer: float = 0.0
var last_hits: Array
var current_combo: float = 0.0
var current_ranking: String = "e"
var enemies: Array
var combo_decrease_damage: int = 20
var combo_increase_kill: int = 5
var decay_divider: int = 2
var enemies_left_to_kill: int = 0

signal started
signal combo_value_changed
signal rank_changed(rank)
signal combo_fill(fill)
signal finish
signal open_doors
signal disabled


func set_values_for_axl() -> void :
	if CharacterManager.current_player_character == "Axl":
		s_time_limit = 40
		s_ranking = 100.0
		a_ranking = 70.0
		b_ranking = 50.0
		c_ranking = 25.0
		d_ranking = 10.0
		if not CharacterManager.unlocked_boss_weapon():
			s_time_limit = 60
		else:
			s_time_limit = 40
			if self.name == "Section3":
				s_time_limit = 45
		
func set_correct_paths() -> void :
	
	player = get_player_combo_section()
	
	visual = get_player_combo_label_section()
	visual_ranking = get_node_or_null("../../StateCamera/VisualRanking")
	if CharacterManager.current_player_character == "Axl":
		call_deferred("set_values_for_axl")

func get_player_combo_section():
	match CharacterManager.current_player_character:
		"X":
			return get_node_or_null("../../X")
		"Axl":
			return get_node_or_null("../../Axl")
		"Zero":
			return get_node_or_null("../../Zero")
		_:
			return get_node_or_null("../../X")
	
func get_player_combo_label_section():
	match CharacterManager.current_player_character:
		"X":
			return get_node_or_null("../../X/combo_label")
		"Axl":
			return get_node_or_null("../../Axl/combo_label")
		"Zero":
			return get_node_or_null("../../Zero/combo_label")
		_:
			return get_node_or_null("../../X/combo_label")

func _ready() -> void :
	var level_node = get_parent().get_parent()
	if is_instance_valid(level_node):
		if level_node.has_signal("level_initialized"):
			level_node.connect("level_initialized", self, "_on_level_initialized")
	
func _on_level_initialized() -> void :
	set_correct_paths()
	set_physics_process(false)
	for enemy in get_children():
		if enemy is Enemy:
			enemy.listen("combo_hit", self, "damaged_enemy")
			enemy.listen("zero_health", self, "killed_enemy")
			enemies_left_to_kill += 1
			enemies.append(enemy)
	player.listen("received_damage", self, "damaged_player")
	Event.listen("reached_checkpoint", self, "on_checkpoint")
	Event.listen("moved_player_to_checkpoint", self, "on_checkpoint")
	
	var _c = connect("started", visual_ranking, "start")
	_c = connect("rank_changed", visual_ranking, "set_ranking")
	_c = connect("combo_fill", visual_ranking, "on_fill_bar")
	_c = connect("combo_value_changed", visual_ranking, "react")
	_c = connect("finish", visual_ranking, "finish")
	if not Event.is_connected("player_death", visual_ranking, "on_death"):
		_c = Event.connect("player_death", visual_ranking, "on_death")
	_c = Event.connect("player_death", self, "on_death")
	call_deferred("deactivate_all_enemies")

func _physics_process(delta: float) -> void :
	timer += delta
	decay = clamp(decay + delta / decay_divider, 0.0, 10.0)
	reduce_combo_value(delta * decay)
	get_percentage_fill_and_emit_signal()
	visual.text = str(enemies_left_to_kill) + " - " + str(current_combo) + "\n" + str(timer)

func prepare() -> void :
	activate_all_enemies()

func activate() -> void :
	
	set_physics_process(true)
	active = true
	emit_signal("started")
	if Configurations.exists("SongRemix"):
		if Configurations.get("SongRemix"):
			GameManager.music_player.play_song(loop_16bit, intro_16bit)
		else:
			GameManager.music_player.play_song(loop, intro)
	visual_ranking.call_deferred("set_kills_left", enemies_left_to_kill)

func damaged_enemy(inflicter) -> void :
	if active:
		Log("damaged an enemy")
		if is_instance_valid(inflicter):
			var n = correct_name(inflicter.name)
			get_and_add_combo_value(n)
			add_to_hits(n)
			emit_signal("combo_value_changed")
			Log(current_combo)

func killed_enemy() -> void :
	if active:
		Log("Killed an enemy")
		add_combo_value(combo_increase_kill)
		enemies_left_to_kill -= 1
		emit_signal("combo_value_changed")
		visual_ranking.set_kills_left(enemies_left_to_kill)
		Log(current_combo)

func damaged_player() -> void :
	if active:
		Log("Player Damaged")
		reduce_combo_value(combo_decrease_damage)
		reset_decay()
		emit_signal("combo_value_changed")
		Log(current_combo)

func add_combo_value(amount) -> void :
	current_combo += amount
	update_ranking()
	reset_decay()

func reduce_combo_value(amount) -> void :
	current_combo = clamp(current_combo - amount, 0.0, 999999.0)
	update_ranking()

func update_ranking() -> void :
	if get_ranking() != current_ranking:
		current_ranking = get_ranking()
		emit_signal("rank_changed", current_ranking)

func end() -> void :
	active = false
	set_physics_process(false)
	emit_signal("finish")
	if rankings[current_ranking] == 0:
		Event.emit_signal("got_rank_e", name)
	if rankings[current_ranking] == 1:
		Event.emit_signal("got_rank_d", name)
	if rankings[current_ranking] == 2:
		Event.emit_signal("got_rank_c", name)
	if rankings[current_ranking] == 3:
		Event.emit_signal("got_rank_b", name)
	if rankings[current_ranking] == 4:
		Event.emit_signal("got_rank_a", name)
	if rankings[current_ranking] >= 4:
		emit_signal("open_doors")
		if rankings[current_ranking] == 5:
			Event.emit_signal("got_rank_s", name)
	GameManager.music_player.play_stage_song()
	Log("Ranking: " + get_ranking() + " with a total of " + str(current_combo) + " points.")

func on_death():
	active = false
	set_physics_process(false)

func get_percentage_fill_and_emit_signal() -> void :
	var percentage = inverse_lerp(get_rank_min_pts(), get_rank_max_pts(), current_combo) * 100
	if current_ranking != "s":
		emit_fill(percentage)
	else:
		var time_left_percentage = (1 - inverse_lerp(0.0, s_time_limit, timer)) * 100
		emit_fill(min(percentage, time_left_percentage))

func get_timer() -> float:
	if timer < s_time_limit:
		return s_time_limit - timer
	else:
		visual_ranking.set_timer_color(Color.lightcoral)
		return abs(timer - s_time_limit)

func on_checkpoint(checkpoint: CheckpointSettings) -> void :
	if checkpoint.id >= get_own_id():
		destroy_all_enemies()
		emit_signal("disabled")

func destroy_all_enemies() -> void :
	Log("destroying all enemies")
	for enemy in enemies:
		if is_instance_valid(enemy):
			enemy.destroy()

func deactivate_all_enemies() -> void :
	Log("deactivating all enemies")
	for enemy in enemies:
		if is_instance_valid(enemy):
			enemy.visible = false
			enemy.active = false
			enemy.set_physics_process(false)

func activate_all_enemies() -> void :
	Log("activating all enemies")
	for enemy in enemies:
		if is_instance_valid(enemy):
			enemy.visible = true
			enemy.active = true
			enemy.set_physics_process(true)
	enemies_activated = true

func get_own_id() -> int:
	return name.substr(7).to_int()

func emit_fill(value) -> void :
	emit_signal("combo_fill", value)
	visual_ranking.set_timer(get_timer())

func correct_name(inflicter_name: String) -> String:
	var correct_name: = inflicter_name
	while correct_name[correct_name.length() - 1].is_valid_float():
		correct_name.erase(correct_name.length() - 1, 1)
	return correct_name

func get_rank_min_pts() -> float:
	if get(current_ranking + "_ranking") != null:
		return get(current_ranking + "_ranking")
	return 0.0

func get_rank_max_pts() -> float:
	if current_ranking == "s":
		return s_ranking * 1.25
	elif current_ranking == "a":
		return s_ranking
	elif current_ranking == "b":
		return a_ranking
	elif current_ranking == "c":
		return b_ranking
	elif current_ranking == "d":
		return c_ranking
	return d_ranking

func reset_decay() -> void :
	decay = 0

func get_and_add_combo_value(inflicter_name) -> void :
	add_combo_value(get_combo_value(correct_name(inflicter_name)))

func get_combo_value(inflicter_name) -> float:
	var index = last_hits.find(inflicter_name, 0)
	if index != - 1:
		return index + 1
	return 5.0

func add_to_hits(inflicter_name) -> void :
	last_hits.push_front(inflicter_name)
	if last_hits.size() > 5:
		last_hits.pop_back()

func get_ranking() -> String:
	if current_combo >= s_ranking and enemies_left_to_kill <= 0 and timer < s_time_limit:
		return "s"
	elif current_combo >= a_ranking:
		return "a"
	elif current_combo >= b_ranking:
		return "b"
	elif current_combo >= c_ranking:
		return "c"
	elif current_combo >= d_ranking:
		return "d"
	return "e"

func _on_finish_line_body_entered(_body: Node) -> void :
	if active:
		end()

func start() -> void :
	if not enemies_activated:
		activate_all_enemies()
	activate()

func Log(message) -> void :
	if debug_logs:
		print(name + ": " + str(message))
