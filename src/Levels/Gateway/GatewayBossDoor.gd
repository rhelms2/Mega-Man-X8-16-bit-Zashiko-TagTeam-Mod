extends NewDoor

export  var close_after_freeway: bool = true

onready var close_state: Node2D = $Close
onready var free_state: Node2D = $Freeway

signal starting_freeway
signal waiting_freeway
signal closing_freeway


func open() -> void :
	close_state.EndAbility()
	Tools.timer(4, "_on_signal", free_state)

func _on_Freeway_start(ability_name) -> void :
	emit_signal("starting_freeway")

func _on_Freeway_wait() -> void :
	emit_signal("waiting_freeway")

func _on_Freeway_stop(ability_name) -> void :
	emit_signal("closing_freeway")
