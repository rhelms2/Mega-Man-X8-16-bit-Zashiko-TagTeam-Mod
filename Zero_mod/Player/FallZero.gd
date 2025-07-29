extends Movement
class_name FallZero

export  var shot_pos_adjust: = Vector2(4, - 5)
onready var land_sound = ""
var dashjump_speed = 260
var upgraded: bool = false
var fall_base_velocity: float = 90

func get_shot_adust_position() -> Vector2:
	return shot_pos_adjust
		
func _ready() -> void :
	pass
	
	
func emit_land_sounds_on_event():
	if active:
		character.listen("land", self, "play_land_sound")

func set_fall_animation():
	character.animatedSprite.animation = "fall"
	changed_animation = true

func play_land_sound():
	if character.listening_to_inputs:
		Log("Playing Land Sound")
		play_sound(land_sound)
		land_sound.play()

func play_animation_on_initialize():
	if animation:
		if character.get_animation() != animation:
			character.play_animation(animation)

func _Update(_delta: float) -> void :
	process_gravity(_delta)
	change_animation_if_falling("fall")
	zero_bonus_horizontal_speed()
	if character.dashfall:
		set_movement_and_direction(dashjump_speed, _delta)
	else:
		set_movement_and_direction(horizontal_velocity, _delta)
	
func _Setup():
	if character.dashjumps_since_jump > 0:
		horizontal_velocity = dashjump_speed
		character.dashjump_signal()
	else:
		horizontal_velocity = fall_base_velocity
	

func _Interrupt() -> void :
	character.dashfall = false
	._Interrupt()
	character.set_horizontal_speed(0)
	character.set_vertical_speed(0)
	zero_bonus_horizontal_speed()

func Initialize() -> void :
	.Initialize()
	jumpcast_timer = 0

func BeforeEveryFrame(delta: float) -> void :
	.BeforeEveryFrame(delta)
	activate_low_jumpcasts_after_delay(delta)
	
func _StartCondition() -> bool:
	if not character.is_on_floor():
		return true
	return false

func _EndCondition() -> bool:
	if character.is_on_floor():
		return true
	return false

