extends AttackAbility
class_name KingCrabArmShot

export (PackedScene) var Projectile
var missileclaw : Node2D
onready var prepare: AudioStreamPlayer2D = $prepare
onready var shot: AudioStreamPlayer2D = $shot
onready var receive: AudioStreamPlayer2D = $receive
onready var nhecosound: AudioStreamPlayer2D = $nhecosound
var played_first := false


func _Setup() -> void:
	attack_stage = 0
	prepare.play()
	if character.get_facing_direction() < 0 and position.x > 0:
		position.x = -position.x

func _Update(_delta) -> void:
	if attack_stage == 0:
		if animatedSprite.frame == 7 and not played_first:
			nhecosound.play()
			played_first = true
		elif animatedSprite.frame == 14 and played_first:
			nhecosound.play(0)
			played_first = false
		if has_finished_last_animation():
			missileclaw = instantiate(Projectile) 
			missileclaw.set_creator(self)
			missileclaw.initialize(character.get_facing_direction())
			Event.emit_signal("screenshake",2)
			shot.play()
			play_animation("missileclaw_fire")
			next_attack_stage()
	
	elif attack_stage == 1:
		if timer > 1:
			if GameManager.is_nearby(self,missileclaw,Vector2(16,16)):
				missileclaw.destroy()
				receive.play()
				next_attack_stage()
		
	elif attack_stage == 2:
		play_animation_once("missileclaw_recover")
		Event.emit_signal("screenshake",2)
		next_attack_stage()
	elif attack_stage == 3:
		if has_finished_last_animation():
			EndAbility()
