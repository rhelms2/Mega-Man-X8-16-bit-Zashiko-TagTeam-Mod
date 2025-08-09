extends EventAbility 
class_name KingCrabIntro 

export var skip_intro := true
var intro_stage := -1
var grounded_position := -96.0
onready var sprite := $"../animatedSprite"
onready var jump := $jump
onready var land := $land
onready var eyeFlash := $eyeFlash

func _ready() -> void:
	if active and not skip_intro:
		sprite.visible = false
	Event.connect("noahspark_cutscene_end",self,"enter_scene")


func _Setup() -> void:
	Event.emit_signal("noahspark_cutscene_start")

func enter_scene():
	turn_and_face_player()
	sprite.position.y = -300
	sprite.visible = true
	intro_stage = 0
	Event.emit_signal("screenshake",2)
	jump.play()
	

func _Update(delta) -> void:
	if intro_stage == 0 and timer > 1.35:
		sprite.position.y += 550 * delta
		if sprite.position.y > grounded_position:
			sprite.position.y = grounded_position
			play_animation("land")
			land.play()
			Event.emit_signal("screenshake",2)
			Event.emit_signal("kingcrab_crash")
			Event.emit_signal("play_boss_music")
			next_intro_stage()
	
	elif intro_stage == 1 and timer > 2.0: #hardcodado
		play_animation("intro")
		eyeFlash.play()
		next_intro_stage()

	elif intro_stage == 2 and timer > 1:
		Event.emit_signal("boss_health_appear", character)
		next_intro_stage()
		
	elif intro_stage == 3 and timer > 1:
		character.emit_signal("intro_concluded")
		Event.emit_signal("boss_start", character)
		GameManager.end_cutscene()
		EndAbility()
		
func _EndCondition() -> bool:
	return false

func next_intro_stage():
	intro_stage += 1
	timer = 0

func intro_skip() -> void:
	Event.emit_signal("play_boss_music")
	Event.emit_signal("boss_health_appear", character)
	character.emit_signal("intro_concluded")
	Event.emit_signal("boss_start", character)
	GameManager.end_cutscene()
	EndAbility()
	

func turn_and_face_player():
	set_direction( get_player_direction_relative() )

func face_away_from_player() -> void:
	set_direction( -get_player_direction_relative() )

func get_player_direction_relative() -> int:
	if GameManager.get_player_position().x > character.global_position.x:
		return(1)
	else:
		return(-1)
