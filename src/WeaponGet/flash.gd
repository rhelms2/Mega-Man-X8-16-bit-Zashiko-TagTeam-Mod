extends Sprite

onready var tween: = TweenController.new(self, false)

func _ready() -> void :
	modulate.a = 0

func start() -> void :
	modulate.a = 1
	
	tween.create(Tween.EASE_OUT, Tween.TRANS_LINEAR, true)
	tween.set_ignore_pause_mode()
	
	tween.add_attribute("modulate:a", 0.0, 0.85)

func define_color_via_weapon(current_weapon) -> void :
	modulate = current_weapon.MainColor4
	modulate.a = 0
