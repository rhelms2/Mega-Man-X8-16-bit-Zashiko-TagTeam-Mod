extends Node
class_name WeaponChangerZero

export  var active: bool = false

onready var character: Character = get_parent()


func _process(_delta: float) -> void :
	if active and character.is_current_player:
		var _animation = get_parent().get_animation()
		if _animation in character.saber_animations:
			return
		if get_parent().is_executing("Intro") or get_parent().is_executing("Finish"):
			return
		if Input.is_action_just_pressed("weapon_select_left"):
			Event.emit_signal("weapon_select_left")
		elif Input.is_action_just_pressed("weapon_select_right"):
			Event.emit_signal("weapon_select_right")
		
		if Input.is_action_pressed("weapon_select_left") and Input.is_action_just_pressed("weapon_select_right") or Input.is_action_pressed("weapon_select_right") and Input.is_action_just_pressed("weapon_select_left") or Input.is_action_just_pressed("reset_weapon"):
			Event.emit_signal("weapon_select_buster")


