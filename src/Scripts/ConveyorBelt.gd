extends Area2D

export  var active: = true
export  var speed: = 70.0
var affected_entities: Array
var affected_groups = ["Player", "Enemies", "Item", "Props", "Movable"]

func _ready() -> void :
	connect("body_entered", self, "_on_area2D_body_entered")
	connect("body_exited", self, "_on_area2D_body_exited")

func _on_area2D_body_entered(body: Node) -> void :
	if active:
		for type in affected_groups:
			if not body in affected_entities:
				if body.is_in_group(type):
					body.add_conveyor_belt_speed(speed)
					affected_entities.append(body)

func _on_area2D_body_exited(body: Node) -> void :
	if active:
		for type in affected_groups:
			if body in affected_entities:
				if body.is_in_group(type):
					body.reduce_conveyor_belt_speed(speed)
					affected_entities.erase(body)
				
