extends NewAbility

export  var special: PackedScene = preload("res://Axl_mod/Player/Projectiles/BossSpecials/RayGun/Raygun_Special.tscn")
export  var horizontal_velocity: float = 0.0
export  var vertical_velocity: float = 0.0

onready var animation: = AnimationController.new($animatedSprite, self)
onready var stage: = AbilityStage.new(self)
onready var animatedSprite: AnimatedSprite = $animatedSprite
onready var bossAnimation: = AnimationController.new($bossSprite, self)
onready var bossSprite: AnimatedSprite = $bossSprite
onready var flash: AnimatedSprite = $flash
onready var transformSprite: AnimatedSprite = $transform
onready var transform_sfx: = $transform_sfx
onready var sfx: = $sound

onready var antonion_sfx: PitchStreamPlayer2D = $antonion
onready var manowar_sfx: = $manowar
onready var mantis_sfx: = $mantis
onready var panda_sfx: = $panda
onready var rooster_sfx: = $rooster
onready var sunflower_sfx: = $sunflower
onready var trilobyte_sfx: = $trilobyte
onready var yeti_sfx: = $yeti
onready var boss_sfx

onready var raygun_special: PackedScene = preload("res://Axl_mod/Player/Projectiles/BossSpecials/RayGun/Raygun_Special.tscn")
onready var icegattling_special: PackedScene = preload("res://Axl_mod/Player/Projectiles/BossSpecials/IceGattling/IceGattling_Special.tscn")
onready var boundblaster_special: PackedScene = preload("res://Axl_mod/Player/Projectiles/BossSpecials/BoundBlaster/BoundBlaster_Special.tscn")
onready var blastlauncher_special: PackedScene = preload("res://Axl_mod/Player/Projectiles/BossSpecials/BlastLauncher/BlastLauncher_Special.tscn")
onready var plasmagun_special: PackedScene = preload("res://Axl_mod/Player/Projectiles/BossSpecials/PlasmaGun/PlasmaGun_Special.tscn")
onready var spiralmagnum_special: PackedScene = preload("res://Axl_mod/Player/Projectiles/BossSpecials/SpiralMagnum/SpiralMagnum_Special.tscn")
onready var blackarrow_special: PackedScene = preload("res://Axl_mod/Player/Projectiles/BossSpecials/BlackArrow/BlackArrow_Special.tscn")
onready var flameburner_special: PackedScene = preload("res://Axl_mod/Player/Projectiles/BossSpecials/FlameBurner/FlameBurner_Special.tscn")

var y_offset: float = 0.0
var animation_time: float = 2.0
var boss_animation: String = ""
var boss_start_animation: String = ""
var behind: bool = false
var full_front: bool = false
var HUD: bool = false

signal projectile_started
signal projectile_end(shot)


func _ready() -> void :
	execute()

func decide_boss_special() -> void :
	boss_sfx = get_node(boss_animation)
	if boss_animation == "antonion":
		boss_start_animation = "antonion_start"
		special = spiralmagnum_special
		bossSprite.position = Vector2(0, - 14)
		transformSprite.position = Vector2(0, 0)
	elif boss_animation == "manowar":
		boss_start_animation = "manowar_start"
		special = plasmagun_special
		bossSprite.position = Vector2(0, - 12)
	elif boss_animation == "mantis":
		boss_start_animation = "mantis_start"
		special = blackarrow_special
		bossSprite.flip_h = false
		bossSprite.position = Vector2(0, - 25)
	elif boss_animation == "panda":
		boss_start_animation = "panda_start"
		special = blastlauncher_special
		bossSprite.position = Vector2(0, - 31)
	elif boss_animation == "rooster":
		boss_start_animation = "rooster_start"
		special = flameburner_special
		bossSprite.position = Vector2( - 3 * scale.x, - 29)
	elif boss_animation == "sunflower":
		boss_start_animation = "sunflower_start"
		special = raygun_special
		bossSprite.position = Vector2( - 4 * scale.x, - 36)
		full_front = true
	elif boss_animation == "trilobyte":
		boss_start_animation = "trilobyte_start"
		special = boundblaster_special
		bossSprite.position = Vector2(0, - 19)
		y_offset = - 2
	elif boss_animation == "yeti":
		boss_start_animation = "yeti_start"
		special = icegattling_special
		bossSprite.position = Vector2(0, - 33)
		behind = true

func _Setup() -> void :
	decide_boss_special()
	GameManager.pause("BossSpecial")
	Event.listen("enemy_kill", self, "set_pause_mode_to_stop")
	Event.listen("pause_menu_opened", self, "set_pause_mode_to_stop")
	Event.listen("pause_menu_closed", self, "set_pause_mode_to_proccess")
	animation.play("intro")
	emit_signal("projectile_started")
	get_node("animatedSprite").rotation = deg2rad(0)
	var children = character.get_children()
	for child in children:
		if child is SpecialAbilityAxl and child != self:
			child.deactivate()

func _Update(_delta: float) -> void :
	global_position = GameManager.get_player_position()
	if stage.is_initial() and animation.has_finished_last():
		GameManager.unpause("BossSpecial")
		flash_rotate()
		transformSprite.show()
		transformSprite.frame = 0
		transformSprite.play("default")
		if boss_animation != "":
			boss_sfx.play()
			transform_sfx.play()
			animatedSprite.hide()
			bossSprite.show()
			bossAnimation.play(boss_start_animation)
			stage.next()
		else:
			stage.go_to_stage(10)
		
	elif stage.currently_is(1) and bossAnimation.has_finished_last():
		bossAnimation.play(boss_animation)
		instantiate()
		stage.go_to_stage(10)
		
	
	elif stage.currently_is(10) and timer > animation_time:
		transform_sfx.play()
		bossSprite.hide()
		animatedSprite.show()
		animation.play("end")
		transformSprite.frame = 0
		transformSprite.play("default")
		transformSprite.position = Vector2( - 1, 3)
		stage.next()
		
	elif stage.currently_is(11) and animation.has_finished_last():
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
	if special != null:
		var projectile = special.instance()
		if HUD:
			get_tree().current_scene.get_node("Hud").add_child(projectile, true)
		else:
			character.add_child(projectile, true)
			if behind:
				projectile.z_index = z_index - 1
			else:
				projectile.z_index = z_index + 5
				if full_front:
					projectile.z_index = 100
			projectile.global_position.x = global_position.x
			projectile.global_position.y = global_position.y + y_offset
		projectile.animation_time = animation_time
		projectile.initialize()

func flash_rotate() -> void :
	flash.z_index = - 1
	flash.frame = 0
	Tools.timer(0.1, "another_flash", self)

func another_flash() -> void :
	flash.rotation_degrees += 90
	flash.frame = 0
