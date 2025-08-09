extends AttackAbility
class_name EnemyShot

export var shot_duration := 1.0
export var shot_animation : String
export var deactivate_shield := true
export var recover_animation : String
export (NodePath) var shot_position
export (PackedScene) var projectile
onready var shot_sound := $shot_sound
var actual_fire_pos := Vector2(0,0)
var shield 

func _ready() -> void:
	actual_fire_pos = get_node(shot_position).position
	if deactivate_shield and character.has_shield():
		shield = character.get_shield()

func _Update(_delta) -> void:
	if attack_stage == 0 and has_finished_last_animation(): #terminou prepare
# warning-ignore:narrowing_conversion
		fire(projectile, actual_fire_pos)
		play_animation(shot_animation)
		shot_sound.play()
		if deactivate_shield:
			deactive_shield()
		next_attack_stage()
		
	if attack_stage ==1 and has_finished_last_animation():
		if timer > shot_duration:
			play_animation(recover_animation)
			next_attack_stage()
			
	if attack_stage ==2 and has_finished_last_animation():
		EndAbility()

func _Interrupt() -> void:
	._Interrupt()
	if deactivate_shield:
		activate_shield()
	
func deactive_shield() -> void:
	if shield != null:
		shield.deactivate()
		
func activate_shield() -> void:
	if shield != null and character.has_health():
		shield.activate()
	
