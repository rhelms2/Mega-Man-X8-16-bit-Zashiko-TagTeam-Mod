extends NewAbility

onready var physics := Physics.new($"..")
onready var animation := AnimationController.new($"../animatedSprite", self)
onready var stage := AbilityStage.new(self)
onready var tween := TweenController.new(self)
onready var flash: Sprite = $"../flash"
const new_death = preload("res://src/Actors/Enemies/Shared/TurnReploidDeath.tscn")
onready var land: AudioStreamPlayer2D = $land
onready var pick: AudioStreamPlayer2D = $pick
onready var start_transform: AudioStreamPlayer2D = $start_transform
onready var transfx: AudioStreamPlayer2D = $transform

func _ready() -> void:
	var boss = character.boss.instance()
	Tools.timer(0.1,"queue_free",self,boss)
	character.visible = false
	character.connect("enter_battle",self,"execute")

func _Setup() -> void:
	character.visible = true
	animation.set_visible(false)
	animation.set_position(Vector2(0,-140))
	physics.turn_and_face_player()

func _Update(_delta) -> void:
	physics.process_gravity(_delta)
	
	if stage.currently_is(0) and timer > character.unique_time:
		animation.set_visible(true)
		animation.play("fall")
		
		descent()
		stage.next()
	
	#attack_stage == 1 is descent
	
	elif stage.currently_is(2):
		animation.play("land")
		land.play_rp(0.5)
		stage.next()

	elif stage.currently_is(3) and timer > 1.5:
		animation.play("transform_start")
		pick.play_rp(0.25)
		stage.next()

	elif stage.currently_is(4) and animation.has_finished_last():
		animation.play("select_loop")
		stage.next()
		
	elif stage.currently_is(5) and timer > 1:
		animation.play("transform")
		start_transform.play_rp(0.3)
		stage.next()

	elif stage.currently_is(6) and animation.has_finished_last():
		animation.set_visible(false)
		spawn_boss()
		flash.start()
		transfx.play()
		stage.next()

func descent():
	tween.create(Tween.EASE_IN, Tween.TRANS_SINE)
	tween.add_attribute("position:y",0.0,.75,$"../animatedSprite")
	tween.add_callback("next",stage)

func spawn_boss():
	var boss : Panda = character.boss.instance()
	var intro = boss.get_node("Intro")
	var achievement = boss.get_node("AchievementHandler")
	var ai = boss.get_node("BossAI")
	var death = boss.get_node("BossDeath")
	death.queue_free()
	achievement.queue_free()
	boss.add_child(new_death.instance(),true)
	boss.spawn_direction = physics.get_player_direction_relative()
	boss.visible = false
	boss.current_health = 120.0
	Tools.timer_p(0.1,"set_visible",boss,true)
	character.emit_signal("spawned_boss",boss)
	Event.emit_signal("gateway_boss_spawned",boss.name.to_lower())
	intro.active = false
	ai.call_deferred("set_physics_process",false)
	ai.desperation_threshold = -1
	character.get_parent().add_child(boss)
	boss.global_position = character.global_position

	if boss.name == "Manowar":
		boss.global_position.y -= 24
		boss.z_index -= 4
		boss.get_node("Space").define_arena()
		
	elif boss.name == "Yeti":
		boss.z_index -= 4
		boss.animatedSprite.modulate = Color(1,1,1,1)

	elif boss.name == "Panda" or boss.name == "Sunflower":
		boss.global_position.y -= 24
		boss.z_index -= 5
		
	elif boss.name == "Mantis":
		boss.global_position.y -= 24
		
	intro.play_animation_once("idle")
	intro.emit_signal("ability_start",intro)
	boss.modulate = Color(5,5,5,1)
	tween.attribute("modulate",Color.white,.75,boss)
	tween.add_callback("EndAbility",intro)
	tween.add_callback("EndAbility")

func _Interrupt() -> void:
	Tools.timer(0.5,"destroy",character)

func _on_new_direction(dir) -> void:
	animation.set_scale_x(dir)
