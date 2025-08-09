extends AttackAbility

var hide_message: bool = false
var start_hiding: bool = false

onready var shield: Node2D = $"../EnemyShield"

var hidden: bool = false

func _ready():
	animatedSprite.connect("animation_finished", self, "_on_animation_finished")

func _Setup() -> void :
	pass
	
func _StartCondition() -> bool:
	if Input.is_action_pressed(actions[0]):
		if character.get_animation() != "shot" and character.get_animation() != "shot_prepare":
			return true
	return false
	
func _on_animation_finished():
	if animatedSprite.animation == "open":
		play_animation_once("idle")
		EndAbility()

func _Update(delta: float) -> void :
	process_gravity(delta)
	
	if not start_hiding:
		if Input.is_action_pressed(actions[0]):
			start_hiding = true
	
	if start_hiding:
		if not Input.is_action_pressed(actions[0]):
			start_hiding = false
			
	if start_hiding:
		if animatedSprite.animation != "defense":
			play_animation_once("defense")
		if not shield.active:
			shield.activate()
		force_movement(0)




	if not start_hiding:
		if animatedSprite.animation != "open":
			play_animation_once("open")
		if shield.active:
			shield.deactivate()



		
		

func _Interrupt() -> void :
	play_animation_once("idle")
	shield.deactivate()
	start_hiding = false
	hide_message = false


