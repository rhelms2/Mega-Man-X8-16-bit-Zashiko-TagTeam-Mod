extends SimplePlayerProjectile
onready var flash: AnimatedSprite = $flash
var enabled_damage: = false

func _ready() -> void :
	disable_damage()
	
func _Setup() -> void :
	flash.playing = true

func _Update(_delta: float) -> void :
	if flash.frame > 0 and not animatedSprite.playing:
		enable_visuals()
		play_lightning_visual()
	if animatedSprite.frame > 11:
		destroy()
			
	elif animatedSprite.frame > 2 and not enabled_damage:
		enable_damage()
	elif animatedSprite.frame > 4 and enabled_damage:
		disable_damage()

func play_lightning_visual() -> void :
	randomize_visual()
	animatedSprite.playing = true
	animatedSprite.frame = 0

func randomize_visual() -> void :
	var rng = randf()
	if Tools.is_between(rng, 0.0, 0.25):
		animatedSprite.flip_h = true
		
	elif Tools.is_between(rng, 0.25, 0.5):
		animatedSprite.flip_v = true
		
	elif Tools.is_between(rng, 0.5, 0.75):
		animatedSprite.flip_h = true
		animatedSprite.flip_v = true

func enable_damage() -> void :
	.enable_damage()
	enabled_damage = true
	
func _OnHit(_target_remaining_HP) -> void :
	pass

func _OnDeflect() -> void :
	pass

func connect_disable_unneeded_object() -> void :
	pass
