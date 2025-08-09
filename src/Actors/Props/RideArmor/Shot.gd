extends NewAbility

export var projectile : PackedScene

const move := -12.0

onready var shot_position: Node2D = $shot_position

onready var physics = Physics.new(get_parent())
onready var tween = TweenController.new(self)

onready var near_arm: AnimatedSprite = $"../animatedSprite/near_arm"
onready var torso: AnimatedSprite = $"../animatedSprite/torso"
onready var back: AnimatedSprite = $"../animatedSprite/back"
onready var far_arm: AnimatedSprite = $"../animatedSprite/far_arm"
onready var cannon: AnimatedSprite = $"../animatedSprite/cannon"
onready var pieces = [torso,far_arm,back,cannon,near_arm]
onready var shot: AudioStreamPlayer2D = $shot
onready var fire: Sprite = $fire

func _Setup() -> void:
	shot.play_rp()
	setup_procedural_animation()
	shot()
	fire.emit()
	if physics.get_vertical_speed() > 0:
		physics.set_vertical_speed(0)
	return_pieces_to_original_position()

func setup_procedural_animation() -> void:
	near_arm.position.x = move * -0.25
	torso.position.x = move * 0.15
	back.position.x = move * 0.35
	far_arm.position.x = move * 0.35
	cannon.position.x = move 

func return_pieces_to_original_position() -> void:
	for piece in pieces:
		tween.create()
		tween.set_ease_out()
		tween.add_method("round_position", piece.position.x, 0, 0.75,self,[piece])
		tween.set_sequential()
		tween.add_callback("EndAbility")

func round_position(pos,piece) -> void:
	piece.position.x = round(pos)

# warning-ignore:function_conflicts_variable
func shot() -> void:
	instantiate(projectile)

func instantiate(scene : PackedScene) -> Node2D:
	var instance = scene.instance()
	get_tree().current_scene.add_child(instance,true)
	instance.set_global_position(shot_position.global_position) 
	instance.set_creator(character)
	instance.initialize(character.get_facing_direction())
	return instance

func _on_new_direction(dir) -> void:
	scale.x = dir
	pass # Replace with function body.
