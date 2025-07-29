extends Node

var pause_duration: float
var enemy: Node
var damage: int
var damage_source: Node
var original_values: Dictionary = {}
var velocity_nodes: Array = []
var original_scale_x: float
var paused_color: Color = Color(1, 1, 1)
var frozen: bool = false
var stun: bool = false
var frozen_sprite: AnimatedSprite
var frozen_resource: Resource = preload("res://Axl_mod/Player/Projectiles/BossWeapons/IceGattling/FreezeEffect.tres")

func _ready() -> void :
	frozen_sprite = AnimatedSprite.new()
	frozen_sprite.visible = false
	frozen_sprite.frames = frozen_resource
	frozen_sprite.modulate = Color(1, 1, 1, 0.5)
	add_child(frozen_sprite)
	frozen_sprite.animation = "default"

func start_pause(target: Node, damage_value: int, damage_source_node: Node) -> void :
	enemy = target
	damage = damage_value
	damage_source = damage_source_node

	if frozen:
		if "current_health" in enemy:
			if enemy.current_health <= 0 or damage > enemy.current_health or not enemy.is_in_group("Enemies"):
				_on_damage_timer_timeout()
				return

	if enemy is AnimatedSprite:
		original_scale_x = enemy.scale.x

	var ai_node = enemy.get_node("AI")
	if ai_node:
		ai_node.deactivate()

	if stun:
		var damage_on_touch_node = enemy.get_node("DamageOnTouch")
		if damage_on_touch_node:
			damage_on_touch_node.deactivate()

	for child in enemy.get_children():
		if child is AnimationPlayer:
			child.stop()
			original_values[child] = {"playing": true}
		elif child is AnimatedSprite:
			if not original_values.has(child):
				original_values[child] = {}
			original_values[child]["playing"] = child.playing
			original_values[child]["modulate"] = child.modulate
			child.playing = false
			child.modulate = paused_color

		if child is Tween:
			child.stop_all()

		for var_name in ["current_vertical_speed", "horizontal_velocity", "jump_velocity", 
							"jump_plus_ground_velocity", "horizontal_plus_ground_velocity", 
							"attack_velocity", "pursuit_speed"]:
			if var_name in child:
				if not original_values.has(child):
					original_values[child] = {}
				original_values[child][var_name] = child.get(var_name)
				child.set(var_name, 0)
				velocity_nodes.append(child)

	if not original_values.has(enemy):
		original_values[enemy] = {}

	for var_name in ["velocity", "bonus_velocity", "final_velocity"]:
		if var_name in enemy:
			original_values[enemy][var_name] = enemy.get(var_name)
			enemy.set(var_name, Vector2.ZERO)

	_set_pause_timer(pause_duration)

var pause_timer = null
func _set_pause_timer(_duration) -> void :
	if pause_timer == null:
		pause_timer = Timer.new()
	pause_timer.wait_time = _duration
	pause_timer.one_shot = true
	pause_timer.connect("timeout", self, "_on_pause_timer_timeout")
	add_child(pause_timer)
	pause_timer.start()

func _process(_delta: float) -> void :
	if frozen:
		if not enemy.is_in_group("Enemies"):
			return
		frozen_sprite.visible = false
		frozen_sprite.playing = true

		var enemy_sprite: AnimatedSprite = null
		for child in enemy.get_children():
			if child is AnimatedSprite:
				enemy_sprite = child
				break

		if enemy_sprite:
			var enemy_sprite_size = enemy_sprite.frames.get_frame(enemy_sprite.animation, 0).get_size()
			frozen_sprite.z_index = enemy_sprite.z_index + 20
			frozen_sprite.global_position.x = enemy.global_position.x
			frozen_sprite.global_position.y = enemy_sprite.global_position.y + (enemy_sprite_size.y / 2) - (frozen_sprite.frames.get_frame(frozen_sprite.animation, 0).get_size().y / 2)

	if "current_health" in enemy:
		if enemy.current_health <= 0:
			frozen_sprite.visible = false

func _on_pause_timer_timeout() -> void :
	if "current_health" in enemy:
		if enemy.current_health > 0:
			for child in enemy.get_children():
				if child is AnimationPlayer:
					if original_values.has(child) and original_values[child].has("playing"):
						if original_values[child]["playing"]:
							child.play()
				elif child is AnimatedSprite:
					if original_values.has(child):
						if original_values[child].has("playing"):
							child.playing = original_values[child]["playing"]
						if original_values[child].has("modulate"):
							child.modulate = original_values[child]["modulate"]

				if child is Tween:
					child.start()

			for node in original_values.keys():
				for key in original_values[node].keys():
					node.set(key, original_values[node][key])

			if frozen_sprite:
				frozen_sprite.visible = false
				frozen_sprite.playing = false

			var ai_node = enemy.get_node("AI")
			if ai_node:
				ai_node.activate()

			if stun:
				var damage_on_touch_node = enemy.get_node("DamageOnTouch")
				if damage_on_touch_node:
					damage_on_touch_node.activate()

			_on_damage_timer_timeout()

func _on_damage_timer_timeout() -> void :
	if self.damage > 0:
		if enemy and enemy.has_method("damage"):
			enemy.damage(damage, damage_source)
	queue_free()
