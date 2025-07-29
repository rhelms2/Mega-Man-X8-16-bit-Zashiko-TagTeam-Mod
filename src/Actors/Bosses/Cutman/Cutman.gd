extends Panda

var last_dir = -1
onready var tween := TweenController.new(self,false)

func _ready() -> void:
	pass
	
func set_direction(dir: int, _update := false):
	direction.x = dir
	emit_signal("new_direction", dir)
	#if update:
	#	update_facing_direction()
		
	update_facing_direction()
	if dir != last_dir:
		last_dir = dir
		tween.reset()
		scale.x = 0
		tween.create()
		tween.add_attribute("scale:x",1,.16)

func update_facing_direction():
	if animatedSprite.visible:
		if direction.x < 0:
			facing_right = false;
		elif direction.x >= 0:
			facing_right = true;
		animatedSprite.flip_h = facing_right
