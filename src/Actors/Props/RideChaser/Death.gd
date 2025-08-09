extends Ability
class_name BikeDeath

onready var explosions = $"Explosion Particles"
onready var sprite = get_parent().get_node("animatedSprite")
onready var death_particle = $Remains/remains_particles
export var explosion_duration:= 2.0
var times_sound_played := 0.0
var emitted_signal := false

func _ready() -> void:
	if active:
		character.listen("zero_health",self,"execute")
	
func _Setup():
	explosions.emitting = true
	emitted_signal = false
	sprite.material.set_shader_param("Alpha_Blink", 1)

func _Update(_delta):
	if timer > times_sound_played/5 and timer < explosion_duration:
		play_explosion_sounds()
	if timer > explosion_duration and not emitted_signal:
		hide_visuals()
		character.emit_signal("death")
		emit_remains_particles()
		emitted_signal = true

func _EndCondition() -> bool:
	return timer > explosion_duration + 1
	
func _Interrupt():
	#print("..............FREEING BIKE")
	get_parent().visible = false
	
func execute() -> void:
	if not executing:
		#character.interrupt_all_moves()
		ExecuteOnce()

func hide_visuals():
	explosions.emitting = false
	sprite.visible = false

func play_explosion_sounds():
		times_sound_played += 1
		var audio = $audioStreamPlayer2D.duplicate()
		add_child(audio)
		audio.pitch_scale = rand_range(0.95,1.05)
		audio.play()

func emit_remains_particles():
	death_particle.emitting = true
	Tools.timer(2,"destroy_actor",self)

func destroy_actor():
	get_parent().destroy()
