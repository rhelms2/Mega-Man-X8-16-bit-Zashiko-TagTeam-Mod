extends EnemyTransformed

onready var rotate_and_shoot = get_node("RotateAndShoot")

func _ready() -> void :
	direction.x = 1

func _physics_process(_delta: float) -> void :
	if _player != null:
		if _player.global_position.x != self.global_position.x:
			_player.global_position.x = self.global_position.x
		if _player.global_position.y != self.global_position.y:
			_player.global_position.y = self.global_position.y

	if not rotate_and_shoot.executing:
		if Input.is_action_pressed("fire"):
			rotate_and_shoot.ExecuteOnce()

func spawner_set_direction(dir: int, _update: = false) -> void :
	pass

func set_direction(dir: int, update: = false):
	pass

func get_facing_direction():
	pass

func update_facing_direction():
	pass

func interrupt_all_moves():
	for move in executing_moves:
		move.EndAbility()

func get_action_pressed(action) -> bool:
	if listening_to_inputs:
		return Input.is_action_pressed(action)
	return false

func crush() -> void :
	pass

func process_zero_health():
	pass

func _on_zero_health_hide_things() -> void :
	pass

func direct_hit(value) -> void :
	pass

func on_external_event() -> void :
	pass

func got_combo_hit(inflicter) -> void :
	pass

func _on_GravityPassage_opened() -> void :
	pass
