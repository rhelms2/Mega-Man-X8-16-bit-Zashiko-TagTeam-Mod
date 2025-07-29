extends Node2D

onready var light: Light2D = $light

var light_enabled: bool = false
var light_strength: float = 0.5
var light_color: Color = Color.white
var light_size: Vector2 = Vector2(1, 1)
var light_randomize: bool = false
var light_random_light: Vector2 = Vector2(0.9, 1.5)
var light_random_width: Vector2 = Vector2(0.9, 1.5)
var light_random_height: Vector2 = Vector2(0.9, 1.5)


func _ready() -> void :
	self.playing = true
	if light_enabled:
		set_physics_process(light_enabled)
		light.enabled = true
	else:
		set_physics_process(false)
		light.enabled = false

func _on_animatedSprite_animation_finished() -> void :
	queue_free()

func _physics_process(_delta: float) -> void :
	if light_enabled:
		if light_randomize:
			light.light(light_strength * rand_range(light_random_light.x, light_random_light.y), 
			Vector2(light_size.x * rand_range(light_random_width.x, light_random_width.y), 
			light_size.y * rand_range(light_random_height.x, light_random_height.y)), light_color)
		else:
			light.light(light_strength, light_size, light_color)
	else:
		set_physics_process(false)
		light.enabled = false
