extends Node2D
class_name LifeUp

export  var collectible_name: String = "life_up_0"

onready var health_item: PackedScene = preload("res://src/Objects/Heal.tscn")

var timer: float = 0.0
var last_time_increased: float = 0.0
var amount_to_increase: int = 1
var executing: bool = false


func replace_with_health_item() -> void :
	var parent = get_parent()
	if parent:
		var new_item = health_item.instance()
		new_item.global_position = global_position - Vector2(0, - 8)
		new_item.expirable = false
		parent.add_child(new_item)
		queue_free()

func _ready() -> void :
	if CharacterManager.game_mode >= 3:
		call_deferred("replace_with_health_item")
	Event.listen("player_set", self, "call_deferred_already_got")

func call_deferred_already_got() -> void :
	call_deferred("handle_already_got")

func handle_already_got() -> void :
	if collectible_name in GameManager.collectibles:
		queue_free()
	
func _physics_process(delta: float) -> void :
	process_increase_health(delta)

func process_increase_health(delta: float) -> void :
	if timer > 0:
		timer += delta
		if timer > 1.5:
			increase_health()
	if amount_to_increase == 0:
		timer = 0
		GameManager.unpause(name)
		amount_to_increase = - 1
	if amount_to_increase < 0:
		if not $audioStreamPlayer2D.playing:
			GameManager.unpause(name)
			queue_free()

func increase_health() -> void :
	if timer > last_time_increased + 0.06 and amount_to_increase > 0:
		GameManager.player.max_health += 1
		GameManager.player.recover_health(1)
		last_time_increased = timer
		amount_to_increase -= 1
		$audioStreamPlayer2D.play()

func _on_area2D_body_entered(body: Node) -> void :
	if not executing:
		if body.is_in_group("Player"):
			GameManager.pause(name)
			timer = 0.01
			$audioStreamPlayer2D2.play()
			executing = true
			visible = false
			GameManager.add_collectible_to_savedata(collectible_name)
			body.character.num_equipped_hearts += 1
			var character_name = body.character.name
			CharacterManager.set_player_equipped_hearts(character_name, CharacterManager.equipped_hearts[character_name] + 1)
			achievement_check()

func achievement_check() -> void :
	var hearts = 0
	for collectible in GameManager.collectibles:
		if "life_up" in collectible:
			hearts += 1
	if hearts == 8:
		Achievements.unlock("COLLECTALLHEARTS")
	else:
		Savefile.save(Savefile.save_slot)
