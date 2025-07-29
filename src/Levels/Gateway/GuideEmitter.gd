extends Node

const guide_particle: PackedScene = preload("res://src/Levels/Gateway/GuidePaticle.tscn")

onready var door: StaticBody2D = $"../../Door"

var emitting: bool = false

signal reached_door


func _ready() -> void :
	Event.connect("gateway_capsule_teleport", self, "_on_Door_open")
	Event.connect("gateway_full_reset", self, "stop_emitting")
	Event.connect("gateway_skip", self, "stop_emitting")

func _on_BossWatcher_ready_for_battle() -> void :
	emitting = true
	Tools.timer(0.5, "emit", self)

func emit() -> void :
	if emitting:
		var particle = guide_particle.instance()
		particle._destination = door
		particle.global_position = GameManager.get_player_position()
		particle.global_position.x += 16
		connect("reached_door", particle, "end")
		get_tree().current_scene.call_deferred("add_child", particle)
		Tools.timer(2, "emit", self)

func _on_Door_open() -> void :
	emitting = false
	emit_signal("reached_door")

func stop_emitting() -> void :
	emitting = false
	for child in get_children():
		if child is Timer:
			child.queue_free()
