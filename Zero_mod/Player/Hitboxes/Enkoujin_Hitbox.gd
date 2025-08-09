extends SaberZeroHitbox
class_name EnkoujinZeroHitbox

onready var light: Light2D = $light

var fading: bool = false
var transparency: float = 0.5
var upward_movement: int = 100
var light_color: Color = Color.orange
var light_range: Vector2 = Vector2(2, 2.5)


func _ready() -> void :
	animatedSprite.connect("animation_finished", self, "_on_animation_finished")
	animatedSprite.playing = true

func set_hitbox(upleft: Vector2, downright: Vector2, hitbox_position: Vector2) -> void :
	var shape = RectangleShape2D.new()
	var size = downright - upleft
	shape.extents = size / 2
	collision_shape.shape = shape
	deflection_shape.shape = shape
	position = hitbox_position + (upleft + downright) / 2

func _physics_process(delta: float) -> void :
	light_range *= 0.98
	light.light(0.4 * rand_range(0.9, 1.1), Vector2(light_range.x * rand_range(0.9, 1.1), light_range.y * rand_range(0.9, 1.3)), light_color)
	timer -= delta
	if timer <= 0:
		queue_free()
	if fading:
		transparency -= delta * 1
		modulate = Color(1, 1, 1, transparency)
		upward_movement = 50
	position.y -= delta * upward_movement

func _on_animation_finished() -> void :
	match animatedSprite.animation:
		"Fire_Big":
			
			animatedSprite.animation = "Fire_Mid"
			fading = true
			deactivate()
		"Fire_Mid":
			
			animatedSprite.animation = "Fire_Small"
