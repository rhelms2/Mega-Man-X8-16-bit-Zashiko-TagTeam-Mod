extends Actor
class_name AbilityUser

var moveset = []
var executing_moves = []
var last_used_ability : BaseAbility

signal ability_end (ability)

func _ready() -> void:
	update_moveset()

func _physics_process(delta: float) -> void:
	if active:
		if should_process_abilities():
			start_executing_moves()
			process_executing_moves(delta)

func should_process_abilities() -> bool:
	return animatedSprite.visible or not has_health()

func update_moveset():
	for child in get_children():
		if should_add_to_start_moveset(child):
			moveset.append(child)
			child.connect("ability_end",self,"ability_ended")

func should_add_to_start_moveset(element) -> bool:
	if element is BaseAbility:
		if element is Ability:
			if element.actions.has("Event"):
				return false
			else:
				return true
		return false
	
	return false

func start_executing_moves() -> void:
	for move in moveset:
		try_execution(move)

func try_execution(move: BaseAbility, logs := false) -> void:
	if move.active and not move.executing:
		if move._StartCondition() and move.Should_Execute():
			move.ExecuteOnce()
		else:
			if logs:
				print (move.name + ": Can't be executed, false Should_Execute or _StartCondition")
	else:
		if logs:
			print (move.name + ": Can't be executed as it is already in executing_moves")

#Log()
func process_executing_moves(delta: float) -> void:
	for move in executing_moves:
		move.ExecuteEachFrame(delta)
	
func remove_from_executing_list(move: BaseAbility):
	executing_moves.erase(move)
	if not move.conflicts_with_nothing():
		last_used_ability = move

func get_last_used_ability() -> String:
	if last_used_ability == null:
		return ""
	return last_used_ability.name

func get_animation() -> String:
	return animatedSprite.animation

func play_animation(anim :String, frame:= 0) -> void:
	animatedSprite.play(anim)
	animatedSprite.set_frame(frame)

func play_animation_once(anim :String)-> void:
	if not get_animation() == anim:
		animatedSprite.play(anim)
		animatedSprite.set_frame(0)

func play_animation_backwards(anim :String)-> void:
	if not get_animation() == anim:
		animatedSprite.play(anim, true)

func interrupt_all_moves():
	for move in executing_moves:
		move.EndAbility()
	animatedSprite.playing = false # Porque isso esta aqui?

func is_executing(ability :String) -> bool:
	for move in executing_moves:
		if ability == move.name:
			return true
			
	return false
	
func is_executing_either(ability_list : Array) -> bool:
	for move in executing_moves:
		for check_name in ability_list:
			if check_name == move.name:
				return true
			
	return false

func get_executing_abilities() -> Array:
	return executing_moves
func get_executing_abilities_names() -> String:
	var text = ""
	for each in executing_moves:
		text += each.name + ", "
	return text.trim_suffix(", ")

func get_executing_ability(ability :String) -> BaseAbility:
	for move in executing_moves:
		if ability == move.name:
			return move
	return null

func get_ability(ability :String) -> BaseAbility:
	for move in moveset:
		if ability == move.name:
			return move
	return null

func force_execute(forced_ability : String) -> void:
	for move in moveset:
		if move.name == forced_ability:
			move.ExecuteOnce()
			return
	print_debug(name + ": Trying to execute non existent ability: " + forced_ability)

func force_end(forced_ability : String) -> void:
	for move in moveset:
		if move.name == forced_ability:
			move.EndAbility()
			return
	print_debug(name + ": Trying to end non existent ability: " + forced_ability)

func ability_ended(ability):
	emit_signal("ability_end", ability)
	
