extends EventAbility
class_name CharacterSwitchWarpIn


export  var beam_speed: = 460.0
export  var enable_movement: = true
var descending: = false
onready var animatedSprite = get_parent().get_node("animatedSprite")
onready var beam_sound = get_node("audioStreamPlayer")


func _ready() -> void :
	animatedSprite.connect("animation_finished", self, "on_animation_finished")

func _Setup():
	#print("Setting up characterwarpin animation node")
	character.deactivate()
	descending = true
	animatedSprite.position.y = position.y - 160
	beam_sound.play()

func _Update(_delta):
	#print("updating warpin animation node")
	if descending:
		if animatedSprite.global_position.y < character.global_position.y - 8:
			animatedSprite.global_position.y += beam_speed * _delta
			#print("beam pos: " + str(animatedSprite.global_position.y))
		elif animatedSprite.global_position.y >= character.global_position.y:
			play_animation_once("beam_in")
			descending = false
		else:
			animatedSprite.position.y = - 4
			#if not at_correct_height():
			#	character.move_y(beam_speed * _delta)
			#else:
			play_animation_once("beam_in")
			descending = false
	else:
		#print("descending false")
		pass

func on_animation_finished():
	if executing:
		#print("executing true in characterwarpin animation node")
		if character.get_animation() == "beam_in":
			#Event.emit_signal("x_appear")
			Event.emit_signal("character_switch_end")
			EndAbility()

func _Interrupt():
	if enable_movement:
		character.activate()
		#Event.emit_signal("gameplay_start")

func _EndCondition() -> bool:
	return false

func is_high_priority() -> bool:
	return true

func is_colliding_with_wall(wallcheck_distance: = 8, vertical_correction: = 8) -> int:
	if raycast(Vector2(global_position.x + wallcheck_distance, global_position.y + vertical_correction)):
		return 1
	elif raycast(Vector2(global_position.x - wallcheck_distance, global_position.y + vertical_correction)):
		return - 1
	
	return 0
	
func at_correct_height() -> bool:
	var ground_y = get_ground_height()
	if global_position.y + 16 <= ground_y:
		return false
	else:
		character.set_y(ground_y - 15)
		return true

func get_ground_height() -> float:
	var intersection = (raycast(Vector2(global_position.x, global_position.y + 1000)).position.y)
	return intersection

func raycast(target_position: Vector2) -> Dictionary:
	var space_state = get_world_2d().direct_space_state
	return space_state.intersect_ray(global_position, target_position, [self], character.collision_mask)
