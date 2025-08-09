extends SpecialAbilityAxl

onready var player_damage: = character.get_node("Damage")
onready var player_shot: = character.get_node("Shot")
onready var player_altshot: = character.get_node("AltFire")
onready var player_special: = character.get_node("Special")
onready var player_jump: = character.get_node("Jump")
onready var player_dashjump: = character.get_node("DashJump")
onready var player_walljump: = character.get_node("WallJump")
onready var player_dashwalljump: = character.get_node("DashWallJump")
onready var sfx: = $sfx

var timestop_time: float = 10.0
var gravity_factor: float = 1.5
var jump_time: float
var dashjumptime: float
var walljumptime: float
var dashwalljump_time: float
var max_fall_velocity: float


func deactivate() -> void :
	end_time_stop()
	queue_free()

func destroy(enemy) -> void :
	if typeof(enemy) == TYPE_STRING:
		if enemy == "boss":
			go_to_attack_stage(10)

func initialize() -> void :
	Event.connect("normal_door_open", self, "deactivate")
	Event.connect("boss_door_open", self, "deactivate")
	Event.connect("vile_door_open", self, "deactivate")
	Tools.timer(animation_time, "set_stage", self)

func set_stage() -> void :
	attack_stage = 1

func _physics_process(delta: float) -> void :
	delta = GameManager.true_delta
	._physics_process(delta)
	
	if attack_stage == 1:
		start_time_stop()
		animatedSprite.show()
		next_attack_stage()
		
	elif attack_stage == 2:
		if get_tree().paused:
			for source in GameManager.pause_sources:
				if source == "PauseMenu":
					go_to_attack_stage(10)
		timestop_time -= delta
		if timestop_time <= 0:
				go_to_attack_stage(10)
	
	elif attack_stage == 10:
		end_time_stop()
		next_attack_stage()
		EndAbility()

func set_aura_buff() -> void :
	pass




func unset_aura_buff() -> void :
	player_shot.activate()
	player_altshot.activate()
	player_special.activate()

func start_time_stop():
	Engine.time_scale = clamp(2.0 - gravity_factor, 0.25, 1.0)
	character.time_stop_active = true
	backup_original_values()
	player_jump.max_jump_time *= gravity_factor
	player_walljump.max_jump_time *= gravity_factor
	player_dashjump.max_jump_time *= gravity_factor
	player_dashwalljump.max_jump_time *= gravity_factor
	character.maximum_fall_velocity *= clamp(2.0 - gravity_factor, 0.25, 1.0)

func end_time_stop():
	Engine.time_scale = 1.0
	character.time_stop_active = false
	restore_original_values()

func restore_original_values() -> void :
	player_jump.max_jump_time = jump_time
	player_walljump.max_jump_time = walljumptime
	player_dashjump.max_jump_time = dashjumptime
	player_dashwalljump.max_jump_time = dashwalljump_time
	character.maximum_fall_velocity = max_fall_velocity

func backup_original_values() -> void :
	jump_time = player_jump.max_jump_time
	walljumptime = player_walljump.max_jump_time
	dashjumptime = player_dashjump.max_jump_time
	dashwalljump_time = player_dashwalljump.max_jump_time
	max_fall_velocity = character.maximum_fall_velocity
