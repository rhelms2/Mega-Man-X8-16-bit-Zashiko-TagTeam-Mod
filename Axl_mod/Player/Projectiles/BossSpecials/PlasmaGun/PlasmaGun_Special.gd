extends SpecialAbilityAxl

onready var player_damage: = character.get_node("Damage")
onready var player_walk: = character.get_node("Walk")
onready var player_jump: = character.get_node("Jump")
onready var player_walljump: = character.get_node("WallJump")
onready var player_hover: = character.get_node("Hover")
onready var player_wallslide: = character.get_node("WallSlide")
onready var player_dash: = character.get_node("Dash")
onready var player_airdash: = character.get_node("AirDash")
onready var player_dashjump: = character.get_node("DashJump")
onready var player_dashwalljump: = character.get_node("DashWallJump")
onready var player_dodge: = character.get_node("Dodge")
onready var player_fall: = character.get_node("Fall")
onready var sfx: AudioStreamPlayer = $sfx
onready var sfx_sparks: AudioStreamPlayer2D = $sparks

var aura_time: float = 13.0
var speed_factor: float = 1.5
var height_factor: float = 1.15
var gravity_factor: float = 0.85
var debuff_time: float = 3.0
var flash_time: float = 0.125
var flash_timer: float = 0.0
var debuff_speed_factor: float = 0.75
var debuff_height_factor: float = 0.85
var debuff_gravity_factor: float = 1.0
var default_gravity: float = 900.0
var sfx_play_time: float = 0.0

var walk_speed: float
var jump_speed: float
var walljump_speed: float
var hover_speed: float
var wallslide_speed: float
var dash_speed: float
var airdash_speed: float
var dashjump_speed: float
var dashwalljump_speed: float
var dodge_speed: float
var fall_speed: float
var dashfall_speed: float
var jump_time: float
var dashjumptime: float
var walljumptime: float
var dashwalljump_time: float

func deactivate() -> void :
	unset_aura_buff()
	sfx_sparks.stop()
	queue_free()

func destroy(enemy) -> void :
	if typeof(enemy) == TYPE_STRING:
		if enemy == "boss":
			go_to_attack_stage(10)

func initialize() -> void :
	Tools.timer(animation_time, "set_stage", self)

func set_stage() -> void :
	attack_stage = 1

func _physics_process(delta: float) -> void :
	._physics_process(delta)
	
	if attack_stage == 1:
		play_animation("aura")
		animatedSprite.show()
		set_aura_buff()
		next_attack_stage()
		
	elif attack_stage == 2:
		animatedSprite.scale.x *= - 1
		animatedSprite.scale.y *= - 1
		sfx_play_time -= delta
		if sfx_play_time <= 0:
			sfx_play_time = 0.0625
			sfx.play()
		aura_time -= delta
		if aura_time <= 0:
			animatedSprite.hide()
			unset_aura_buff()
			set_aura_debuff()
			sfx_sparks.play()
			next_attack_stage()

	elif attack_stage == 3:
		flash_timer -= delta
		if flash_timer <= 0:
			flash_timer = flash_time
			character.flash()
		debuff_time -= delta
		if debuff_time <= 0:
				go_to_attack_stage(10)
	
	elif attack_stage == 10:
		unset_aura_buff()
		next_attack_stage()
		EndAbility()

func set_aura_buff() -> void :
	backup_original_values()
	
	player_walk.horizontal_velocity *= speed_factor
	player_jump.horizontal_velocity *= speed_factor
	player_walljump.horizontal_velocity *= speed_factor
	player_hover.horizontal_velocity *= speed_factor
	player_dash.horizontal_velocity *= speed_factor
	player_airdash.horizontal_velocity *= speed_factor
	player_dashjump.horizontal_velocity *= speed_factor
	player_dashwalljump.horizontal_velocity *= speed_factor
	player_dodge.horizontal_velocity *= speed_factor
	player_fall.horizontal_velocity *= speed_factor
	player_fall.dash_momentum *= speed_factor
	player_wallslide.jump_velocity *= gravity_factor
	
	player_jump.max_jump_time *= height_factor
	player_walljump.max_jump_time *= height_factor
	player_dashjump.max_jump_time *= height_factor
	player_dashwalljump.max_jump_time *= height_factor
	
	player_walk.default_gravity *= gravity_factor
	player_jump.default_gravity *= gravity_factor
	player_walljump.default_gravity *= gravity_factor
	player_hover.default_gravity *= gravity_factor
	player_wallslide.default_gravity *= gravity_factor
	player_dash.default_gravity *= gravity_factor
	player_airdash.default_gravity *= gravity_factor
	player_dashjump.default_gravity *= gravity_factor
	player_dashwalljump.default_gravity *= gravity_factor
	player_dodge.default_gravity *= gravity_factor
	player_fall.default_gravity *= gravity_factor

