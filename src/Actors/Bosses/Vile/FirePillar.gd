extends GenericProjectile
onready var firepillar_sprite: AnimatedSprite = $firepillarSprite
onready var damager_long: Node2D = $DamagerLong
onready var damager_end: Node2D = $DamagerEnd
onready var rise: AudioStreamPlayer2D = $rise
onready var end: AudioStreamPlayer2D = $end
onready var start: AudioStreamPlayer2D = $start
onready var fall: AudioStreamPlayer2D = $fall

var hit_wall := false

func _Setup() -> void:
	facing_direction = -facing_direction 
	scale.x = facing_direction
	set_horizontal_speed(40 * facing_direction)

func _Update(_delta) -> void:
	if not hit_wall and not animatedSprite.visible and is_on_wall():
		hit_wall = true
		go_to_attack_stage(3)
	
	if attack_stage == 0:
		if is_on_floor():
			animatedSprite.visible = false
			firepillar_sprite.visible = true
			firepillar_sprite.frame = 0
			start.play()
			set_horizontal_speed(75 * facing_direction)
			next_attack_stage()
	
	elif attack_stage == 1:
		if firepillar_sprite.frame >= 3 and firepillar_sprite.frame < 17:
			damager_long.activate()
			rise.play()
			next_attack_stage()
	
	elif attack_stage == 2:
		if firepillar_sprite.frame >= 17:
			fall.play()
			damager_long.deactivate()
			previous_attack_stage()
			
	elif attack_stage == 3 and timer > 0.1:
		end.play()
		firepillar_sprite.play("end")
		damager_long.deactivate()
		damager_end.activate()
		next_attack_stage()
		
	elif attack_stage == 4 and timer > 0.5:
		damager_end.deactivate()
		disable_damage()
		next_attack_stage()
	
	elif attack_stage == 5 and timer > 0.5:
		destroy()
