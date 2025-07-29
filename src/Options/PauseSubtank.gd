extends X8TextureButton

export (Resource) var subtank

onready var medidor: TextureProgress = $textureProgress

signal using
signal finished


func on_press() -> void :
	if GameManager.is_player_in_scene():
		if GameManager.player.current_health < GameManager.player.max_health and GameManager.player.get_subtank_current_health(subtank.id) > 0:
			.on_press()
			Event.emit_signal("use_subtank", subtank.id)
			emit_signal("using")
			yield(subtank, "finished_healing")
			emit_signal("finished")

func _process(_delta: float) -> void :
	if visible:
		medidor.value = 18 * inverse_lerp(0, subtank.capacity, get_saved_health())

func get_saved_health() -> int:
	if GlobalVariables.get(subtank.id) != null:
		return GlobalVariables.get(subtank.id)
	return 0
