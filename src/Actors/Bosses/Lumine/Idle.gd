extends BossIdle
onready var space: Node = $"../Space"
onready var tween := TweenController.new(self,false)
onready var stage := AbilityStage.new(self,false)
#onready var boss_ai: Node2D = $"../BossAI"
const movespeed := Vector2(240,-80)
onready var rotating_crystals: Node2D = $"../RotatingCrystals"
onready var after_images: Node = $"../animatedSprite/afterImages"
var first_use := true

func _Setup() -> void:
	if not first_use:
		rotating_crystals.expand_crystals()
	after_images.activate()
	turn_and_face_player()
	go_to_closest_position()
	stage.reset()
	first_use = false

func go_to_closest_position() -> void:
	var pos = space.get_center()
	var time_to_return = space.time_to_position(pos,80)
	tween.create(Tween.EASE_IN_OUT,Tween.TRANS_SINE)
	tween.add_attribute("global_position",pos,time_to_return,character)
	tween.add_callback("next", stage)

func _Update(_delta) -> void:
	update_flying_animation()
	if get_player_direction_relative() != get_facing_direction():
		turn_and_face_player()
		play_turn_animation()
	if stage.currently_is(1):
		var flyspeed := Vector2(movespeed.x * -get_facing_direction(), movespeed.y)
		tween.method(    "set_horizontal_speed",0.0,         flyspeed.x/1.5,1.0)
		tween.add_method("set_horizontal_speed", flyspeed.x/2,-flyspeed.x,2.0)
		tween.add_method("set_horizontal_speed",-flyspeed.x, flyspeed.x * 1.25,2.0)
		tween.add_method("set_horizontal_speed", flyspeed.x,-flyspeed.x,2.0)
		tween.add_method("set_horizontal_speed",-flyspeed.x, flyspeed.x * 1.25,2.0)
		tween.add_method("set_horizontal_speed", flyspeed.x,-flyspeed.x,2.0)
		tween.add_method("set_horizontal_speed",-flyspeed.x, flyspeed.x * 1.25,2.0)
		tween.add_method("set_horizontal_speed", flyspeed.x,-flyspeed.x,2.0)
		tween.add_method("set_horizontal_speed",-flyspeed.x,        0.0,1.0)
		
		tween.method("set_vertical_speed",0.0,flyspeed.y*1.25,.75)
		tween.add_method("set_vertical_speed",flyspeed.y,-flyspeed.y*2.0,1.20)
		tween.add_method("set_vertical_speed",-flyspeed.y*2.0,flyspeed.y*2.0,1.20)
		tween.add_method("set_vertical_speed",flyspeed.y*2.0,-flyspeed.y*2.0,1.20)
		tween.add_method("set_vertical_speed",-flyspeed.y*2.0,flyspeed.y*2.0,1.20)
		tween.add_method("set_vertical_speed",flyspeed.y*2.0,-flyspeed.y*2.0,1.20)
		tween.add_method("set_vertical_speed",-flyspeed.y*2.0,flyspeed.y*2.0,1.20)
		tween.add_method("set_vertical_speed",flyspeed.y*2.0,-flyspeed.y*2.0,1.20)
		tween.add_method("set_vertical_speed",-flyspeed.y*2.0,flyspeed.y*2.0,1.20)
		tween.add_method("set_vertical_speed",flyspeed.y*2.0,0.0,.5)
		stage.next()

func play_turn_animation():
	print_debug("Detected turn")
	play_animation_again("turn_up")
	
	pass

func update_flying_animation():
	#if get_vertical_speed() < 0:
	#	play_animation_once("fly_up")
	#elif get_vertical_speed() > 0:
	#	play_animation_once("fly_down")
	pass
	
func _Interrupt():
	tween.reset()
	after_images.deactivate()
	pass

func _StartCondition() -> bool:
	return boss_ai.active and character.animatedSprite.visible

func get_player_direction_relative() -> int:
	if GameManager.get_player_position().x > character.global_position.x:
		return(1)
	else:
		return(-1)

func play_animation_again(anim : String):
	.play_animation(anim)
	current_animation = anim
	finished_animation = ""
