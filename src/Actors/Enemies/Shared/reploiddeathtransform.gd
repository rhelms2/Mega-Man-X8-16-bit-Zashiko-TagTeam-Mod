extends AnimatedSprite

onready var animated_sprite: AnimatedSprite = get_parent().get_parent().get_node("animatedSprite")

func activate() -> void:
	animated_sprite.modulate.a = 0.01
	playing = true
	visible = true
	$transform.play()
	get_parent().get_parent().connect("death",self,"_on_death")

func _on_EnemyDeath_ability_start(_ability) -> void:
	activate()

func _on_death() -> void:
	visible = false
