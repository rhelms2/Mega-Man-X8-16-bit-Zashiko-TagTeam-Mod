extends NinePatchRect

onready var bike_bar: NinePatchRect = $"../Ride Bar"
onready var armor_bar: NinePatchRect = $"../RideArmor Bar"
onready var tween: TweenController = TweenController.new(self, false)
onready var x_bar_texture: Texture = preload("res://src/HUD/X_bar.png")
onready var axl_bar_texture: Texture = preload("res://Axl_mod/HUD/Axl_bar.png")
onready var zero_bar_texture: Texture = preload("res://Zero_mod/HUD/Zero_bar.png")

var fading_out: bool = false
var fading_in: bool = false


func set_player_hud():
	match CharacterManager.current_player_character:
		"Player":
			texture = x_bar_texture
		"X":
			texture = x_bar_texture
		"Zero":
			texture = zero_bar_texture
		"Axl":
			texture = axl_bar_texture

func _ready() -> void :
	set_player_hud()
	Event.connect("player_death", self, "disable")
	Event.listen("refresh_hud", self, "set_player_hud")

func disable() -> void :
	set_physics_process(false)

func fade_out() -> void :
	if not fading_out:
		fading_out = true
		fading_in = false
		tween.reset()
		tween.attribute("modulate:a", 0.1, 0.1)
		tween.attribute("modulate:a", 0.1, 0.1, bike_bar)
		tween.attribute("modulate:a", 0.1, 0.1, armor_bar)

func fade_in() -> void :
	if not fading_in:
		fading_in = true
		fading_out = false
		tween.reset()
		tween.attribute("modulate:a", 1.0, 0.6)
		tween.attribute("modulate:a", 1.0, 0.6, bike_bar)
		tween.attribute("modulate:a", 1.0, 0.6, armor_bar)

func _physics_process(_delta: float) -> void :
	if player_is_near_lifebar():
		fade_out()
	else:
		fade_in()

func player_is_near_lifebar() -> bool:
	var screencenter = GameManager.camera.get_camera_screen_center()
	return GameManager.get_player_position().x < screencenter.x - 199 + 36 and GameManager.get_player_position().y < screencenter.y + 10
