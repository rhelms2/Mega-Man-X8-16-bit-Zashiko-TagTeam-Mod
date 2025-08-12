extends TextureRect

export  var legible_name: String
export  var description: String

onready var name_display: Label = $"../Description/name"
onready var disc_display: Label = $"../Description/disc"
onready var character_name = $"../CharacterName"
onready var equip: AudioStreamPlayer = $"../../equip"
onready var unequip: AudioStreamPlayer = $"../../unequip"
onready var choice = $"../../choice"


onready var team_member_1 = $team_member1
onready var team_member_2 = $team_member2

# Called when the node enters the scene tree for the first time.
func _ready():
	team_member_1.connect("focus_entered", self, "display_info")
	team_member_2.connect("focus_entered", self, "display_info")
	team_member_1.connect("pressed", self, "team_mem1_pressed")
	team_member_2.connect("pressed", self, "team_mem2_pressed")
	for i in range(CharacterManager.current_team.size()):
		var team_mem = CharacterManager.current_team[i]
		get_child(i).sprite.play(team_mem)
		
func team_mem1_pressed() -> void :
	if CharacterManager.current_team.size() <= 1:
		if team_member_1.sprite.get_animation() != character_name.text:
			CharacterManager.remove_player_from_team(team_member_1.sprite.get_animation())
			team_member_1.sprite.play(character_name.text)
			CharacterManager.add_player_to_team(character_name.text)
			equip.play()
		else:
			unequip.play()
	elif CharacterManager.current_team.size() == CharacterManager.max_team_size:
		if team_member_2.sprite.get_animation() == character_name.text:
			team_member_2.sprite.play(team_member_1.sprite.get_animation())
			team_member_1.sprite.play(character_name.text)
			CharacterManager.current_team.invert()
			equip.play()
		elif team_member_1.sprite.get_animation() == character_name.text:
			unequip.play()
		else:
			CharacterManager.remove_player_from_team(team_member_1.sprite.get_animation())
			team_member_1.sprite.play(character_name.text)
			CharacterManager.add_player_to_team(character_name.text)
			equip.play()
	
func team_mem2_pressed() -> void :
	if CharacterManager.current_team.size() == 0:
		team_member_1.sprite.play(character_name.text)
		CharacterManager.add_player_to_team(character_name.text)
		equip.play()
	elif team_member_2.sprite.get_animation() == character_name.text:
		team_member_2.sprite.play("Blank")
		CharacterManager.remove_player_from_team(character_name.text)
		unequip.play()
	elif team_member_1.sprite.get_animation() == character_name.text:
		if CharacterManager.current_team.size() == CharacterManager.max_team_size:
			team_member_1.sprite.play(team_member_2.sprite.get_animation())
			team_member_2.sprite.play(character_name.text)
			CharacterManager.current_team.invert()
			equip.play()
		else:
			unequip.play()
	else:
		team_member_2.sprite.play(character_name.text)
		CharacterManager.add_player_to_team(character_name.text)
		equip.play()


func display_info() -> void :
	choice.play()
	name_display.text = tr(legible_name)
	disc_display.text = tr(description)
