extends Node2D


onready var character = get_parent()
onready var animatedSprite = character.get_node("animatedSprite")
onready var current_weapon = character.get_node("Shot").current_weapon
onready var x_offset = character.get_node("offset manager").x_offset
onready var y_offset = character.get_node("offset manager").y_offset
onready var extra_x_offset = character.get_node("offset manager").extra_x_offset
onready var extra_y_offset = character.get_node("offset manager").extra_y_offset
onready var weapon_x_offset = 0
onready var weapon_y_offset = 0


var current_frame = 2
var exclusive_ground_animations = [
	"walk_start", 
	"walk", 
	"idle", 
	"weak", 
	"recover", 
]
var exclusive_air_animations = [
	"jump", 
	"fall", 
	"walljump", 
	"hover", 
]
var exclusive_wall_animations = [
	"slide", 
]


func check_for_allowed_animations():
	match character.get_animation():
		"shot":
			return true
		"shot_air":
			return true
		"shot_slide":
			return true

func set_frame_to_direction():
	var key_left = Input.is_action_pressed("left_emulated")
	var key_right = Input.is_action_pressed("right_emulated")
	var key_up = Input.is_action_pressed("up_emulated")
	var key_down = Input.is_action_pressed("down_emulated")
	
	
	var move_left = key_left
	var move_right = key_right
	var move_up = key_up
	var move_down = key_down
	
	if not move_left and not move_right and not move_up and not move_down:
		current_frame = 2;
	elif (move_left or move_right) and not move_up and not move_down:
		current_frame = 2;
	elif move_up and not move_left and not move_right:
		current_frame = 0;
	elif move_up and (move_left or move_right):
		current_frame = 1;
	elif move_down and (move_left or move_right):
		current_frame = 3;
	elif move_down and not move_left and not move_right:
		current_frame = 4;

func update_sprite_direction():
	var _animation = character.get_animation()
	
	if _animation in exclusive_ground_animations:
		if _animation != "shot":
			character.play_animation("shot")
			animatedSprite.set_frame(2)
	elif _animation in exclusive_air_animations:
		if _animation != "shot_air":
			character.play_animation("shot_air")
			animatedSprite.set_frame(2)
	elif _animation in exclusive_wall_animations:
		if _animation != "shot_slide":
			character.play_animation("shot_slide")
			animatedSprite.set_frame(2)
			
	if check_for_allowed_animations():
		set_frame_to_direction()
	
		animatedSprite.set_frame(current_frame)

