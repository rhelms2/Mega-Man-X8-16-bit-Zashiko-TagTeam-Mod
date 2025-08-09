extends Enemy
export var dir := -1
export var type := "mid"
export var chance := 0.015

func _ready() -> void:
	play_animation(type)
	if randf() < chance:
		activate_rare_visual()
	Tools.timer(0.1,"set_direction_on_ready",self)

func set_direction_on_ready () -> void:
	set_direction(dir)
	update_facing_direction()

func activate_rare_visual() -> void:
	play_animation(str(get_animation() + "r"))
