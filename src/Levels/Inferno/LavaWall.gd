extends Node2D

const lava: Resource = preload("res://src/Levels/Inferno/lava_base.tres")
const lava_corner: Resource = preload("res://src/Levels/Inferno/lava_corner.tres")
const lava_fall: Resource = preload("res://src/Levels/Inferno/lava_fall1.tres")
const lava_fall2: Resource = preload("res://src/Levels/Inferno/lava_fall2.tres")
const lava_fall3: Resource = preload("res://src/Levels/Inferno/lava_fall3.tres")

export  var speed: float = 50.0
export  var ice_palette: Texture
export  var ice_platform: PackedScene

onready var visuals: Node2D = $Visuals
onready var collision: TileMap = $tileMap
onready var death_zone: Area2D = $DeathZone
onready var tilemap: TileMap = $Visuals / tileMap

var actual_speed: = 0.0
var frozen: bool = false
var times_hit: int = 0
var tween
var vtween

signal frozen


func _ready() -> void :
	unpause_tileset()
	Tools.timer(3, "_on_DeathZone_freeze", self)
	tilemap.material.set_shader_param("palette", null)
	visible = false

func unpause_tileset() -> void :
	lava.set_pause(false)
	lava_corner.set_pause(false)
	lava_fall.set_pause(false)
	lava_fall2.set_pause(false)
	lava_fall3.set_pause(false)

func pause_tileset() -> void :
	lava.set_pause(true)
	lava_corner.set_pause(true)
	lava_fall.set_pause(true)
	lava_fall2.set_pause(true)
	lava_fall3.set_pause(true)

func activate() -> void :
	tween = create_tween()
	tween.tween_property(self, "actual_speed", speed, 2)
	for particle in get_children():
		if "emitting" in particle:
			particle.emitting = true

func slowdown(projectile) -> void :
	if not frozen:
		if is_higher(projectile):
			var platform = ice_platform.instance()
			var correct_position = projectile.global_position
			correct_position.y = global_position.y
			call_deferred("add_child", platform)
			connect("frozen", platform, "break_platform")
			platform.set_deferred("global_position", correct_position)
		elif not is_finished():
			if actual_speed > 0:
				times_hit += 1
				if times_hit > 10:
					_on_DeathZone_freeze()
					return
				actual_speed = actual_speed * 0.75
				tween.kill()
				tween = create_tween()
				tween.tween_property(self, "actual_speed", speed, 2)
				flash(0.1)

func is_higher(projectile) -> bool:
	return projectile.global_position.y <= global_position.y + 16

func _physics_process(delta: float) -> void :
	if not frozen and not is_finished():
		global_position.x += actual_speed * delta

func is_finished() -> bool:
	return global_position.x > 6815

func _on_DeathZone_freeze() -> void :
	if actual_speed > 0:
		frozen = true
		emit_signal("frozen")
		pause_tileset()
		for particle in get_children():
			if "emitting" in particle:
				particle.emitting = false
			elif "playing" in particle:
				particle.playing = false
			elif "energy" in particle:
				particle.color = Color.aqua
				particle.energy = 0.25
		tilemap.material.set_shader_param("palette", ice_palette)
		collision.call_deferred("set_collision_layer_bit", 0, true)
		death_zone.active = false
		$freeze.play()
		$Visuals / polygon2D.color = Color("109cce")
		flash()

func flash(duration: float = 1.0):
	if vtween:
		vtween.kill()
	vtween = create_tween()
	visuals.modulate = Color(12, 2, 2, 1)
	vtween.tween_property(visuals, "modulate", Color(1, 1, 1, 1), duration)

func _on_BossDoor2_finish() -> void :
	queue_free()
