extends ZeroBlocking

onready var secret_camera_limit: = $"../../Limits/ZeroWeaponLimit"
onready var enemy_mechanoloid: = $"../../Enemies/EnemyMechaniloid"


func _ready() -> void :
	if active:
		enemy_mechanoloid.connect("zero_health", self, "_on_block_event")

func block_wall() -> void :
	pass

func _on_block_event() -> void :
	secret_camera_limit.disabled = false
	blocking_wall.set_deferred("disabled", true)
