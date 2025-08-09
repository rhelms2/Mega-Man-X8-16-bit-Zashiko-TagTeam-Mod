extends AnimatedSprite

var _range := Vector2(-28.0, -6.0) #_range.x = -28.0
var crystal_position := Vector2.ZERO
var distance_factor := 1.0 #1.0 is normal, #30.0 is close to body
var current_speed := 1.0
onready var tween := TweenController.new(self,false)
onready var tween_speed := TweenController.new(self,false)
onready var tween_range := TweenController.new(self,false)
onready var tween_y := TweenController.new(self,false)
onready var ring := get_parent()
onready var trail: Line2D = $node/trail
var timer := 0.0
var contracting := false

signal visibled
signal hidden


func _physics_process(delta: float) -> void:
	rotation_degrees = -ring.rotation_degrees
	position.x = crystal_position.x / distance_factor
	if tween_speed.is_valid():
		tween.get_last().set_speed_scale(current_speed)
		tween_y.reset()

func speed_up(new_speed_scale := 3.0) -> void:
	#current_speed = new_speed_scale
	tween_speed.attribute("current_speed",new_speed_scale)

func expand() -> void:
	contracting = false
	Tools.timer(0.5,"make_visible",self)
	tween_range.reset()
	tween_range.create(Tween.EASE_OUT,Tween.TRANS_CUBIC)
	tween_range.add_attribute("distance_factor", 1.0, 1.0)

func contract() -> void:
	contracting = true
	tween_range.reset()
	tween_range.create(Tween.EASE_IN,Tween.TRANS_SINE)
	tween_range.add_attribute("distance_factor", 30.0, 1.0)
	Tools.timer(0.5,"make_invisible",self)

func make_visible() -> void:
	visible = true
	trail.visible = true
	emit_signal("visibled")

func make_invisible() -> void:
	visible = false
	trail.visible = false
	emit_signal("hidden")
	
func circle_around() -> void:
	tween.create()
	tween.get_last().set_loops()
	tween.set_ease(Tween.EASE_OUT,Tween.TRANS_CUBIC)
	tween.add_callback("send_to_back")
	tween.add_attribute("crystal_position:x", _range.x, 0.5)
	tween.set_ease(Tween.EASE_IN_OUT,Tween.TRANS_CUBIC)
	tween.add_attribute("crystal_position:x", -_range.x, 1.0)
	tween.add_callback("bring_to_front")
	tween.set_ease(Tween.EASE_IN,Tween.TRANS_CUBIC)
	tween.add_attribute("crystal_position:x", 0.0, 0.5)
	#generates an error when the scene is exited, ignoring it for now

func send_to_back() -> void:
	tween_y.attribute("z_index", -5.0, 0.5)
	tween_y.get_last().set_speed_scale(current_speed)
	tween_y.attribute("position:y", _range.y, 0.9)
	tween_y.get_last().set_speed_scale(current_speed)
	
func bring_to_front() -> void:
	if contracting:
		return
	tween_y.attribute("z_index", 5.0, 0.5)
	tween_y.get_last().set_speed_scale(current_speed)
	tween_y.attribute("position:y", -_range.y, 0.9)
	tween_y.get_last().set_speed_scale(current_speed)
