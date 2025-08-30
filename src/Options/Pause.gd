extends CanvasLayer

onready var fader: ColorRect = $CoverScreen
onready var bg: TextureRect = $bg
onready var pause: TextureRect = $pause
onready var choice: AudioStreamPlayer = $choice
onready var key_config: CanvasLayer = $KeyConfig
onready var options_menu: CanvasLayer = $OptionsMenu
onready var achievements: CanvasLayer = $AchievementsScreen
onready var ultimate_life_texture: Texture = preload("res://X_mod/UltimateX/HUD/life.png")
onready var ultimte_icon_texture: Texture = preload("res://X_mod/UltimateX/HUD/ultimate_x.png")
onready var ultimte_icon_material: Material = preload("res://X_mod/UltimateX/Sprites/x_ultimate_material.tres")
onready var game_mode_label: Label = $pause / game_mode
onready var zero_beta_icon: Texture = preload("res://Zero_mod/HUD/Zero_base.png")
onready var zero_beta_material: ShaderMaterial = preload("res://Zero_mod/Sprites/Zero_Material_Shader.tres")

var paused: bool = false
var subtanks: Array
var using_subtank: bool = false
var endgame: bool = false

signal pause_starting
signal pause_started
signal pause_ending
signal pause_ended
signal lock_buttons
signal unlock_buttons


func _ready() -> void :
	Event.listen("refresh_hud", self, "character_menu_visibility")
	call_deferred("character_menu_visibility")
	if not is_debugging():
		pause.visible = false
		bg.visible = false
		visible = true
	else:
		Pause()
	subtanks = get_subtank_controls()
	connect_subtank_signals()
	var common_buttons = [key_config, options_menu, achievements]
	for button in common_buttons:
		button.connect("end", self, "unlock_buttons")
	Event.connect("lumine_desperation", self, "on_lumine_desperation")
	Tools.timer(0.1, "set_game_mode_label", self)

func set_game_mode_label() -> void :
	if CharacterManager.game_mode == - 1:
		game_mode_label.modulate = Color("#329632")
		game_mode_label.modulate = Color("#8cff8c")
	elif CharacterManager.game_mode == 0:
		game_mode_label.modulate = Color("#68caff")
		game_mode_label.modulate = Color("#fbffaf")
	elif CharacterManager.game_mode == 1:
		game_mode_label.modulate = Color("#960000")
		game_mode_label.modulate = Color("#ff4b4b")
	elif CharacterManager.game_mode == 2:
		game_mode_label.modulate = Color("#771313")
		game_mode_label.modulate = Color("#ff7200")
	elif CharacterManager.game_mode == 3:
		game_mode_label.modulate = Color("#832b7f")
		game_mode_label.modulate = Color("#e090f2")
	game_mode_label.text = tr(CharacterManager.GAME_MODE)

func character_menu_visibility() -> void :
	var _pause_HUD = get_node("pause")
	var _lives_HUD = _pause_HUD.get_node("Lives")
	var _armors_HUD = _pause_HUD.get_node("Armor Group")
	var _zero_abilities = _pause_HUD.get_node("AbilitiesZero")
	var _zero_armor = _pause_HUD.get_node("BlackZeroArmor")
	
	reset_lives_visibility(_lives_HUD)
	reset_weapons_visibility(_pause_HUD)
	_armors_HUD.hide()
	_zero_abilities.hide()
	_zero_armor.hide()
	
	match CharacterManager.player_character:
		"Player":
			pass
		"X":
			set_visibility(_lives_HUD, "X_icon", true)
			set_visibility(_lives_HUD, "lives_icon", true)
			set_visibility(_pause_HUD, "Weapons", true)
			if CharacterManager.ultimate_x_armor:
				_lives_HUD.get_node("lives_icon").texture = ultimate_life_texture
				_lives_HUD.get_node("X_icon").texture = ultimte_icon_texture
				_lives_HUD.get_node("X_icon").material = ultimte_icon_material
			_armors_HUD.show()
		"Axl":
			set_visibility(_lives_HUD, "Axl_icon", true)
			set_visibility(_lives_HUD, "Axl_lives_icon", true)
			set_visibility(_pause_HUD, "WeaponsAxl", true)
			update_axl_icons(_lives_HUD)
		"Zero":
			set_visibility(_lives_HUD, "Zero_icon", true)
			set_visibility(_lives_HUD, "Zero_lives_icon", true)
			set_visibility(_pause_HUD, "WeaponsZero", true)
			_zero_abilities.show()
			if "black_zero_armor" in GameManager.collectibles:
				_zero_armor.show()
			update_zero_icons(_lives_HUD)

