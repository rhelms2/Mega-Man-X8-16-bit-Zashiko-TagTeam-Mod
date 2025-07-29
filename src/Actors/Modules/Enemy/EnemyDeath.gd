extends BaseAbility
class_name EnemyDeath

export  var should_spawn_item: bool = true
export  var should_emit_kill_signal: bool = true
export  var explosion_duration: float = 2.0

onready var explosions: Particles2D = $"Explosion Particles"
onready var sprite: AnimatedSprite = get_parent().get_node("animatedSprite")
onready var death_particle: Particles2D = $"Remains"
onready var audioplayer: AudioStreamPlayer2D = $audioStreamPlayer2D

var times_sound_played: float = 0.0


func _ready() -> void :
	if active:
		character.listen("zero_health", self, "_on_zero_health")
		death_particle.emitting = false
		death_particle.get_node("remains_particles").emitting = false

func particle_cache_check() -> void :
	var checklist = [$"Explosion Particles", $Remains, $Remains.get_node("remains_particles")]
	for item in checklist:
		if item and item.process_material.resource_name == "":
			
			
			
			pass

func _Setup() -> void :
	if explosion_duration == 0:
		audioplayer.play()
	if should_emit_kill_signal:
		Event.emit_signal("enemy_kill", character)
	explosions.emitting = true
	sprite.playing = false
	sprite.material.set_shader_param("Alpha_Blink", 1)
	extra_actions_at_death_start()

func _StartCondition() -> bool:
	return false

func _Update(_delta: float) -> void :
	if timer > times_sound_played / 5 and timer < explosion_duration:
		times_sound_played += 1
		var audio = audioplayer.duplicate()
		add_child(audio)
		audio.pitch_scale = rand_range(0.95, 1.05)
		audio.play()
	if timer > explosion_duration:
		if explosions.emitting:
			spawn_item()
			emit_remains_particles()
			character.emit_signal("death")
			extra_actions_after_death()
			explosions.emitting = false
		sprite.visible = false

func extra_actions_after_death() -> void :
	pass
func extra_actions_at_death_start() -> void :
	pass

func _EndCondition() -> bool:
	return timer > explosion_duration + 1

func spawn_item() -> void :
	if should_spawn_item:
		var item = get_spawn_item()
		if item:
			instance_item(item)

func instance_item(item) -> void :
	item = item.instance()
	item.expirable = true
	get_parent().get_parent().add_child(item)
	item.global_position = Vector2(round(global_position.x), round(global_position.y))
	item.velocity.y = - 200

func get_spawn_item():
	return GameManager.get_next_spawn_item()

func _Interrupt() -> void :
	get_parent().queue_free()
	sprite.material.set_shader_param("Alpha_Blink", 0)

func _on_zero_health() -> void :
	Log("heard zero health event")
	if not executing:
		character.interrupt_all_moves()
		ExecuteOnce()

func emit_remains_particles() -> void :
	if GameManager.is_on_screen(global_position) and death_particle:
		var particle = death_particle.duplicate()
		character.get_parent().add_child(particle)
		particle.global_transform = character.global_transform
		particle.start()
