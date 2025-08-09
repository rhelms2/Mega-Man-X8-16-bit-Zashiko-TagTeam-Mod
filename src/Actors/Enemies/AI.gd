extends Node2D
class_name AI

export var active := true

export var on_enter_screen : Array
export var on_exit_screen : Array
export var on_idle : Array
export var on_see_player : Array
export var on_touch_player : Array
export var on_damage_on_touch_player : Array
export var on_get_hit : Array
export var on_shield_hit : Array
export var on_guard_break : Array
export var on_death : Array
export var on_hit_wall : Array
export var on_external_event : Array

var _on_enter_screen : Array
var _on_exit_screen : Array
var _on_idle : Array
var _on_see_player : Array
var _on_touch_player : Array
var _on_damage_on_touch_player : Array
var _on_get_hit : Array
var _on_shield_hit : Array
var _on_guard_break : Array
var _on_death : Array
var _on_hit_wall : Array
var _on_external_event : Array

onready var visibility := $"../visibilityNotifier2D"
onready var vision = $vision
onready var character = get_parent()
var current_direction := 1
var target

var timer := 0.0
onready var animated_sprite: AnimatedSprite = $"../animatedSprite"

func populate_nodes() -> void:
	populate_list(on_enter_screen,_on_enter_screen)
	populate_list(on_exit_screen,_on_exit_screen)
	populate_list(on_idle,_on_idle)
	populate_list(on_see_player,_on_see_player)
	populate_list(on_touch_player,_on_touch_player)
	populate_list(on_damage_on_touch_player,_on_damage_on_touch_player)
	populate_list(on_get_hit,_on_get_hit)
	populate_list(on_shield_hit,_on_shield_hit)
	populate_list(on_guard_break,_on_guard_break)
	populate_list(on_death,_on_death)
	populate_list(on_hit_wall,_on_hit_wall)
	populate_list(on_external_event,_on_external_event)

func populate_list(path_list,node_list) -> void:
	for path in path_list:
		node_list.append(get_node(path))

func _ready() -> void:
	Event.listen("door_transition_start",self,"deactivate")
	Event.listen("door_transition_end",self,"activate")
	character.listen("guard_break",self,"on_guard_broken")
	character.listen("zero_health",self,"on_zero_health")
	character.listen("external_event",self,"on_external_event_heard")
	character.listen("got_hit",self,"on_got_hit")
	character.listen("shield_hit",self,"on_shield_been_hit")
	character.listen("damage_target", self, "on_damage_on_touch_target")
	visibility.connect("screen_entered",self,"on_screen_entered")# warning-ignore:return_value_discarded
	visibility.connect("screen_exited",self,"on_screen_exited")  # warning-ignore:return_value_discarded
	
	populate_nodes()
	
	if on_touch_player.size() > 0:
		# warning-ignore:return_value_discarded
		$"../DamageOnTouch".connect("touch_target", self, "on_touch_target")

func on_external_event_heard() -> void:
	if active:
		print_debug(character.name +": heard external event.")
		activate_ability(_on_external_event)

func on_screen_exited() -> void:
	#animated_sprite.visible = false
	if active:
		activate_ability(_on_exit_screen)

func on_screen_entered() -> void:
	if active:
		#animated_sprite.visible = true
		activate_ability(_on_enter_screen)

func on_got_hit() -> void:
	if active:
		activate_ability(_on_get_hit)

func on_shield_been_hit() -> void:
	if active:
		activate_ability(_on_shield_hit)

func activate() -> void:
	active = true
	set_physics_process(true)

func deactivate() -> void:
	character.interrupt_all_moves()
	active = false
	set_physics_process(false)

func on_zero_health() -> void:
	if active:
		deactivate() 
		activate_ability(_on_death)


func _physics_process(_delta: float) -> void:
	if active:
		timer += _delta
		handle_direction() #is this necessary?
		handle_vision_ability_calls()
		on_wallhit_activate_ability() 
		handle_idle_ability_calls()
		if not animated_sprite.visible and GameManager.precise_is_on_screen(character.global_position):
			#push_error("Error, on camera but not visible: " + get_parent().name)
			animated_sprite.visible = true

func handle_not_onscreen_calls() -> void:
	activate_ability(_on_exit_screen)

func on_touch_target() -> void:
	if active:
		activate_ability(_on_touch_player)

func on_damage_on_touch_target() -> void:
	if active:
		activate_ability(_on_damage_on_touch_player)

func on_guard_broken() -> void:
	if active:
		activate_ability(_on_guard_break)

func handle_idle_ability_calls() -> void:
	if _on_idle.size() > 0:
		if character.executing_moves.size() == 0:
			activate_ability(_on_idle)
		elif character.executing_moves.size() == 1 and character.executing_moves[0].name == "DamageOnTouch":
			activate_ability(_on_idle) #TODO: refactor DamageOnTouch

func handle_vision_ability_calls() -> void:
	if _on_see_player.size() > 0:
		if is_instance_valid(target) and target.listening_to_inputs: #target is inside vision box
			if GameManager.precise_is_on_screen(character.global_position):
				activate_ability(_on_see_player)

func handle_direction() -> void:
	if character.get_direction() != current_direction:
		current_direction = character.get_direction()
		vision.scale.x = vision.scale.x * -1

func on_wallhit_activate_ability() -> void:
	if is_colliding_with_wall(20) != 0:
		if character.get_facing_direction() == is_colliding_with_wall(20):
			activate_ability(_on_hit_wall)

func activate_ability(list : Array):
	if not character.has_health() or not character.active:
		return
	if list.size() > 0:
		for ability in list:
			if ability == null:
				push_error("List without abilities in " + get_parent().name)
			
			#var ability_node = get_node(ability)
			elif not ability.executing:
				if ability.Should_Execute() and ability._StartCondition():
					ability.ExecuteOnce()
			
			#talvez seja util no futuro:
			#get_node(ability).connect("ability_end",self,"attack_ended")


func stop_abilities(list : Array):
	if list.size() > 0:
		for ability in list:
			character.force_end(ability.name)

func _on_vision_body_entered(player: Node) -> void:
	if player.is_in_group("Props"):
		target = player.get_parent()
	elif player.is_in_group("Player"):
		if player.get_character().is_executing("Ride"):
			return
		target = player.get_parent()
		
		#activate_ability(on_see_player)

func _on_vision_body_exited(player: Node) -> void:
	if target == player.get_parent():
		target = null

func is_to_the_right(body):
	return body.global_position.x > global_position.x

func is_facing_right():
	return character.get_facing_direction() == 1

func is_facing(body):
	return is_facing_right() and is_to_the_right(body) or\
		not is_facing_right() and not is_to_the_right(body)

func is_colliding_with_wall(wallcheck_distance := 8) -> int:
	return character.is_colliding_with_wall(wallcheck_distance)

func append_behaviour_to_on_enter_screen_event(_nodepath : String) -> void:
	on_enter_screen.append(_nodepath)
	if visibility.is_on_screen():
		activate_ability(_on_enter_screen)
	
	
