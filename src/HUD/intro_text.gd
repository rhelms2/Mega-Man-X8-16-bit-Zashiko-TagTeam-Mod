extends AnimatedSprite

export var duration := 1.2
export var warning_duration := 1.75
export var debug_mode := false
var timer := 0.0
onready var alert = $audioStreamPlayer2

func _ready() -> void:
	Event.listen("stage_start", self, "display_ready")
	Event.listen("show_warning",self,"display_warning")
	Event.listen("warning_done",self,"on_warning_done")

func _process(delta: float) -> void:
	if timer > 0:
		timer += delta
		handle_text()

func handle_text() -> void:
	if "ready" in animation:
		handle_intro_text()
	elif "warning" in animation:
		handle_boss_text() 

func handle_intro_text() -> void:
	if timer > duration:
		GameManager.emit_intro_signal()
		deactivate()

func handle_boss_text() -> void:
	if timer > warning_duration:
		Event.emit_signal("warning_done")

func on_warning_done() -> void:
	GameManager.start_boss()
	deactivate()
	

func deactivate():
	set_visible(false)
	timer = 0

func display_ready():
	set_visible(true)
	play("ready")

func display_warning():
	if debug_mode:
		GameManager.start_boss()
		return
	set_visible(true)
	play("warning")
	alert.play()

func _on_animatedSprite_animation_finished() -> void:
	if not "blink" in get_animation():
		play (get_animation() + "_blink")
		timer = 0.01
