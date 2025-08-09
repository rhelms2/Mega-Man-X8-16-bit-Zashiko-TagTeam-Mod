extends Node
var rng
var seed_rng
var state_rng

signal updated_rng
signal decided_boss_order(boss_name, attack_order)

func initialize() -> void:
	print ("RNGSystem: Initializing...")
	rng = RandomNumberGenerator.new()
	set_seed(0000000000)

func set_seed(new_seed : int):
	seed_rng = new_seed
	rng.seed = seed_rng
	emit_signal("updated_rng")

func reset_seed():
	print ("RNGSystem: Resetting seed to " + str(seed_rng))
	set_seed(seed_rng)

func increase(amount : int) -> void:
	print ("RNGSystem: Increasing by " + str(amount))
	set_seed(seed_rng + amount)

func stage_vile_defeated() -> void: #used for minibosses too
	increase(17)

func all_gateway_bosses_defeated() -> void:
	increase(1000)

func player_died() -> void:
	increase(1)

func passed_through_stage_select() -> void:
	increase(20)

func decided_attack_order(boss_name : String, attack_order : Array):
	var display_attack_order := ""
	for number in attack_order:
		display_attack_order += str(number)
	emit_signal("decided_boss_order",boss_name,display_attack_order)
	pass

func boss_defeated(boss_name : String) -> void:
	print ("RNGSystem: Boss Defeated " + boss_name)
	var increase_amount := 0
	match boss_name:
		"Sunflower":
			increase_amount = 100
		"Antonion":
			increase_amount = 200
		"Mantis":
			increase_amount = 300
		"Manowar":
			increase_amount = 400
		"Panda":
			increase_amount = 500
		"Trilobyte":
			increase_amount = 600
		"Yeti":
			increase_amount = 700
		"Rooster":
			increase_amount = 800
	
	increase(increase_amount)
