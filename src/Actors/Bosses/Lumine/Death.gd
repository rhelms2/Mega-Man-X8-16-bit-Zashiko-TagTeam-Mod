extends BossDeath

export var lumine_sprites : Resource
onready var flash: Sprite = $"../flash"
onready var transform_Sfx: AudioStreamPlayer2D = $"../transform"

func _Setup() -> void:
	if character.animatedSprite.frames != lumine_sprites:
		character.animatedSprite.frames = lumine_sprites
		character.animatedSprite.call_deferred("play",death_animation)
		flash.start()
		transform_Sfx.play()
	character.play_animation(death_animation)
		
	Event.emit_signal("lumine_death")
	character.set_horizontal_speed(0)
	character.set_vertical_speed(0)
	Event.emit_signal("enemy_kill","boss")
	GameManager.start_end_cutscene()
	sprite.playing = false
	touch_damage.active = false
	elapsed_explosion_time = 0.0
	background.scale.x = 100
	background.scale.y = 40 
	GameManager.pause(character.name + name)
	freeze_moment = OS.get_ticks_msec()

func _Interrupt():
	get_parent().queue_free()
	
var alpha_delay := 0.0
func end_explosion(_delta):
	background.scale.x = 400
	background.scale.y = 160 
	explosions.emitting = false
	sprite.visible = false
	reploid.visible = false
	if death_transformed:
		#alpha_delay += _delta * 2
		background_alpha -= _delta/5.2
		set_background_alpha(background_alpha)

var death_transformed := false

func _on_death_transform_finished() -> void:
	character.emit_signal("death")
	death_transformed = true
