extends Node2D
class_name XDeathParticle

onready var particle1 = $particles2D
onready var particle2 = $particles2D2
onready var particle3 = $particles2D3
onready var particle4 = $particles2D4
onready var particle5 = $particles2D5
onready var particle6 = $particles2D6
onready var particle7 = $particles2D7
onready var particle8 = $particles2D8

onready var first_round = [particle1, particle2, particle3, particle4, particle5, particle6, particle7, particle8]

onready var round2_1 = $"half a second later"/particles2D
onready var round2_2 = $"half a second later"/particles2D2
onready var round2_3 = $"half a second later"/particles2D3
onready var round2_4 = $"half a second later"/particles2D4
onready var round2_5 = $"half a second later"/particles2D5
onready var round2_6 = $"half a second later"/particles2D6
onready var round2_7 = $"half a second later"/particles2D7
onready var round2_8 = $"half a second later"/particles2D8

onready var second_round = [round2_1, round2_2, round2_3, round2_4, round2_5, round2_6, round2_7, round2_8]

var second_round_delay := 0.0

func emit():
	for particle in first_round:
		particle.emitting = true
		second_round_delay = 0.45

func _process(delta: float) -> void:
	if second_round_delay > 0:
		second_round_delay -= delta
	elif second_round_delay < 0:
		for particle in second_round:
			particle.emitting = true
			second_round_delay = 0.0
	
