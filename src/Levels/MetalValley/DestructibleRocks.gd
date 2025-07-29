extends Node2D
onready var blocked_entrance: = $blockedEntrance / collisionShape2D2
onready var explosion: Particles2D = $"EnemyDeath/Explosion Particles"
onready var audio: AudioStreamPlayer2D = $EnemyDeath / audioStreamPlayer2D
onready var remains: Particles2D = $EnemyDeath / remains_particles
onready var tile_map: TileMap = $tileMap

var mecha_nearby: = false
var sprite: AnimatedSprite
var active: = true

func _ready() -> void :
	set_physics_process(false)

func _physics_process(delta: float) -> void :
	if mecha_nearby:
		if sprite.animation == "punch_loop":
			explode()

func _on_punchDetector_area_entered(area: Area2D) -> void :
	if active:
		set_physics_process(true)
		mecha_nearby = true
		sprite = area.get_parent().get_parent().get_parent().get_node("animatedSprite")

func _on_punchDetector_area_exited(area: Area2D) -> void :
	mecha_nearby = false
	set_physics_process(false)
	
func explode() -> void :
	active = false
	tile_map.visible = false
	blocked_entrance.disabled = true
	explosion.emitting = true
	remains.emitting = true
	set_physics_process(false)

