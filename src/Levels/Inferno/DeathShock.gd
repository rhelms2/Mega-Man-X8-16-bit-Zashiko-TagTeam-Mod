extends Node2D

const alt_palette: Texture = preload("res://src/Levels/Inferno/shock_palette.png")

export  var alternate_palette: bool = false

onready var death_plane: Area2D = $death_plane
onready var shock_3: AnimatedSprite = $shock3
onready var shock_2: AnimatedSprite = $shock2
onready var shock: AnimatedSprite = $shock
onready var lamp: AnimatedSprite = $start
onready var lamp2: AnimatedSprite = $finish
onready var attractor: KinematicBody2D = $Lamp2
onready var attractor2: KinematicBody2D = $Lamp
onready var sublight: Light2D = get_node_or_null("sublight")

var active: bool = true

signal disabled


func _ready() -> void :
	Event.connect("pitch_black_energized", self, "deactivate")
	if alternate_palette:
		lamp.material.set_shader_param("palette", alt_palette)
		lamp2.material.set_shader_param("palette", alt_palette)
		shock.material.set_shader_param("palette", alt_palette)
		shock_2.material.set_shader_param("palette", alt_palette)
		shock_3.material.set_shader_param("palette", alt_palette)

func _on_Lamp_disabled() -> void :
	if active:
		deactivate()

func deactivate() -> void :
	active = false
	death_plane.deactivate()
	shock.visible = false
	shock_2.visible = false
	shock_3.visible = false
	attractor.set_collision_layer_bit(21, false)
	attractor2.set_collision_layer_bit(21, false)
	lamp.playing = false
	lamp.frame = 1
	lamp2.playing = false
	lamp2.frame = 1
	if sublight != null:
		sublight.visible = false
	emit_signal("disabled")
