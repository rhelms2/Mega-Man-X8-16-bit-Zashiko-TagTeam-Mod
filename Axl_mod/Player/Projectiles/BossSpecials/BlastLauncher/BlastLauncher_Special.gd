extends SpecialAbilityAxl

onready var player_damage: = character.get_node("Damage")
onready var player_lifesteal: = character.get_node("LifeSteal")
onready var player_dashwalljump: = character.get_node("DashWallJump")
onready var player_dash: = character.get_node("Dash")
onready var player_dashjump: = character.get_node("DashJump")
onready var player_airdash: = character.get_node("AirDash")
onready var player_hover: = character.get_node("Hover")
onready var sfx: = $sfx

var lifesteal_active: bool = false
var lifesteal_should_decay: bool = false

var aura_time: float = 8.0
var heal_time: float = 1.0
var heal_timer: float = 0.0
var sfx_timer: float = 0.0
var sfx_time: float = 0.13


func deactivate() -> void :
	unset_aura_buff()
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
		set_aura_buff()
		animatedSprite.show()
		next_attack_stage()
		
	elif attack_stage == 2:
		sfx_timer -= delta
		if sfx_timer <= 0:
			sfx_timer = sfx_time
			sfx.play()
		heal_timer += delta
		if heal_timer >= heal_time:
			heal_timer = 0
			player_lifesteal.heal(2)
		aura_time -= delta
		if aura_time <= 0:
				go_to_attack_stage(10)
	
	elif attack_stage == 10:
		unset_aura_buff()
		next_attack_stage()
		EndAbility()

func set_aura_buff() -> void :
	lifesteal_active = player_lifesteal.active
	lifesteal_should_decay = player_lifesteal.should_decay
	
	
	player_lifesteal.should_decay = false
	
	player_dashwalljump.deactivate()
	player_dash.deactivate()
	player_dashjump.deactivate()
	player_airdash.deactivate()
	player_hover.deactivate()
	character.should_die_to_spikes = false

func unset_aura_buff() -> void :
	player_lifesteal.should_decay = lifesteal_should_decay
	if not lifesteal_active:
		player_lifesteal.deactivate()
	player_dashwalljump.activate()
	player_dash.activate()
	player_dashjump.activate()
	player_airdash.activate()
	player_hover.activate()
	character.should_die_to_spikes = true
