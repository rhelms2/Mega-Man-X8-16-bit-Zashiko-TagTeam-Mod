extends Enemy

onready var enemy_death: Node2D = $EnemyDeath
var ignore_bike_melee := false
onready var intro: Node2D = $Intro
signal intro_concluded  
signal spawned(object)

func _ready() -> void:
	prepare_for_intro()
	
func get_death_time() -> float:
	return enemy_death.explosion_duration

func prepare_for_intro() -> void:
	intro.prepare_for_intro()

func execute_intro() -> void:
	intro.execute_intro()

func emit_signal_spawn(object) -> void:
	emit_signal("spawned",object)
	
