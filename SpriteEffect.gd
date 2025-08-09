extends Sprite
class_name SpriteEffect

export var max_duration := 0.0
export var animation_speed := 40.0
export var one_shot := false
export var horizontal_flip_chance := 0.0
export var vertical_flip_chance := 0.0
export var copy_rotation := false
var actual_particle := false
var emitter : Node2D
var _anim_speed := 0.0
var _one_shot := false
var current_frame := 0.0
var emitting := false
var timer := 0.0
var _particle

 
signal emit
 
signal finished_animation
 
signal max_time_reached
 
signal destroyed


func emit(scale_x := 1):
	timer = 0.0
	_particle = duplicate()
	_particle.actual_particle = true
	_particle.emitter = self
	_particle._one_shot = one_shot
	_particle._anim_speed = animation_speed
	_particle.current_frame = 0
	_particle.transform = global_transform
	if scale_x < 0:
		position.x = position.x * scale_x
		_particle.transform = global_transform
		position.x = position.x * scale_x
	_particle.scale.x = scale_x
	get_tree().current_scene.add_child(_particle)
	_particle.visible = true
	
	var sound = _particle.get_children()
	if sound.size() > 0:
		if sound[0] is AudioStreamPlayer2D:
			sound[0].play()
		
	
	if horizontal_flip_chance > 0:
		_particle.flip_h = rand_range(0.0,1.0) <= horizontal_flip_chance
			
	if vertical_flip_chance > 0:
		var rng = rand_range(0.0,1.0)
		_particle.flip_v = rng <= vertical_flip_chance
	
	if copy_rotation:
		_particle.rotation_degrees = rotation_degrees
	
	emitter_signal("emit")
	return _particle


func _physics_process(delta: float) -> void:
	if _anim_speed > 0.99:
		timer += delta
		process_frames(delta)
		if emitting:
			emit()
			emitting = false
		if max_duration > 0 and timer > max_duration:
			emitter_signal("max_time_reached")
			destroy()

func process_frames(delta:float) -> void:
	current_frame += delta * _anim_speed
	if current_frame >= vframes * hframes:
		if _one_shot:
			#print("Destroyin Particle")
			destroy()
		emitter_signal("finished_animation")
		current_frame = 0
	frame = int(floor(current_frame))

func emitter_signal(signal_name : String):
	if is_instance_valid(emitter):
		emitter.emit_signal(signal_name)

func stop_emission():
	emitting = false
	if actual_particle:
		destroy()

func destroy():
	emitter_signal("destroyed")
	queue_free()
