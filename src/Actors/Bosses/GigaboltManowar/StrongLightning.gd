class_name StrongLightning extends Node2D

const damage: float = 10.0

export  var frames: Array

onready var line_1: Line2D = $line
onready var line_2: Line2D = $line2
onready var lines: Array = [line_1, line_2]
onready var start: AnimatedSprite = $start
onready var joint: AnimatedSprite = $joint
onready var finish: AnimatedSprite = $finish
onready var lower_damage: Area2D = $lower_damage
onready var start_right_raycast: RayCast2D = $start_right_raycast
onready var start_left_raycast: RayCast2D = $start_left_raycast
onready var damage_raycasts: Array = [start_right_raycast, start_left_raycast]
onready var indicator: AnimatedSprite = $indicator
onready var collision: Particles2D = $collision
onready var end: Particles2D = $end
onready var end_2: Particles2D = $end2
onready var warning: AudioStreamPlayer2D = $indicator / warning

var active: bool = false
var damage_duration: float = 0.85
var damage_disabled: bool = false
var damage_list: Array

signal expired(object)


func prepare(warning_duration: float = 0.75) -> void :
	indicator.visible = true
	set_segments_visibility(false)
	var tween = create_tween()
	tween.tween_property(indicator, "modulate:a", 0.0, warning_duration)

func _process(_delta: float) -> void :
	if start.visible:
		for line in lines:
			line.texture = frames[start.frame]

func _physics_process(_delta: float) -> void :
	if active and not damage_disabled:
		for ray in damage_raycasts:
			if ray.is_colliding():
				ray.get_collider().damage(damage, self)
		for obj in damage_list:
			obj.damage(damage, self)

func position_start(start_position: Vector2) -> void :
	var pos = to_local(start_position)
	line_1.points[0] = pos

func position_end(end_position: Vector2) -> void :
	var pos = to_local(end_position)
	line_1.points[1].x = pos.x
	line_2.position = Vector2.ZERO
	line_2.points[0] = line_1.points[1]
	line_2.points[1] = pos
	indicator.position = pos
	warning.play_rp()
	collision.position = pos
	lower_damage.position = line_1.points[1]

func update_joints() -> void :
	joint.position = line_1.points[1]
	start_right_raycast.cast_to = line_1.points[1] + Vector2(5, 0)
	start_left_raycast.cast_to = line_1.points[1] + Vector2( - 5, 0)
	finish.position = line_2.points[1] + line_2.position
	end.position = line_1.points[0].linear_interpolate(line_1.points[1], 0.5)
	end_2.position = line_2.points[0].linear_interpolate(line_2.points[1], 0.5)

func start_lightning() -> void :
	modulate.a = 1
	indicator.visible = false
	collision.emitting = true
	set_segments_visibility(true)
	set_raycasts_activity(true)
	Tools.timer(damage_duration, "fade_out", self)

func fade_out(duration: float = 0.15) -> void :
	end.emitting = true
	end_2.emitting = true
	set_segments_visibility(false)
	set_raycasts_activity(false)
	Tools.timer(duration, "expire", self)

func expire() -> void :
	emit_signal("expired", self)
	Tools.timer(2, "queue_free", self)

func set_raycasts_activity(toggle: bool) -> void :
	active = toggle
	for r in damage_raycasts:
		r.enabled = toggle

func set_segments_visibility(toggle: bool) -> void :
	var elements = [start, line_1, joint, line_2, finish]
	for part in elements:
		part.visible = toggle

func _on_lower_damage_body_entered(body: Node) -> void :
	damage_list.append(body)

func _on_lower_damage_body_exited(body: Node) -> void :
	damage_list.erase(body)
