extends Node2D

const even: String = "1225977663272912"
const odd: String = "1932729259776691"
const zero_all: String = "46738766824328"

const A1 = "HermesHead"
const A2 = "HermesBody"
const A3 = "HermesArms"
const A4 = "HermesFeet"
const A5 = "IcarusHead"
const A6 = "IcarusBody"
const A7 = "IcarusArms"
const A8 = "IcarusFeet"
const A9 = "UltimateArmor"

const Z1 = "K-Knuckle"
const Z2 = "T-Breaker"
const Z3 = ""
const Z4 = ""
const Z5 = ""
const Z6 = ""
const Z7 = ""
const Z8 = ""

const L1 = "LifeUpYeti"
const L2 = "LifeUpPanda"
const L3 = "LifeUpRooster"
const L4 = "LifeUpMantis"
const L5 = "LifeUpTrilobyte"
const L6 = "LifeUpManowar"
const L7 = "LifeUpAntonion"
const L8 = "LifeUpSunflower"

const S1 = "SubtankYeti"
const S2 = "SubtankRooster"
const S3 = "SubtankTrilobyte"
const S4 = "SubtankSunflower"

const X1 = "Intro"
const X2 = "BlackZero"
const X3 = "WhiteAxl"

const X4 = "Red"
const X5 = "Jacob"
const X6 = "Gateway"
const X7 = "Placeholder"

const B1 = "TroiaBase"
const B2 = "Primrose"
const B3 = "PitchBlack"
const B4 = "Dinasty"
const B5 = "BoosterForest"
const B6 = "MetalValley"
const B7 = "CentralWhite"
const B8 = "Inferno"

const bosses: Array = [B1, B2, B3, B4, B5, B6, B7, B8]

const key_locations: Array = [
	[A1, A8, B7, L6, X1], 
	[A2, B1, B8, L7, X2], 
	[A3, B2, L1, L8, X3], 
	[A4, B3, L2, S1, Z1], 
	[A5, B4, L3, S2, Z2], 
	[A6, B5, L4, S3, Z3], 
	[A7, B6, L5, S4, Z4]
]

const keys: Dictionary = {
	"00": [], 
	"03": [1], 
	"05": [2], 
	"13": [3], 
	"17": [4], 
	"31": [5], 
	"08": [1, 2], 
	"16": [1, 3], 
	"20": [1, 4], 
	"34": [1, 5], 
	"18": [2, 3], 
	"22": [2, 4], 
	"36": [2, 5], 
	"30": [3, 4], 
	"44": [3, 5], 
	"48": [4, 5], 
	"21": [1, 2, 3], 
	"25": [1, 2, 4], 
	"39": [1, 2, 5], 
	"33": [1, 3, 4], 
	"47": [1, 3, 5], 
	"51": [1, 4, 5], 
	"35": [2, 3, 4], 
	"49": [2, 3, 5], 
	"53": [2, 4, 5], 
	"61": [3, 4, 5], 
	"38": [1, 2, 3, 4], 
	"52": [1, 2, 3, 5], 
	"56": [1, 2, 4, 5], 
	"64": [1, 3, 4, 5], 
	"66": [2, 3, 4, 5], 
	"69": [1, 2, 3, 4, 5]
}

export  var entered_password: = "1111111111111111"

onready var rng: = RandomNumberGenerator.new()

var password_being_tested: = "0000000000000000"
var show_debug: bool = true
var no_of_tries: int = 0
var hey: int = 0
var somatorio: Array = []

func _ready() -> void :
	if is_valid_password():
		var decoded = remove_code(even)
		var state = get_game_state_from_password(decoded)
		print("load game: ", state)
	else:
		print("Password invalid")

func is_valid_password() -> bool:
	var even_removed = remove_code(even)
	var odd_removed = remove_code(odd)
	debug("Entered: " + entered_password)
	debug("Even: " + even_removed)
	debug("Odd: " + odd_removed)
	password_being_tested = even_removed
	if is_any_value_invalid(even_removed):
		return false
	if not is_no_of_defeated_bosses_valid("even"):
		return false
	password_being_tested = odd_removed
	if is_any_value_invalid(odd_removed):
		return false
	if not is_no_of_defeated_bosses_valid("odd"):
		return false
	return true

