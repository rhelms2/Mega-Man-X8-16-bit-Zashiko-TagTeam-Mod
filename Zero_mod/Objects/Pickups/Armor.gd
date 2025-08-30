extends Node2D
class_name BlackZeroArmor

export  var delete_when_collected: bool = true
export  var difficulty_minumum: int = 0

onready var collisionShape: = $area2D / collisionShape2D
onready var armor_head: = $Head
onready var armor_body: = $Body
onready var armor_foot: = $Foot
onready var head_start_y: float = armor_head.position.y
onready var body_start_y: float = armor_body.position.y
onready var foot_start_y: float = armor_foot.position.y
var time_offset: float = 0.0
var amplitude: float = 1.0
var speed: float = 1.0

onready var capsule: = $Capsule

export  var reset_armor: bool = false
export  var collectible_name: String = "black_zero_armor"
var timer: float = 0.0
var executing: bool = false


func _ready() -> void :
	if CharacterManager.game_mode < difficulty_minumum:
		queue_free()
		return
	if reset_armor:
		call_deferred("lock_black_zero_armor")
		Savefile.save(Savefile.save_slot)
	Event.listen("player_set", self, "call_deferred_already_got")
	if CharacterManager.betazero_activated:
		armor_head.animation = "Head_Beta"
		armor_body.animation = "Body_Beta"
		armor_foot.animation = "Foot_Beta"

func call_deferred_already_got() -> void :
	if delete_when_collected:
		call_deferred("handle_already_got")

func handle_already_got() -> void :
	if collectible_name in GameManager.collectibles:
		queue_free()

func _physics_process(delta: float) -> void :
	time_offset += delta * speed * 5
	armor_head.position.y = head_start_y + amplitude * sin(time_offset)
	armor_body.position.y = body_start_y + amplitude * sin(time_offset + PI / 3)
	armor_foot.position.y = foot_start_y
	if timer > 0:
		timer += delta
		if timer > 1.5:
			if not $audioStreamPlayer2D.playing:
				timer = 0
				GameManager.unpause(name)
				GameManager.player.equip_subtank(collectible_name)
				GlobalVariables.set(collectible_name, 0)
				capsule.animation = "finished"
				

func process_increase_health(_delta: float) -> void :
	pass

func _on_area2D_body_entered(body: Node) -> void :
	if not executing:
		if body.is_in_group("Player"):
			if body.get_parent().name == "Zero":
				unlock_black_zero_armor(body.get_parent())
				GameManager.pause(name)
				timer = 0.01
				$audioStreamPlayer2D2.play()
				executing = true
				armor_head.visible = false
				armor_body.visible = false
				armor_foot.visible = false
				collisionShape.disabled = true
				achievement_check()

func lock_black_zero_armor() -> void :
	if CharacterManager.current_player_character == "Zero":
		if is_instance_valid(GameManager.player):
			var zero = GameManager.player
			GameManager.remove_collectible_from_savedata(collectible_name)
			CharacterManager.black_zero_armor = false
			zero.equip_zero_parts()
			CharacterManager.set_zeroX8_colors(zero.animatedSprite)
			zero.animatedSprite.get_node("afterImages").set_shader_colors()
			CharacterManager.set_saberX8_colors(zero.animatedSprite)
			var pause_node = get_tree().root.find_node("Pause", true, false)
			pause_node.character_menu_visibility()

func unlock_black_zero_armor(zero) -> void :
	GameManager.add_collectible_to_savedata(collectible_name)
	CharacterManager.black_zero_armor = true
	zero.equip_black_zero_parts()
	CharacterManager.set_zeroX8_colors(zero.animatedSprite)
	zero.animatedSprite.get_node("afterImages").set_shader_colors()
	CharacterManager.set_saberX8_colors(zero.animatedSprite)
	var pause_node = get_tree().root.find_node("Pause", true, false)
	pause_node.character_menu_visibility()

func achievement_check() -> void :
	Achievements.unlock("COLLECTBLACKZERO")
	Savefile.save(Savefile.save_slot)
	CharacterManager._save()
