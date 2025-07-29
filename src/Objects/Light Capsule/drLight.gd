extends AnimatedSprite

func _ready() -> void :
	Event.listen("capsule_open", self, "start")
	Event.listen("character_talking", self, "talk")
	Event.listen("stopped_talking", self, "idle")
	Event.listen("capsule_dialogue_end", self, "vanish")

	connect("animation_finished", self, "finish_intro")

func finish_intro() -> void :
	if animation == "appear":
		play("idle")

func start() -> void :
	if GameManager.get_player_position().x > global_position.x:
		scale.x = - 1
	play("appear")

func talk(_character_talking) -> void :
	play("talk")

func idle(_character_talking) -> void :
	play("idle")

func vanish() -> void :
	play("vanish")
