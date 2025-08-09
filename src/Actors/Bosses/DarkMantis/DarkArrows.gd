extends AttackAbility
export var projectiles : Array

var proj_speed := Vector2(15, -520)
onready var arrowshot: AudioStreamPlayer2D = $arrowshot

func _Setup() -> void:
	._Setup()
	proj_speed = Vector2(15, -520)

func _Update(_delta) -> void:
	if attack_stage == 0 and has_finished_last_animation():
		create_arrows()
		play_animation_once("throw_1")
		next_attack_stage_on_next_frame()
	
	elif attack_stage == 1 and has_finished_last_animation() and timer > 0.25:
		create_arrows()
		play_animation_once("throw_2")
		next_attack_stage_on_next_frame()
	
	elif attack_stage == 2 and has_finished_last_animation() and timer > 0.25:
		play_animation_once("throw_end")
		if has_finished_last_animation():
			play_animation_once("idle")
			EndAbility()

func create_arrows() -> void:
	arrowshot.play()
	var i = 0
	while i < 3:
		var _p = instantiate_projectile(projectiles[0])
		i += 1

func instantiate_projectile(scene : PackedScene) -> Node2D:
	var distance = abs(get_distance_to_player())
	if distance < 200:
		distance = 200
	var projectile = instantiate(scene) 
	projectile.set_creator(self)
	projectile.speed = proj_speed
	proj_speed = Vector2(proj_speed.x + distance/3.4, proj_speed.y +5)
	projectile.initialize(character.get_facing_direction())
	
	return projectile
