extends AttackAbility
onready var shield_behaviour: Node2D = $"../EnemyShield"
onready var flying_shield: AnimatedSprite = $"../animatedSprite/flying_shield"
onready var break_vfx: AnimatedSprite = $"../animatedSprite/break_vfx"
var tween : SceneTreeTween
export var travel_time := 1.5

func _ready() -> void:
	flying_shield.visible = false
	pass

func _Setup() -> void:
	attack_stage = 0
	flying_shield.visible = true
	shield_behaviour.deactivate()
	break_vfx.frame = 0
	shield_throw()

func shield_throw() -> void:
	tween = get_tree().create_tween()
	tween.tween_property(flying_shield,"position", Vector2(0,-jump_velocity),travel_time/2).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)# warning-ignore:return_value_discarded
	tween.tween_property(flying_shield,"position", Vector2(0,0),travel_time/2).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_SINE)# warning-ignore:return_value_discarded
	tween.tween_callback(self,"catch_shield")# warning-ignore:return_value_discarded

func catch_shield() -> void:
	if character.has_health():
		shield_behaviour.activate()
		flying_shield.visible = false
		play_animation_once("catch")
		go_to_attack_stage(1)

func _Update(_delta: float) -> void:
	process_gravity(_delta)
	if attack_stage == 1 and has_finished_last_animation():
		EndAbility()

func _Interrupt() -> void:
	if tween.is_valid():
		tween.kill()
	flying_shield.visible = false

func _on_EnemyShield_guard_broken(projectile) -> void:
	if executing:
		play_animation("stun")
		_Setup()
		pass
	pass # Replace with function body.
