extends NewAbility

export  var crash: PackedScene
onready var animation: = AnimationController.new($animatedSprite, self)
onready var stage: = AbilityStage.new(self)
signal projectile_started
signal projectile_end(shot)
onready var flash: AnimatedSprite = $flash

export  var horizontal_velocity: = 0.0
export  var vertical_velocity: = 0.0

func _ready() -> void :
	execute()

func _Setup() -> void :
	GameManager.pause("GigaCrash")
	Event.listen("enemy_kill", self, "set_pause_mode_to_stop")
	Event.listen("pause_menu_opened", self, "set_pause_mode_to_stop")
	Event.listen("pause_menu_closed", self, "set_pause_mode_to_proccess")
	animation.play("intro")
	
	Tools.timer(0.4, "flash_rotate", self)
	emit_signal("projectile_started")
	
	get_node("animatedSprite").rotation = deg2rad(0)
	

func _Update(_d) -> void :
	global_position = GameManager.get_player_position()
	if stage.is_initial() and timer > 0.75:
		
		GameManager.unpause("GigaCrash")
		instantiate()
		Event.emit_signal("screenshake", 0.85)
		animation.play("fire_loop")
		Tools.timer(0.35, "screenshake", self)
		Tools.timer(0.65, "screenshake", self)
		stage.next()

	elif stage.currently_is(1) and timer > 1.0:
		
		animation.play("fire_idle")
		stage.next()
	
	elif stage.currently_is(2) and timer > 0.25:
		
		
		animation.play("fire_end")
		stage.next()
		
	elif stage.currently_is(3) and animation.has_finished_last():
		EndAbility()

func screenshake() -> void :
	Event.emit_signal("screenshake", 0.25)
	

func _Interrupt() -> void :
	emit_signal("projectile_end", self)
	visible = false
	Tools.timer(1.0, "queue_free", self)

func on_death() -> void :
	set_physics_process(false)
	visible = false
	
func set_pause_mode_to_stop(_boss_name: = null) -> void :
	pause_mode = Node.PAUSE_MODE_STOP
func set_pause_mode_to_proccess(_boss_name: = null) -> void :
	pause_mode = Node.PAUSE_MODE_PROCESS

func instantiate() -> void :
	var c = crash.instance()
	add_child(c, true)
	c.global_position = GameManager.camera.global_position
	c.initialize(1)

func flash_rotate() -> void :
	flash.z_index = - 1
	flash.frame = 0
	Tools.timer(0.1, "another_flash", self)

func another_flash() -> void :
	flash.rotation_degrees += 90
	flash.frame = 0