func get_game_state_from_password(decoded_password: String) -> Array:
	var unlocked_collectibles: = []

	for i in range(key_locations.size()):
		var key_group = key_locations[i]
		var duo = decoded_password.substr(i * 2, 2)
		var mapping = keys.get(duo, [])
		
		for index in mapping:
			if index <= key_group.size():
				var item = key_group[index - 1]
				match item:
					"Intro":
						GameManager.add_collectible_to_savedata("finished_intro")

					"BoosterForest":
						GameManager.add_collectible_to_savedata("panda_weapon")
					"CentralWhite":
						GameManager.add_collectible_to_savedata("yeti_weapon")
					"Dynasty":
						GameManager.add_collectible_to_savedata("manowar_weapon")
					"Inferno":
						GameManager.add_collectible_to_savedata("rooster_weapon")
					"MetalValley":
						GameManager.add_collectible_to_savedata("trilobyte_weapon")
					"PitchBlack":
						GameManager.add_collectible_to_savedata("mantis_weapon")
					"Primrose":
						GameManager.add_collectible_to_savedata("antonion_weapon")
					"TroiaBase":
						GameManager.add_collectible_to_savedata("sunflower_weapon")

					"LifeUpYeti":
						GameManager.add_collectible_to_savedata("life_up_yeti")
					"LifeUpPanda":
						GameManager.add_collectible_to_savedata("life_up_panda")
					"LifeUpRooster":
						GameManager.add_collectible_to_savedata("life_up_rooster")
					"LifeUpMantis":
						GameManager.add_collectible_to_savedata("life_up_mantis")
					"LifeUpTrilobyte":
						GameManager.add_collectible_to_savedata("life_up_trilobyte")
					"LifeUpManowar":
						GameManager.add_collectible_to_savedata("life_up_manowar")
					"LifeUpAntonion":
						GameManager.add_collectible_to_savedata("life_up_antonion")
					"LifeUpSunflower":
						GameManager.add_collectible_to_savedata("life_up_sunflower")

					"SubtankYeti":
						GameManager.add_collectible_to_savedata("subtank_yeti")
					"SubtankRooster":
						GameManager.add_collectible_to_savedata("subtank_rooster")
					"SubtankTrilobyte":
						GameManager.add_collectible_to_savedata("subtank_trilobyte")
					"SubtankSunflower":
						GameManager.add_collectible_to_savedata("subtank_sunflower")

					"HermesHead":
						GameManager.add_collectible_to_savedata("hermes_head")
					"HermesBody":
						GameManager.add_collectible_to_savedata("hermes_body")
					"HermesArms":
						GameManager.add_collectible_to_savedata("hermes_arms")
					"HermesFeet":
						GameManager.add_collectible_to_savedata("hermes_legs")
					"IcarusHead":
						GameManager.add_collectible_to_savedata("icarus_head")
					"IcarusBody":
						GameManager.add_collectible_to_savedata("icarus_body")
					"IcarusArms":
						GameManager.add_collectible_to_savedata("icarus_arms")
					"IcarusFeet":
						GameManager.add_collectible_to_savedata("icarus_legs")
					"UltimateArmor":
						GameManager.add_collectible_to_savedata("ultima_head")
						GameManager.add_collectible_to_savedata("ultima_body")
						GameManager.add_collectible_to_savedata("ultima_legs")
						GameManager.add_collectible_to_savedata("ultima_arms")

					"BlackZero":
						GameManager.add_collectible_to_savedata("black_zero_armor")
					"WhiteAxl":
						GameManager.add_collectible_to_savedata("white_axl_armor")
					_:
						pass
	
	return unlocked_collectibles

func test_random_password(no_of_tries) -> void :
	enter_random_password()

func enter_random_password() -> void :
	rng.randomize()
	var test_password = str(abs(rng.randi_range( - 558038585, - 727379969)))
	entered_password = fix_size(test_password)

func crc() -> void :
	pass

func fix_size(test_password) -> String:
	while test_password.length() < 16:
		test_password = "0" + test_password
	return test_password

func is_any_value_invalid(password) -> bool:
	var s1 = password.substr(0, 2)
	var s2 = password.substr(2, 2)
	var s3 = password.substr(4, 2)
	var s4 = password.substr(6, 2)
	var s5 = password.substr(8, 2)
	var s6 = password.substr(10, 2)
	var s7 = password.substr(12, 2)
	var s8 = password.substr(14, 2)
	var allkeys = [s1, s2, s3, s4, s5, s6, s7]
	for key in allkeys:
		if keys.get(key) == null:
			
			return true
	
	return false

func is_no_of_defeated_bosses_valid(param) -> bool:
	var total_bosses_defeated = 0
	var boss_locations = []
	for order in key_locations:
		for key in order:
			if key in bosses:
				boss_locations.append(Vector2(key_locations.find(order) * 2, order.find(key, 0) + 1))
	
	for location in boss_locations:
		var value_being_tested = password_being_tested.substr(location.x, 2)
		
		if value_being_tested in keys:
			
			if location.y in keys[value_being_tested]:
				
				total_bosses_defeated += 1
	
	if total_bosses_defeated == 0 and param != "zero":
		
		return false
	if total_bosses_defeated % 2 != 0 and param == "even":
		debug("Was expecting even number, failed validation")
		return false
	if total_bosses_defeated % 2 == 0 and not param == "even":
		debug("Was expecting odd number, failed validation")
		return false
	debug("Valid number")
	return true

func remove_code(code) -> String:
	var s = sub_duples(
		entered_password.substr(0, 2), 
		code.substr(0, 2)) + sub_duples(entered_password.substr(2, 2), 
		code.substr(2, 2)) + sub_duples(entered_password.substr(4, 2), 
		code.substr(4, 2)) + sub_duples(entered_password.substr(6, 2), 
		code.substr(6, 2)) + sub_duples(entered_password.substr(8, 2), 
		code.substr(8, 2)) + sub_duples(entered_password.substr(10, 2), 
		code.substr(10, 2)) + sub_duples(entered_password.substr(12, 2), 
		code.substr(12, 2)) + sub_duples(entered_password.substr(14, 2), 
		code.substr(14, 2)
	)
	return s

func debug(message) -> void :
	if show_debug:
		print(message)

func add_duples(value1, value2) -> String:
	return add(value1.substr(0, 1), value2.substr(0, 1)) + add(value1.substr(1, 1), value2.substr(1, 1))

func sub_duples(value1, value2) -> String:
	return subtract(value1.substr(0, 1), value2.substr(0, 1)) + subtract(value1.substr(1, 1), value2.substr(1, 1))

func add(value1, value2) -> String:
	var result = int(value1) + int(value2)
	if result >= 10:
		result = (str(result).substr(1, 1))
	return str(result)

func subtract(value1, value2) -> String:
	var result = int(value1) - int(value2)
	if result <= - 1:
		result = 10 + result
	return str(result)