func reset_lives_visibility(_lives_HUD: Node) -> void :
	var icons = ["X_icon", "Axl_icon", "Zero_icon", "lives_icon", "Axl_lives_icon", "Zero_lives_icon"]
	for icon in icons:
		set_visibility(_lives_HUD, icon, false)

func reset_weapons_visibility(_pause_HUD: Node) -> void :
	set_visibility(_pause_HUD, "Weapons", false)
	set_visibility(_pause_HUD, "WeaponsAxl", false)
	set_visibility(_pause_HUD, "WeaponsZero", false)

func set_visibility(node: Node, child_name: String, visible: bool) -> void :
	node.get_node(child_name).visible = visible

func update_axl_icons(_lives_HUD: Node) -> void :
	var axl_icons = ["Axl_icon", "Axl_lives_icon"]
	for icon in axl_icons:
		var _axl_icon = _lives_HUD.get_node(icon)
		CharacterManager.set_axl_colors(_axl_icon)

func update_zero_icons(_lives_HUD: Node) -> void :
	var zero_icons = ["Zero_icon", "Zero_lives_icon"]
	for icon in zero_icons:
		var _zero_icon = _lives_HUD.get_node(icon)
		CharacterManager.set_zeroX8_colors(_zero_icon)

func on_lumine_desperation() -> void :
	endgame = true

func lock_buttons() -> void :
	emit_signal("lock_buttons")

func unlock_buttons() -> void :
	emit_signal("unlock_buttons")

func connect_subtank_signals() -> void :
	for s in subtanks:
		var _d = s.connect("using", self, "on_subtank_use")
		_d = s.connect("finished", self, "on_subtank_finish")

func on_subtank_use() -> void :
	using_subtank = true
	lock_buttons()

func on_subtank_finish() -> void :
	using_subtank = false
	unlock_buttons()

func _input(event: InputEvent) -> void :
	call_deferred("pause_input", event)

func pause_input(event: InputEvent) -> void :
	if using_subtank:
		return
	if not key_config.active and not options_menu.active and not achievements.active:
		if can_pause():
			if event.is_action_pressed("pause"):
				if not paused:
					Pause()
				elif paused:
					Unpause()
			elif event.is_action_pressed("ui_cancel"):
				if paused:
					Unpause()

func start_keyconfig() -> void :
	
	lock_buttons()
	key_config.start()

func start_options() -> void :
	
	lock_buttons()
	options_menu.start()

func start_achievements() -> void :
	
	lock_buttons()
	achievements.start()

func button_call(method) -> void :
	
	call(method)

func Pause() -> void :
	paused = true
	emit_signal("pause_starting")
	set_usable_subtanks()
	fader.FadeIn()
	GameManager.half_music_volume()
	Event.emit_signal("pause_menu_opened")
	GameManager.pause("PauseMenu")
	yield(fader, "finished")
	emit_signal("unlock_buttons")
	call_deferred("emit_signal", "pause_started")

func Unpause() -> void :
	emit_signal("pause_ending")
	emit_signal("lock_buttons")
	fader.FadeOut()
	paused = false
	GameManager.normal_music_volume()
	Savefile.save(Savefile.save_slot)
	yield(fader, "finished")
	Event.emit_signal("pause_menu_closed")
	GameManager.unpause("PauseMenu")
	emit_signal("pause_ended")

func play_choice_sound() -> void :
	choice.play()

func is_debugging() -> bool:
	return get_parent().name != "Hud"

func can_pause() -> bool:
	if is_debugging():
		return true
	if not GameManager.player:
		return false
	return GameManager.player.has_control() and not fader.transitioning and not endgame

func set_usable_subtanks() -> void :
	for each in subtanks:
		each.visible = false
		if GameManager.equip_subtanks:
			each.visible = true
		if not each.subtank.id in GameManager.collectibles:
			each.visible = false

func get_subtank_controls() -> Array:
	var a: Array = []
	a.append($"pause/Subtank Group/gridContainer/Subtank")
	a.append($"pause/Subtank Group/gridContainer/Subtank2")
	a.append($"pause/Subtank Group/gridContainer/Subtank3")
	a.append($"pause/Subtank Group/gridContainer/Subtank4")
	return a
