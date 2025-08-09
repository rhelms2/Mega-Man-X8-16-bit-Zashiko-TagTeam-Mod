extends Node2D #IA?

var player : Character
onready var character := get_parent()
onready var rush_down: Node2D = $"../RushDown"
onready var shot: Node2D = $"../Shot"
onready var turn: Node2D = $"../Turn"
onready var idle: Node2D = $"../Idle"

var timer := 0.0
const cooldown := 1
func _ready() -> void:
	set_physics_process(false)
	call_deferred("setup")
	call_deferred("set_physics_process",true)

func setup() -> void:
	player = GameManager.player

func _physics_process(delta: float) -> void:
	timer += delta
	
	if is_player_nearby():
		if is_player_in_front():
			if is_player_facing_same_direction():
				execute(rush_down)
			else:
				execute(turn)
		else:
			if is_player_facing_same_direction():
				execute(shot)
			else:
				execute(turn)
	
	else:
		if is_player_facing_same_direction():
			if is_player_in_front():
				execute(rush_down)
			else:
				execute(turn)
	
	#if is_player_moving():
	#	if is_player_facing_same_direction():
	#		if is_player_in_front():
	#			execute(rush_down)
	#		else:
	#			execute(shot)
	#	else:
	#		execute(turn)
	
	#else:
	#	if heading_towards_player():
	#		execute(rush_down)
	#	else:
	#		execute(turn)

func execute(ability) -> void:
	Log("Executing ability " + ability.name)
	if timer > cooldown:
		if not character.is_executing(ability.name) and ability.Should_Execute() and ability._StartCondition():
			ability.ExecuteOnce()
			timer = 0

func is_player_on_bike() -> bool:
	if not player or not player.ride:
		return false
	return abs(player.ride.get_actual_speed()) > 200 

func is_player_in_front() -> bool:
	if player.global_position.x > character.global_position.x:
		return character.get_facing_direction() == 1
	else:
		return character.get_facing_direction() == -1

func is_player_nearby() -> bool:
	return GameManager.is_nearby(character, player, Vector2(140,100))

func is_player_moving() -> bool:
	return player.get_horizontal_speed() == 0

func is_player_facing_same_direction() -> bool:
	if player.get_facing_direction() > 0:
		if character.get_facing_direction() > 0:
			return true
	elif player.get_facing_direction() < 0:
		if character.get_facing_direction() < 0:
			return true
	return false

func heading_towards_player() -> bool:
	return get_player_direction_relative() == character.get_facing_direction()

func get_player_direction_relative() -> int:
	if GameManager.get_player_position().x > character.global_position.x:
		return(1)
	else:
		return(-1)

func Log(_message) -> void:
	#print("BikeReploidIA: " + message)
	pass