func set_aura_debuff() -> void :
	
	player_walk.horizontal_velocity *= debuff_speed_factor
	player_jump.horizontal_velocity *= debuff_speed_factor
	player_walljump.horizontal_velocity *= debuff_speed_factor
	player_hover.horizontal_velocity *= debuff_speed_factor
	player_dash.horizontal_velocity *= debuff_speed_factor
	player_airdash.horizontal_velocity *= debuff_speed_factor
	player_dashjump.horizontal_velocity *= debuff_speed_factor
	player_dashwalljump.horizontal_velocity *= debuff_speed_factor
	player_dodge.horizontal_velocity *= debuff_speed_factor
	player_fall.horizontal_velocity *= debuff_speed_factor
	player_fall.dash_momentum *= debuff_speed_factor
	player_wallslide.jump_velocity *= debuff_gravity_factor
	
	player_jump.max_jump_time *= debuff_height_factor
	player_walljump.max_jump_time *= debuff_height_factor
	player_dashjump.max_jump_time *= debuff_height_factor
	player_dashwalljump.max_jump_time *= debuff_height_factor
	
	player_walk.default_gravity *= debuff_gravity_factor
	player_jump.default_gravity *= debuff_gravity_factor
	player_walljump.default_gravity *= debuff_gravity_factor
	player_hover.default_gravity *= debuff_gravity_factor
	player_wallslide.default_gravity *= debuff_gravity_factor
	player_dash.default_gravity *= debuff_gravity_factor
	player_airdash.default_gravity *= debuff_gravity_factor
	player_dashjump.default_gravity *= debuff_gravity_factor
	player_dashwalljump.default_gravity *= debuff_gravity_factor
	player_dodge.default_gravity *= debuff_gravity_factor
	player_fall.default_gravity *= debuff_gravity_factor

func unset_aura_buff() -> void :
	restore_original_values()

func restore_original_values() -> void :
	
	player_walk.horizontal_velocity = walk_speed
	player_jump.horizontal_velocity = jump_speed
	player_walljump.horizontal_velocity = walljump_speed
	player_hover.horizontal_velocity = hover_speed
	player_dash.horizontal_velocity = dash_speed
	player_airdash.horizontal_velocity = airdash_speed
	player_dashjump.horizontal_velocity = dashjump_speed
	player_dashwalljump.horizontal_velocity = dashwalljump_speed
	player_dodge.horizontal_velocity = dodge_speed
	player_fall.horizontal_velocity = fall_speed
	player_fall.dash_momentum = dashfall_speed
	player_wallslide.jump_velocity = wallslide_speed
	
	player_jump.max_jump_time = jump_time
	player_walljump.max_jump_time = walljumptime
	player_dashjump.max_jump_time = dashjumptime
	player_dashwalljump.max_jump_time = dashwalljump_time
	
	player_walk.default_gravity = default_gravity
	player_jump.default_gravity = default_gravity
	player_walljump.default_gravity = default_gravity
	player_hover.default_gravity = default_gravity
	player_wallslide.default_gravity = default_gravity
	player_dash.default_gravity = default_gravity
	player_airdash.default_gravity = default_gravity
	player_dashjump.default_gravity = default_gravity
	player_dashwalljump.default_gravity = default_gravity
	player_dodge.default_gravity = default_gravity
	player_fall.default_gravity = default_gravity

func backup_original_values() -> void :
	
	walk_speed = player_walk.horizontal_velocity
	jump_speed = player_jump.horizontal_velocity
	walljump_speed = player_walljump.horizontal_velocity
	hover_speed = player_hover.horizontal_velocity
	dash_speed = player_dash.horizontal_velocity
	airdash_speed = player_airdash.horizontal_velocity
	dashjump_speed = player_dashjump.horizontal_velocity
	dashwalljump_speed = player_dashwalljump.horizontal_velocity
	dodge_speed = player_dodge.horizontal_velocity
	fall_speed = player_fall.horizontal_velocity
	dashfall_speed = player_fall.dash_momentum
	wallslide_speed = player_wallslide.jump_velocity
	
	jump_time = player_jump.max_jump_time
	walljumptime = player_walljump.max_jump_time
	dashjumptime = player_dashjump.max_jump_time
	dashwalljump_time = player_dashwalljump.max_jump_time