func projectile_speed_control(_projectile, _speed, horizontal_dir, vertical_dir):
	var _animation = character.get_animation()
	character.get_node("offset manager").get_offset()
	x_offset = character.get_node("offset manager").x_offset
	y_offset = character.get_node("offset manager").y_offset
	extra_x_offset = character.get_node("offset manager").extra_x_offset
	extra_y_offset = character.get_node("offset manager").extra_y_offset
	
	if current_weapon != null:
		weapon_offsets()
	
	var new_position = Vector2(0, 0)
	var x_position = 0
	var y_position = 0
	
	match current_frame:
		0:
			_projectile.horizontal_velocity = 0
			_projectile.vertical_velocity = _speed * vertical_dir
			_projectile.get_node("animatedSprite").rotation = deg2rad(horizontal_dir * - 90)
			if _animation == "shot":
				x_position = 2
				y_position = - 34
			if _animation == "shot_air":
				x_position = 4
				y_position = - 40
			if _animation == "shot_slide":
				x_position = 4
				y_position = - 39
		1:
			var dir = character.get_facing_direction()
			_projectile.horizontal_velocity = ((_speed / 3) * 2) * horizontal_dir
			_projectile.vertical_velocity = ((_speed / 3) * 2) * vertical_dir
			if dir > 0:
				_projectile.get_node("animatedSprite").rotation = deg2rad( - 45)
			else:
				_projectile.get_node("animatedSprite").rotation = deg2rad(45)
			if _animation == "shot":
				x_position = 24
				y_position = - 28
			if _animation == "shot_air":
				x_position = 24
				y_position = - 34
			if _animation == "shot_slide":
				x_position = 26
				y_position = - 32
		2:
			_projectile.horizontal_velocity = _speed * horizontal_dir
			_projectile.vertical_velocity = 0
			if _animation == "shot":
				x_position = 34
				y_position = - 8
			if _animation == "shot_air":
				x_position = 34
				y_position = - 15
			if _animation == "shot_slide":
				x_position = 36
				y_position = - 13
		3:
			var dir = character.get_facing_direction()
			_projectile.horizontal_velocity = ((_speed / 3) * 2) * horizontal_dir
			_projectile.vertical_velocity = ((_speed / 3) * 2) * vertical_dir
			if dir > 0:
				_projectile.get_node("animatedSprite").rotation = deg2rad(45)
			else:
				_projectile.get_node("animatedSprite").rotation = deg2rad( - 45)
			if _animation == "shot":
				x_position = 29
				y_position = 13
			if _animation == "shot_air":
				x_position = 29
				y_position = 6
			if _animation == "shot_slide":
				x_position = 31
				y_position = 8
		4:
			_projectile.horizontal_velocity = 0
			_projectile.vertical_velocity = _speed * vertical_dir
			_projectile.get_node("animatedSprite").rotation = deg2rad(horizontal_dir * 90)
			if _animation == "shot":
				x_position = 10
				y_position = 26
			if _animation == "shot_air":
				x_position = 12
				y_position = 19
			if _animation == "shot_slide":
				x_position = 14
				y_position = 23
	
	var new_x_offset = x_offset
	var new_y_offset = y_offset

	new_position = Vector2(x_position + new_x_offset + weapon_x_offset, y_position + new_y_offset + weapon_y_offset)
	character.shot_position.position = new_position


