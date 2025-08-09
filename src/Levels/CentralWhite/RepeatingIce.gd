extends Node2D

onready var ice_pieces_parent := $Pool
onready var piece_pool : Array
onready var position_pool : Array
var active := false
var sunk_index := 0
var timer := 0.0
var biker_spawn_timer := 0.0
var endtimer := 0.0
var tween : SceneTreeTween
const piece_size = 64
const original_sink_interval = 0.16
var sink_interval = 0.16
var spawned_enemies := []
onready var boss_holder: Sprite = $Boss
onready var explosion_time = get_death_time()
onready var walls: TileMap = $Boss/UnclimbableWalls

func _ready() -> void:
	generate_ice_pieces()
	call_deferred("populate_position_pool_and_connect")

func generate_ice_pieces() -> void:
	var i = piece_size
	var ice_piece = ice_pieces_parent.get_children()[0]
	while i < piece_size * 40:
		var new_piece = ice_piece.duplicate()
		ice_pieces_parent.add_child(new_piece)
		new_piece.position.x = i
		i += piece_size

func populate_position_pool_and_connect() -> void:
	piece_pool = ice_pieces_parent.get_children()
	position_pool = ice_pieces_parent.get_children()
	for piece in piece_pool:
		var _s = piece.connect("sunk",self,"on_piece_sunk")
		_s = piece.connect("spawned",self,"add_spawn_to_list")

func start() -> void:
	active = true

func _physics_process(delta: float) -> void:
	if active:
		increment_timers_and_set_camera_limits(delta)
		move_boss_according_to_player_speed(delta)
		set_sink_speed_according_to_player_speed()
		sink()

func increment_timers_and_set_camera_limits(delta: float) -> void:
	increment_endtimer(delta)
	timer += delta
	biker_spawn_timer += delta
	GameManager.camera.custom_limits_right = walls.global_position.x

func increment_endtimer(delta: float) -> void:
	if is_ending():
		endtimer += delta
	if endtimer > get_death_time():
		active = false
		set_physics_process(false)

func move_boss_according_to_player_speed(delta) -> void:
	if is_player_on_bike():
		move_boss(delta)
	else:
		move_boss(delta/2.3)

func move_boss(delta) -> void:
	boss_holder.global_position.x += 6 * piece_size * delta

func set_sink_speed_according_to_player_speed() -> void:
	if is_ending():
		sink_interval = 100
		return
	if not is_player_on_bike() and sink_interval == original_sink_interval:
		if tween:
			tween.kill()
		tween = create_tween()
		tween.tween_property(self,"sink_interval",original_sink_interval * 2.3,2)# warning-ignore:return_value_discarded
	elif is_player_on_bike() and sink_interval == original_sink_interval * 2.3:
		if tween:
			tween.kill()
		tween = create_tween()
		tween.tween_property(self,"sink_interval",original_sink_interval,2)# warning-ignore:return_value_discarded

func sink() -> void:
	if timer > sink_interval:
			piece_pool[sunk_index].sink()
			timer = 0
			sunk_index += 1
	if sunk_index == piece_pool.size():
		sunk_index = 0

func on_piece_sunk(piece) -> void:
	position_pool.erase(piece)
	piece.global_position = get_next_available_position()
	position_pool.append(piece)
	
	if biker_spawn_timer > 5:
		piece.spawn()
		biker_spawn_timer = 0

func get_next_available_position() -> Vector2:
	var x = get_last_piece().global_position.x + piece_size
	return Vector2(x,global_position.y)
	
func get_last_piece() -> Node2D:
	return position_pool[position_pool.size()-1]

func _on_MantaRay_zero_health() -> void:
	print_debug("received zero health signal")
	endtimer = 0.01
	biker_spawn_timer -= 10000
	for enemy in spawned_enemies:
		if is_instance_valid(enemy) and enemy.current_health > 0:
			enemy.current_health = 0
	GameManager.music_player.start_slow_fade_out()

func add_spawn_to_list(object) -> void:
	print_debug("Adding spawn to list: " + object.name)
	spawned_enemies.append(object)

func is_player_on_bike() -> bool:
	if GameManager.is_player_in_scene():
		if GameManager.player.ride:
			return GameManager.player.ride.current_health > 0
			#TODO: player.ride retornando Node
	return false

func is_ending() -> bool:
	return endtimer >= 0.01

func get_death_time() -> float:
	return boss_holder.get_child(0).get_death_time()
