extends Object
class_name TweenController

var tween_list: Array
var owner: Node


func _init(_owner, connect: bool = true) -> void :
	owner = _owner
	if connect:
		connect_reset()

func connect_reset(end_signal: String = "stop") -> void :
	owner.connect(end_signal, self, "reset")

func create(ease_type: = Tween.EASE_IN_OUT, trans_type: = Tween.TRANS_LINEAR, parallel: = false, loops: = 1) -> void :
	var tween: = owner.create_tween()
	tween.set_ease(ease_type).set_trans(trans_type).set_parallel(parallel).set_loops(loops)
	tween_list.append(tween)

func set_loops(value: = - 1) -> void :
	get_last().set_loops(value)

func set_ease(ease_type: = Tween.EASE_IN_OUT, trans_type: = Tween.TRANS_LINEAR) -> void :
	get_last().set_ease(ease_type).set_trans(trans_type)

func attribute(attribute: String, final_value = 1.0, duration: = 0.25, object = owner) -> void :
	var tween: = owner.create_tween()
	tween.tween_property(object, attribute, final_value, duration)
	tween_list.append(tween)

func method(method: String, initial_value: = 0.0, final_value: = 1.0, duration: = 0.25, object = owner) -> void :
	var tween: = owner.create_tween()
	tween.tween_method(object, method, initial_value, final_value, duration)
	tween_list.append(tween)

func callback(method: String, delay: = 1.0, object = owner, binds = []) -> void :
	var tween: = owner.create_tween()
	tween.tween_callback(object, method, binds).set_delay(delay)
	tween_list.append(tween)

func add_callback(method: String, object = owner, binds = []) -> void :
	get_last().tween_callback(object, method, binds)

func add_attribute(attribute: String, final_value = 1.0, duration: = 0.25, object = owner) -> void :
	get_last().tween_property(object, attribute, final_value, duration)

func add_method(method: String, initial_value: = 0.0, final_value: = 1.0, duration: = 0.25, object = owner, binds = []) -> void :
	get_last().tween_method(object, method, initial_value, final_value, duration, binds)

func add_wait(wait_duration: = 0.25) -> void :
	get_last().tween_interval(wait_duration)

func end_ability() -> void :
	set_sequential()
	add_callback("EndAbility", owner)

func set_ease_out() -> void :

	get_last().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)

func set_sequential() -> void :
	get_last().set_parallel(false)

func set_parallel() -> void :
	get_last().set_parallel(true)

func set_ignore_pause_mode() -> void :
	get_last().set_pause_mode(SceneTreeTween.TWEEN_PAUSE_PROCESS)

func get_last() -> SceneTreeTween:
	return tween_list.back()

func pause() -> void :
	for tween in tween_list:
		if tween.is_valid():
			tween.pause()

func unpause() -> void :
	for tween in tween_list:
		if tween.is_valid():
			tween.play()

func reset(_discard = null) -> void :
	for tween in tween_list:
		if tween.is_valid():
			tween.kill()

func end() -> void :
	for tween in tween_list:
		if tween.is_valid():
			tween.custom_step(10000.0)

func custom_step(step) -> void :
	get_last().custom_step(step)

func is_valid() -> bool:
	for tween in tween_list:
		if tween.is_valid():
			return true
	return false
