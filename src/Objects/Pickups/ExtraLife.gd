extends PickUp

export  var extra_lives: int = 1

onready var _animatedSprite: = get_node("animatedSprite")
onready var health_item: PackedScene = preload("res://src/Objects/Heal.tscn")
onready var x_life: Resource = preload("res://src/Objects/Pickups/ExtraLife.tres")
onready var x_life_material: Material = preload("res://src/Effects/Materials/Player_Material_Shader.tres")
onready var x_ultimate_life: Resource = preload("res://X_mod/UltimateX/Objects/ExtraLife.tres")
onready var zero_life: Resource = preload("res://Zero_mod/Objects/Pickups/Extra_Life.tres")
onready var zero_life_material: Material = preload("res://Zero_mod/X8/Sprites/ZeroX8_Material_Shader.tres")
onready var axl_life: Resource = preload("res://Axl_mod/Objects/Pickups/ExtraLife.tres")
onready var axl_life_material: Material = preload("res://Axl_mod/Player/Axl_Material_Shader.tres")


func set_player_sprite() -> void :
	match CharacterManager.player_character:
		"Player":
			_animatedSprite.frames = x_life
		"X":
			_animatedSprite.frames = x_life
			_animatedSprite.material = x_life_material
			if CharacterManager.ultimate_x_armor:
				_animatedSprite.frames = x_ultimate_life
		"Zero":
			_animatedSprite.frames = zero_life
			_animatedSprite.material = zero_life_material
			CharacterManager.set_zeroX8_colors(_animatedSprite)
		"Axl":
			_animatedSprite.frames = axl_life
			_animatedSprite.material = axl_life_material
			CharacterManager.set_axl_colors(_animatedSprite)

func replace_with_health_item() -> void :
	var parent = get_parent()
	if parent:
		var new_item = health_item.instance()
		new_item.global_position = global_position - Vector2(0, - 8)
		new_item.expirable = false
		parent.add_child(new_item)
		queue_free()

func check_life_ups(lives) -> void :
	if CharacterManager.game_mode == 2 and not executing:
		if lives >= 5:
			call_deferred("replace_with_health_item")

func _ready() -> void :
	Event.connect("has_life_ups", self, "check_life_ups")
	Event.connect("character_switch", self, "set_player_sprite")
	call_deferred("set_player_sprite")
	var current_lives = GlobalVariables.get("player_lives")
	if CharacterManager.game_mode == 2:
		if current_lives >= 5:
			call_deferred("replace_with_health_item")
	elif CharacterManager.game_mode >= 3:
		call_deferred("replace_with_health_item")

func process_effect(_delta: float) -> void :
	pass

func process_state(delta: float) -> void :
	if is_on_floor():
		time_since_spawn += delta
		if expirable and not executing:
			if time_since_spawn > duration * 0.75:
				set_modulate(Color(1, 1, 1, abs(round(cos(time_since_spawn * 500)))))
			if time_since_spawn > duration:
				queue_free()

func _on_area2D_body_entered(body: Node) -> void :
	if not executing:
		if body.is_in_group("Player"):
			executing = true
			visible = false
			$sound.play()
			add_lives()

func add_lives() -> void :
	var current_lives = GlobalVariables.get("player_lives")
	GlobalVariables.set("player_lives", current_lives + extra_lives)
	Event.emit_signal("has_life_ups", GlobalVariables.get("player_lives"))
	Tools.timer(3.0, "queue_free", self)
