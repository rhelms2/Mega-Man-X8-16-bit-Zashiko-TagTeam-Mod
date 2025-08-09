extends GenericIntro
onready var tween := TweenController.new(self,false)
onready var damage: Node2D = $"../DamageOnTouch"

func prepare_for_intro() -> void:
	Log("Preparing for Intro")
	reset_sprite_to_top()
	make_invisible()

var beam_in_resets := 0.15
var reset_sprite_pos := -160

func beam_in():
	make_visible()
	play_animation("idle")
	tween.create()
	tween.set_sequential()
	while beam_in_resets > 0.0:
		tween.add_attribute("position:y",0.0,0.05 + beam_in_resets,animatedSprite)
		tween.add_callback("reset_sprite_to_top")
		beam_in_resets -= .01
		#print(reset_sprite_pos)
	tween.add_attribute("position:y",0.0,0.01,animatedSprite)
	tween.callback("next_attack_stage")

func reset_sprite_to_top():
	animatedSprite.position.y = reset_sprite_pos
	reset_sprite_pos += 11
	reset_sprite_pos = clamp(reset_sprite_pos,-160,-1)

func _Update(delta):
	process_gravity(delta)
	if attack_stage == 0:
		turn_player_towards_boss()
		damage.activate()
		beam_in()
		next_attack_stage()
		
	elif attack_stage == 2 and timer > 1:
		start_dialog_or_go_to_attack_stage(4)
	
	elif attack_stage == 3:
		if seen_dialog():
			next_attack_stage()

	elif attack_stage == 4 and timer > .5:
		play_animation("appear")
		Event.emit_signal("play_boss_music")
		next_attack_stage()

	elif attack_stage == 5 and has_finished_last_animation():
		play_animation("appear_loop")
		next_attack_stage()
	
	elif attack_stage == 6 and timer > 1:
		play_animation("appear_end")
		Event.emit_signal("boss_health_appear", character)
		next_attack_stage()

	elif attack_stage == 7 and timer > 1:
		play_animation("idle")
		EndAbility()

func _ready() -> void:
	Event.listen("character_talking",self,"talk")
	prepare_for_intro()

func talk(character):
	if character == "Sigma":
		play_animation_once("talk")
	else:
		play_animation_once("idle")
