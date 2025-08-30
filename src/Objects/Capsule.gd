extends Node2D

export  var debug_logs: bool = false
export  var armor_part: String = "icarus_head"
export  var dialogue: Resource

onready var start_area = get_node("area2D")
onready var sprite = get_node("animatedSprite")
onready var particles = $particles2D
onready var glass: CollisionShape2D = $glass / collisionShape2D

var player
var charge_state: = 0
var gave_armor: = false
var finished: = false
var timer: = 0.0
var timer2: = 0.0
var color: = Color(0, 0, 1, 0)

signal lightning


func _ready() -> void :
	Event.listen("player_set", self, "call_deferred_got_armor")
	#Event.listen("character_switch", self, "handle_player_not_x")
	timer = 0.0
	timer2 = 0.0
	charge_state = 0
	finished = false
	#call_deferred("handle_player_not_x")

func handle_player_not_x() -> void :
	if CharacterManager.player_character != "X":
		finished = true
		call_deferred("disable_glass_collider")
		sprite.play("finished")
		if debug_logs:
			print_debug("Player is not X")

func call_deferred_got_armor() -> void :
	call_deferred("handle_already_got_armor")

func handle_already_got_armor() -> void :
	if armor_part in GameManager.collectibles:
		finished = true
		call_deferred("disable_glass_collider")
		sprite.play("finished")
		if debug_logs:
			print_debug("Capsule: Player already has " + armor_part)

func _on_area2D_body_entered(body: Node) -> void :
	call_deferred("check_start", body)

func check_start(body: Node) -> void :
	if not finished:
		if GameManager.player.is_executing("Ride"):
			return
		if body.is_in_group("Player"):
			player = body.get_parent()
			if can_interact() and sprite.animation == "idle" and player == GameManager.player:
				sprite.play("open")
				$open.play()
				Event.emit_signal("capsule_open")
				GameManager.stop_character_inputs()
				GameManager.start_capsule_dialog(dialogue)
				call_deferred("disable_glass_collider")

func disable_glass_collider() -> void :
	glass.disabled = true

func can_interact() -> bool:
	return not GameManager.player.is_executing("Ride") and not GameManager.player.is_executing("WeaponStasis")

func _on_area2D2_body_entered(_body: Node) -> void :
	if not finished:
		if can_interact():
			Event.emit_signal("capsule_entered")
			GameManager.player.force_movement()
			GameManager.player.play_animation_once("recover")
			GameManager.player.deactivate()
			GameManager.player.global_position.x = global_position.x
			GameManager.player.global_position.y = global_position.y - 31
			sprite.play("slow_charge")
			color = Color(0, 0, 1, 0)
			enable_charge_shader()
			particles.emitting = true
			$charge.play()
			charge_state += 1

func _process(delta: float) -> void :
	if not finished:
		if charge_state >= 1:
			timer += delta
			GameManager.player.animatedSprite.material.set_shader_param("Color", color)
		
		if charge_state >= 1 and charge_state < 3:
			particles.speed_scale += delta * 2
			color = lerp(Color(abs(cos(timer * 5000)) * 0.25, 0, abs(sin(timer * 5000)) * 0.25, 0), Color(abs(cos(timer * 5000)), 0.5, abs(sin(timer * 5000)), 0), timer / 5)

		elif charge_state == 3:
			timer2 += delta
			color = lerp(Color(1, 1, 1, 1), Color(0, 0, 0, 0), timer2)
			
		if charge_state == 1:
			if timer > 2:
				sprite.play("fast_charge")
				charge_state += 1

		elif charge_state == 2:
			if timer > 5:
				sprite.play("lightning")
				emit_signal("lightning")
				Event.emit_signal("screenshake", 1.0)
				z_index = 5
				$thunder.play()
				particles.emitting = false
				charge_state += 1
				timer = 0
		
		elif charge_state == 3:
			if timer > 0.4:
				if not gave_armor:
					Event.emit_signal("collected", armor_part)
					Savefile.save(Savefile.save_slot)
					player.play_animation_once("armor_receive")
					gave_armor = true
					achievement_check()

		elif charge_state == 4:
			if timer > 0.5:
				charge_state += 1
				timer = 0
				timer2 = 0
			
		elif charge_state == 5:
			GameManager.player.play_animation_once("armor_blink")
			if timer > 1.2:
				GameManager.player.play_animation_once("victory")
				$victory.play()
				charge_state += 1
				timer = 0
		
		elif charge_state == 6:
			if timer > 1:
				GameManager.player.stop_forced_movement()
				GameManager.player.reactivate_charge()
				finished = true

func _on_animatedSprite_animation_finished() -> void :
	if sprite.animation == "open":
		sprite.play("waiting")
	if sprite.animation == "lightning":
		charge_state += 1
		timer = 0

func enable_charge_shader() -> void :
	GameManager.player.animatedSprite.material.set_shader_param("Charge", 1)

func disable_charge_shader() -> void :
	GameManager.player.animatedSprite.material.set_shader_param("Charge", 0)

func achievement_check() -> void :
	if "hermes" in armor_part:
		if has_fullset("hermes"):
			Achievements.unlock("COLLECTFULLHERMES")
	else:
		if has_fullset("icarus"):
			Achievements.unlock("COLLECTFULLICARUS")

func has_fullset(set: String) -> bool:
	var pieces = 0
	for collectible in GameManager.collectibles:
		if set in collectible:
			pieces += 1
	return pieces == 4
