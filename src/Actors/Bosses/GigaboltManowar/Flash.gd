extends BambooSlash

var activation_time: float = 0.74


func _ready() -> void:
	animated_sprite.frame = 0
	Tools.timer(activation_time, "activate",self)

func activate(duration := 0.1) -> void:
	animated_sprite.visible = false
	$bolt.play()
	$line.visible = true
	$line.scale.y = 1.5
	slash_hitbox.activate()
	var tween = create_tween()
	tween.tween_property($line,"scale:y",0.0,duration)
	Tools.timer(0.5,"queue_free",self)
