extends NewAbility

onready var animation = AnimationController.new($"../animatedSprite", self)
onready var physics = Physics.new(get_parent())
onready var tween = TweenController.new(self)
onready var shutdown: AudioStreamPlayer2D = $shutdown

var holding_up := false
signal lay_down

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("debug3"):
		stage_end_execute()

func _ready() -> void:
	Event.listen("stage_clear",self,"stage_end_execute")

func _Setup() -> void:
	shutdown.play_rp()
	animation.play_again("deactivate")
	
	tween.method("set_horizontal_speed",physics.get_horizontal_speed(),0,0.25,physics)
	Tools.timer(0.25,"emit_lay_down",self)
	
func _Update(delta) -> void:
	physics.process_gravity(delta)

func _Interrupt() -> void:
	physics.set_horizontal_speed(0)

func _EndCondition() -> bool:
	return physics.is_on_floor() and timer > 0.25

func emit_lay_down() -> void:
	emit_signal("lay_down")

func stage_end_execute() -> void:
	if character.is_executing("Ride"):
		Log("Stage end execute")
		#character.start_listening_to_inputs()
		GameManager.player.animatedSprite.z_index += 20
		execute()

func _on_jump_just_pressed() -> void:
	if holding_up and not is_executing():
		_on_signal()

func _on_up_pressed() -> void:
	holding_up = true
func _on_up_released() -> void:
	holding_up = false
