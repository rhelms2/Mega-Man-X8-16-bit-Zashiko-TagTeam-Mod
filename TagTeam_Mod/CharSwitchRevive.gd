extends Node

const minimum_time_between_recharges: float = 0.2

export var recharge_rate: float = 1.0

onready var character = get_parent()

var active: bool = false

var current_ammo: int = 0
export var max_ammo: int = 36

var timer: float = 0.0
var last_time_hit: float = 0.0


func _ready() -> void :
	set_process(false)
	character.listen("activate_revive", self, "on_activate_revive")
	Event.listen("hit_enemy", self, "recharge")
	Event.listen("enemy_kill", self, "recharge")

func _process(delta: float) -> void :
	timer += delta

func recharge(_d = null):
	if active:
		if current_ammo < max_ammo:
			if timer > last_time_hit + minimum_time_between_recharges:
				last_time_hit = timer
				current_ammo = clamp(current_ammo + 1.0, 0.0, max_ammo)
		elif current_ammo >= max_ammo:
			set_process(false)
			active = false
			current_ammo = 0
			last_time_hit = 0
			timer = 0
			character.current_health = 0
			character.recover_health(2)
			character.emitted_zero_health = false
			CharacterManager.alive_team.append(character.name)
			CharacterManager.both_alive = true


func on_activate_revive() -> void :
	active = true
	set_process(true)
