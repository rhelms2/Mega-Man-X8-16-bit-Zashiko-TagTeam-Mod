extends Node2D

onready var sprite = $kinematicBody2D.get_node("animatedSprite")
onready var path = $path2D.get_node("pathFollow2D")
onready var kinematic_body = $kinematicBody2D
var reparented: = false


func _ready() -> void :
	$animationPlayer.play("New Anim")
	Event.listen("stage_rotate", self, "change_sprite_parent")
	Event.listen("land", self, "undo_sprite_parent")
	Event.listen("cutscene_start", self, "pause")
	Event.listen("cutscene_over", self, "start")

func pause():
	$animationPlayer.stop(false)

func start():
	$animationPlayer.play("New Anim")

func change_sprite_parent():
	if not reparented:
		kinematic_body.remove_child(sprite)
		path.add_child(sprite)
		reparented = true

func undo_sprite_parent():
	if reparented:
		path.remove_child(sprite)
		kinematic_body.add_child(sprite)
		reparented = false