func weapon_offsets():
	var current_weapon = character.get_node("Shot").current_weapon
	var temp_x_offset = 0
	var temp_y_offset = 0
	if "Pistol" in current_weapon:
		temp_x_offset = 0
		temp_y_offset = 0
	elif "RayGun" in current_weapon.name:
		match current_frame:
			0:
				if character.get_animation() == "shot":
					temp_x_offset = - 1
					temp_y_offset = 7
				elif character.get_animation() == "shot_air":
					temp_x_offset = - 1
					temp_y_offset = 7
				elif character.get_animation() == "shot_slide":
					temp_x_offset = - 1
					temp_y_offset = 8
			1:
				if character.get_animation() == "shot":
					temp_x_offset = - 7
					temp_y_offset = 4
				elif character.get_animation() == "shot_air":
					temp_x_offset = - 7
					temp_y_offset = 4
				elif character.get_animation() == "shot_slide":
					temp_x_offset = - 7
					temp_y_offset = 4
			2:
				if character.get_animation() == "shot":
					temp_x_offset = - 7
					temp_y_offset = - 1
				elif character.get_animation() == "shot_air":
					temp_x_offset = - 7
					temp_y_offset = - 1
				elif character.get_animation() == "shot_slide":
					temp_x_offset = - 7
					temp_y_offset = - 1
			3:
				if character.get_animation() == "shot":
					temp_x_offset = - 4
					temp_y_offset = - 7
				elif character.get_animation() == "shot_air":
					temp_x_offset = - 4
					temp_y_offset = - 6
				elif character.get_animation() == "shot_slide":
					temp_x_offset = - 4
					temp_y_offset = - 6
			4:
				if character.get_animation() == "shot":
					temp_x_offset = 1
					temp_y_offset = - 8
				elif character.get_animation() == "shot_air":
					temp_x_offset = 1
					temp_y_offset = - 8
				elif character.get_animation() == "shot_slide":
					temp_x_offset = 1
					temp_y_offset = - 8
	elif "SpiralMagnum" in current_weapon.name:
		match current_frame:
			0:
				if character.get_animation() == "shot":
					temp_x_offset = - 1
					temp_y_offset = - 1
				elif character.get_animation() == "shot_air":
					temp_x_offset = - 1
					temp_y_offset = - 1
				elif character.get_animation() == "shot_slide":
					temp_x_offset = - 1
					temp_y_offset = 0
			1:
				if character.get_animation() == "shot":
					temp_x_offset = - 2
					temp_y_offset = - 1
				elif character.get_animation() == "shot_air":
					temp_x_offset = - 2
					temp_y_offset = - 1
				elif character.get_animation() == "shot_slide":
					temp_x_offset = - 2
					temp_y_offset = - 1
			2:
				if character.get_animation() == "shot":
					temp_x_offset = 1
					temp_y_offset = - 1
				elif character.get_animation() == "shot_air":
					temp_x_offset = 1
					temp_y_offset = - 1
				elif character.get_animation() == "shot_slide":
					temp_x_offset = 1
					temp_y_offset = - 1
			3:
				if character.get_animation() == "shot":
					temp_x_offset = 1
					temp_y_offset = - 2
				elif character.get_animation() == "shot_air":
					temp_x_offset = 1
					temp_y_offset = - 2
				elif character.get_animation() == "shot_slide":
					temp_x_offset = 1
					temp_y_offset = - 2
			4:
				if character.get_animation() == "shot":
					temp_x_offset = - 3
					temp_y_offset = 0
				elif character.get_animation() == "shot_air":
					temp_x_offset = - 3
					temp_y_offset = 0
				elif character.get_animation() == "shot_slide":
					temp_x_offset = - 3
					temp_y_offset = 0
	elif "PlasmaGun" in current_weapon.name:
		match current_frame:
			0:
				temp_x_offset = - 1
				temp_y_offset = - 5
			1:
				temp_x_offset = 2
				temp_y_offset = - 6
			2:
				temp_x_offset = 5
				temp_y_offset = - 2
			3:
				temp_x_offset = 7
				temp_y_offset = 2
			4:
				temp_x_offset = 2
				temp_y_offset = 4
	elif "BlastLauncher" in current_weapon.name:
		match current_frame:
			0:
				if character.get_animation() == "shot":
					temp_x_offset = 1
					temp_y_offset = - 7
				elif character.get_animation() == "shot_air":
					temp_x_offset = 0
					temp_y_offset = - 9
				elif character.get_animation() == "shot_slide":
					temp_x_offset = 2
					temp_y_offset = - 7
			1:
				if character.get_animation() == "shot":
					temp_x_offset = - 1
					temp_y_offset = 4
				elif character.get_animation() == "shot_air":
					temp_x_offset = - 1
					temp_y_offset = 4
				elif character.get_animation() == "shot_slide":
					temp_x_offset = - 1
					temp_y_offset = 4
			2:
				if character.get_animation() == "shot":
					temp_x_offset = - 3
					temp_y_offset = 4
				elif character.get_animation() == "shot_air":
					temp_x_offset = - 3
					temp_y_offset = 4
				elif character.get_animation() == "shot_slide":
					temp_x_offset = - 3
					temp_y_offset = 4
			3:
				if character.get_animation() == "shot":
					temp_x_offset = - 8
					temp_y_offset = 5
				elif character.get_animation() == "shot_air":
					temp_x_offset = - 8
					temp_y_offset = 5
				elif character.get_animation() == "shot_slide":
					temp_x_offset = - 8
					temp_y_offset = 5
			4:
				if character.get_animation() == "shot":
					temp_x_offset = - 6
					temp_y_offset = 6
				elif character.get_animation() == "shot_air":
					temp_x_offset = - 6
					temp_y_offset = 6
				elif character.get_animation() == "shot_slide":
					temp_x_offset = - 8
					temp_y_offset = 6

	elif "IceGattling" in current_weapon.name:
		match current_frame:
			0:
				if character.get_animation() == "shot":
					temp_x_offset = 2
					temp_y_offset = - 6
				elif character.get_animation() == "shot_air":
					temp_x_offset = 0
					temp_y_offset = - 7
				elif character.get_animation() == "shot_slide":
					temp_x_offset = 3
					temp_y_offset = - 6
				if character.get_facing_direction() < 0:
					temp_x_offset += 1
			1:
				if character.get_animation() == "shot":
					temp_x_offset = - 1
					temp_y_offset = 5
				elif character.get_animation() == "shot_air":
					temp_x_offset = - 1
					temp_y_offset = 5
				elif character.get_animation() == "shot_slide":
					temp_x_offset = - 1
					temp_y_offset = 5
				if character.get_facing_direction() < 0:
					temp_x_offset += 1
					temp_y_offset += 1
			2:
				if character.get_animation() == "shot":
					temp_x_offset = - 3
					temp_y_offset = 6
				elif character.get_animation() == "shot_air":
					temp_x_offset = - 3
					temp_y_offset = 6
				elif character.get_animation() == "shot_slide":
					temp_x_offset = - 3
					temp_y_offset = 6
				if character.get_facing_direction() < 0:
					temp_y_offset += 1
			3:
				if character.get_animation() == "shot":
					temp_x_offset = - 9
					temp_y_offset = 6
				elif character.get_animation() == "shot_air":
					temp_x_offset = - 9
					temp_y_offset = 6
				elif character.get_animation() == "shot_slide":
					temp_x_offset = - 9
					temp_y_offset = 6
				if character.get_facing_direction() < 0:
					temp_x_offset -= 1
					temp_y_offset += 1
			4:
				if character.get_animation() == "shot":
					temp_x_offset = - 6
					temp_y_offset = 7
				elif character.get_animation() == "shot_air":
					temp_x_offset = - 8
					temp_y_offset = 7
				elif character.get_animation() == "shot_slide":
					temp_x_offset = - 8
					temp_y_offset = 5
				if character.get_facing_direction() < 0:
					temp_x_offset -= 1
	elif "FlameBurner" in current_weapon.name:
		match current_frame:
			0:
				if character.get_animation() == "shot":
					temp_x_offset = 4
					temp_y_offset = - 11
				elif character.get_animation() == "shot_air":
					temp_x_offset = 4
					temp_y_offset = - 11
				elif character.get_animation() == "shot_slide":
					temp_x_offset = 4
					temp_y_offset = - 11
			1:
				if character.get_animation() == "shot":
					temp_x_offset = 4
					temp_y_offset = 2
				elif character.get_animation() == "shot_air":
					temp_x_offset = 4
					temp_y_offset = 2
				elif character.get_animation() == "shot_slide":
					temp_x_offset = 4
					temp_y_offset = 2
			2:
				if character.get_animation() == "shot":
					temp_x_offset = 2
					temp_y_offset = 7
				elif character.get_animation() == "shot_air":
					temp_x_offset = 2
					temp_y_offset = 7
				elif character.get_animation() == "shot_slide":
					temp_x_offset = 2
					temp_y_offset = 7
			3:
				if character.get_animation() == "shot":
					temp_x_offset = - 7
					temp_y_offset = 9
				elif character.get_animation() == "shot_air":
					temp_x_offset = - 7
					temp_y_offset = 9
				elif character.get_animation() == "shot_slide":
					temp_x_offset = - 7
					temp_y_offset = 9
			4:
				if character.get_animation() == "shot":
					temp_x_offset = - 7
					temp_y_offset = 11
				elif character.get_animation() == "shot_air":
					temp_x_offset = - 9
					temp_y_offset = 11
				elif character.get_animation() == "shot_slide":
					temp_x_offset = - 9
					temp_y_offset = 11
	else:
		temp_x_offset = 0
		temp_y_offset = 0
	
	weapon_x_offset = temp_x_offset
	weapon_y_offset = temp_y_offset





		
