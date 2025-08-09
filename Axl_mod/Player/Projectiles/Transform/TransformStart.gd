extends NewAbility

export  var crash: PackedScene
onready var animation: = AnimationController.new($animatedSprite, self)
onready var stage: = AbilityStage.new(self)
signal projectile_started
signal projectile_end(shot)
onready var flash: AnimatedSprite = $flash
onready var animatedSprite = get_node("animatedSprite")

onready var particle = get_node("Particle")
var transform_enemy
var spawner
var transformed_enemy_instance

export  var horizontal_velocity: = 0.0
export  var vertical_velocity: = 0.0

func _ready() -> void :
	execute()

func set_new_colors() -> void :
	animatedSprite.material.set_shader_param("R_MainColor1", Color("#DCE0FF"))
	animatedSprite.material.set_shader_param("R_MainColor2", Color("#A0A8BC"))
	animatedSprite.material.set_shader_param("R_MainColor3", Color("#4C5870"))
	animatedSprite.material.set_shader_param("R_MainColor4", Color("#C6B0CE"))
	animatedSprite.material.set_shader_param("R_MainColor5", Color("#AB89AC"))
	animatedSprite.material.set_shader_param("R_MainColor6", Color("#7E6380"))
	animatedSprite.material.set_shader_param("R_HairColor1", Color("#AA77DB"))
	animatedSprite.material.set_shader_param("R_HairColor2", Color("#8C59BD"))
	animatedSprite.material.set_shader_param("R_HairColor3", Color("#6318A5"))
	animatedSprite.material.set_shader_param("R_YellowColor1", Color("#0DD84A"))
	animatedSprite.material.set_shader_param("R_YellowColor2", Color("#0E9F39"))
	animatedSprite.material.set_shader_param("R_RedColor1", Color("#8C59BD"))
	animatedSprite.material.set_shader_param("R_RedColor2", Color("#6318A5"))

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
		stage.next()
		emit_particle()
		animatedSprite.visible = false

	elif stage.currently_is(1) and animation.has_finished_last():
		if spawner.detransformed:
			end()


func end() -> void :
	executing = false
	_Interrupt()
	timer = 0
	emit_signal("stop", name)

func emit_particle():
		particle.global_position = global_position
		particle.emit()

func instantiate() -> void :
	if transform_enemy != null:
		transformed_enemy_instance = transform_enemy.instance()
		get_tree().current_scene.add_child(transformed_enemy_instance, true)
		transformed_enemy_instance.global_position = GameManager.camera.global_position
		transformed_enemy_instance.transform = global_transform
		var facing_direction = global_transform.x.normalized()
		transformed_enemy_instance.scale.x = self.scale.x
		if transformed_enemy_instance.direction_copy:
			transformed_enemy_instance.animatedSprite.scale.x = self.scale.x
	
func _Interrupt() -> void :
	emit_signal("projectile_end", self)
	visible = false
	Tools.timer(1.0, "queue_free", self)
	emit_particle()
	if transformed_enemy_instance != null:
		transformed_enemy_instance.queue_free()

func on_death() -> void :
	set_physics_process(false)
	visible = false
	if transformed_enemy_instance != null:
		if is_instance_valid(transformed_enemy_instance):
			transformed_enemy_instance.queue_free()
	
func set_pause_mode_to_stop(_boss_name: = null) -> void :
	pause_mode = Node.PAUSE_MODE_STOP
func set_pause_mode_to_proccess(_boss_name: = null) -> void :
	pause_mode = Node.PAUSE_MODE_PROCESS

func flash_rotate() -> void :
	flash.z_index = - 1
	flash.frame = 0
	Tools.timer(0.1, "another_flash", self)

func another_flash() -> void :
	flash.rotation_degrees += 90
	flash.frame = 0
