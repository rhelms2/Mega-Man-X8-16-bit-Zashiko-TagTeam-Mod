extends AttackAbility

const lumine_sprites: Resource = preload("res://src/Actors/Bosses/Lumine/lumine.res")

export  var disable_after_usage: bool = false
export  var flip_animation: bool = false
export  var _desperation: NodePath
export  var _collider: NodePath
export  var boss_sprites: SpriteFrames
export  var weakness: String = ""
export  var weaknesses: Array = []

onready var desperation = get_node(_desperation)
onready var transform_collider = get_node(_collider)
onready var tween: TweenController = TweenController.new(self, false)
onready var flash: Sprite = $"../flash"
onready var rotating_crystals: Node2D = $"../RotatingCrystals"
onready var og_collider: CollisionShape2D = $"../collisionShape2D"
onready var transform_sfx: AudioStreamPlayer2D = $"../transform"
onready var damage_area: Area2D = $"../area2D"
onready var damage_og_collider: CollisionShape2D = $"../area2D/collisionShape2D"
onready var damage_transform_collider: CollisionShape2D = damage_area.get_node(transform_collider.name)
onready var damage: Node2D = $"../Damage"
onready var pick: AudioStreamPlayer2D = $"../pick"
onready var start_transform: AudioStreamPlayer2D = $"../start_transform"
onready var boss_stun: Node2D = $"../BossStun"

signal transformed
signal ended_transform


func _ready() -> void :
	desperation.connect("ability_end", self, "on_desperation_end")
	desperation.connect("executed", boss_stun, "deactivate")
	desperation.connect("ready_for_stun", boss_stun, "reactivate")
	desperation.call_deferred("connect_animation_finished_event")

func _Setup() -> void :
	tween.method("set_horizontal_speed", character.get_horizontal_speed(), 0.0, 0.35)
	tween.method("set_vertical_speed", character.get_vertical_speed(), 0.0, 0.35)

func _Update(_delta: float) -> void :
	if attack_stage == 0:
		rotating_crystals.speed_up_crystals()
		next_attack_stage()
		
	elif attack_stage == 1:
		play_animation("select_start")
		pick.play()
		next_attack_stage()
		
	elif attack_stage == 2 and has_finished_last_animation():
		play_animation("select_loop")
		Tools.timer(0.65, "contract_crystals", rotating_crystals)
		next_attack_stage()
		
	elif attack_stage == 3 and timer > 1.2:
		play_animation("transform")
		start_transform.play()
		next_attack_stage()
		
	elif attack_stage == 4 and has_finished_last_animation():
		change_frames(boss_sprites)
		turn_and_face_player()
		setup_new_collider()
		desperation.Initialize()
		desperation._Setup()
		if CharacterManager.game_mode < 3:
			add_weakness()
		emit_signal("transformed")
		next_attack_stage()
		
	elif attack_stage == 5:
		#waiting_for_desperation_to_end
		pass
		
	elif attack_stage == 6:
		unstransform()
		EndAbility()

func unstransform():
	change_frames(lumine_sprites)
	turn_and_face_player()
	return_old_collider()
	remove_weakness()
	play_animation("fly_start")

func on_desperation_end(_discard = null):
	if executing:
		next_attack_stage()

func change_frames(new_frames: Resource) -> void :
	flash.start()
	transform_sfx.play()
	animatedSprite.change_frames(new_frames)
	animatedSprite.modulate = Color(6, 6, 6, 1)
	tween.attribute("modulate", Color.white, 0.8, animatedSprite)
	play_animation("idle")
	if flip_animation:
		animatedSprite.flip_h = not animatedSprite.flip_h

func _Interrupt():
	if animatedSprite.frames != lumine_sprites:
		unstransform()
	emit_signal("ended_transform")
	desperation.EndAbility()
	._Interrupt()
	if disable_after_usage:
		deactivate()

func add_weakness() -> void :
	for weakness in weaknesses:
		damage.add_weakness(weakness)

func remove_weakness() -> void :
	for weakness in weaknesses:
		damage.remove_weakness(weakness)

func setup_new_collider() -> void :
	og_collider.set_deferred("disabled", true)
	damage_og_collider.set_deferred("disabled", true)
	damage_og_collider.visible = false
	damage_transform_collider.set_deferred("disabled", false)
	damage_transform_collider.visible = true
	transform_collider.set_deferred("disabled", false)

func return_old_collider() -> void :
	og_collider.set_deferred("disabled", false)
	damage_og_collider.set_deferred("disabled", false)
	damage_og_collider.visible = true
	damage_transform_collider.set_deferred("disabled", true)
	damage_transform_collider.visible = false
	transform_collider.set_deferred("disabled", true)
