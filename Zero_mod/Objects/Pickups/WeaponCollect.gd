extends Node2D
class_name ZeroWeaponCollectible

export  var active: bool = true
export  var remove_if_collected: bool = true
export  var character_name: String = ""
export  var weapon: Resource

onready var collectible_name: String = ""
onready var collisionShape: CollisionShape2D = $area2D / collisionShape2D
onready var weaponSprite: AnimatedSprite = $Weapon
onready var weapon_start_y: float = weaponSprite.position.y

var time_offset: float = 0.0
var amplitude: float = 1.0
var speed: float = 1.0
var timer: float = 0.0
var executing: bool = false


func set_sprites() -> void :
	match collectible_name:
		"b_fan_zero":
			weaponSprite.animation = "B-Fan"
			weaponSprite.rotation_degrees = 45
		"d_glaive_zero":
			weaponSprite.animation = "D-Glaive"
			weaponSprite.rotation_degrees = 45
		"k_knuckle_zero":
			weaponSprite.animation = "K-Knuckle"
			weaponSprite.rotation_degrees = 0
		"t_breaker_zero":
			weaponSprite.animation = "T-Breaker"
			weaponSprite.rotation_degrees = 45
		"v_hanger_zero":
			weaponSprite.animation = "V-Hanger"
			weaponSprite.rotation_degrees = 0
		"sigma_blade_zero":
			weaponSprite.animation = "Sigma-Blade"
			weaponSprite.rotation_degrees = 45

func _ready() -> void :
	if not active:
		queue_free()
		return
	if weapon:
		collectible_name = weapon.collectible
		set_sprites()
		
		
	Event.listen("player_set", self, "call_deferred_already_got")

func call_deferred_already_got() -> void :
	if remove_if_collected:
		call_deferred("handle_already_got")

func handle_already_got() -> void :
	if collectible_name in GameManager.collectibles:
		queue_free()
	
	if character_name != "":
		if CharacterManager.player_character != character_name:
			queue_free()

func _physics_process(delta: float) -> void :
	if not executing:
		time_offset += delta * speed * 5
		weaponSprite.position.y = weapon_start_y + amplitude * sin(time_offset)
	if timer > 0:
		timer += delta
		if timer > 1.5:
			if not $audioStreamPlayer2D.playing:
				timer = 0
				GameManager.unpause(name)
				GameManager.player.equip_subtank(collectible_name)
				GlobalVariables.set(collectible_name, 0)
				queue_free()

func process_increase_health(_delta: float) -> void :
	pass

func _on_area2D_body_entered(body: Node) -> void :
	if not executing:
		if body.is_in_group("Player"):
			unlock_weapon(body.get_parent())
			GameManager.pause(name)
			timer = 0.01
			$audioStreamPlayer2D2.play()
			executing = true
			collisionShape.set_deferred("disabled",true)
			achievement_check()

func unlock_weapon(player) -> void :
	GameManager.add_collectible_to_savedata(collectible_name)
	var shot_node = player.get_node("Shot")
	if shot_node.has_method("unlock_weapon"):
		shot_node.unlock_weapon(collectible_name)
		if shot_node.has_method("update_list_of_weapons"):
			shot_node.update_list_of_weapons()

func lock_weapon() -> void :
	GameManager.remove_collectible_from_savedata(collectible_name)
	if CharacterManager.player_character == "Zero":
		if is_instance_valid(GameManager.player):
			var zero = GameManager.player
			var shot_node = zero.get_node("Shot")
			if shot_node.has_method("lock_weapon"):
				shot_node.lock_weapon(collectible_name)
				if shot_node.has_method("update_list_of_weapons"):
					shot_node.update_list_of_weapons()

func achievement_check() -> void :
	
	Savefile.save(Savefile.save_slot)
	CharacterManager._save()
