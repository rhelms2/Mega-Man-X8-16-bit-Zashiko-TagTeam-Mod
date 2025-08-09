extends GenericIntro

var devilbear : Node2D
onready var space: Node = $"../Space"
onready var tween := TweenController.new(self,false)
onready var traverse: AudioStreamPlayer2D = $traverse

func connect_start_events() -> void:
	Event.listen("boss_door_open",self,"prepare_for_intro")
	Event.listen("vile_eject",self,"_on_vile_eject")
	prepare_for_intro()
	
func prepare_for_intro() -> void:
	animatedSprite.visible = false
	
func _on_vile_eject(_devilbear : Node2D) -> void:
	devilbear = _devilbear
	ExecuteOnce()
	
func _Setup() -> void:
	space.call_deferred("define_arena")
	reposition_and_go_up()
	turn_and_face_player()
	animatedSprite.visible = true
	play_animation("flight")
	
func _Update(delta) -> void:
	if attack_stage == 0 and timer > 2.5:
		EndAbility()
	
func _Interrupt():
	character.emit_signal("intro_concluded")
	
func reposition_and_go_up() -> void:
	character.global_position = devilbear.global_position
	character.global_position.y -= 32.0
	tween.create(Tween.EASE_OUT, Tween.TRANS_QUAD)
	tween.add_method("set_vertical_speed",-60,0, 1.5,character)
	tween.add_callback("show_health")
	traverse.play()

func show_health():
	Event.emit_signal("boss_health_appear", character)
