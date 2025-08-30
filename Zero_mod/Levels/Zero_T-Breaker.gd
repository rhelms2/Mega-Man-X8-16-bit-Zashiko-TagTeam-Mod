extends ZeroBlocking

onready var tbreaker: = $"T-Breaker"

func _ready() -> void :
	if active:
		Event.connect("stage_rotate", self, "_on_block_event")
		Event.connect("moved_player_to_checkpoint", self, "checkpoint_check")
		blocking_wall.set_deferred("disabled", true)
	else:
		blocking_wall.set_deferred("disabled", false)

	if block_if_collected:
		if collectible in GameManager.collectibles:
			blocking_wall.set_deferred("disabled", false)
			
	if character_name != "":
		if CharacterManager.current_player_character != character_name:
			blocking_wall.set_deferred("disabled", false)

func block_wall() -> void :
	pass

func checkpoint_check(checkpoint: CheckpointSettings) -> void :
	if checkpoint.id > 0:
		_on_block_event()

func _on_block_event() -> void :
	print("Stage is rotated")
	blocking_wall.set_deferred("disabled", false)
	if is_instance_valid(tbreaker):
		tbreaker.queue_free()
