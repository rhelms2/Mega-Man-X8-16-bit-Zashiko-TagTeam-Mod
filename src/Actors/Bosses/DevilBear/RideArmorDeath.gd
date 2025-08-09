extends EnemyDeath
onready var animated_sprite: AnimatedSprite = $"../animatedSprite"
onready var damage: Node2D = $"../DamageOnTouch"
onready var remains: Particles2D = $Remains
onready var smoke: Particles2D = $"Smoke Particles"
onready var shutdown: AudioStreamPlayer2D = $"../shutdown"

func _ready() -> void:
	Event.connect("vile_defeated",self,"_on_vile_defeated")

func _on_vile_defeated() -> void:
	start()

func _on_zero_health() -> void:
	Log("heard zero health event")
	if not executing:
		Achievements.unlock("VILEDEVILBEARDEFEATED")
	start()

func start():
	if not executing:
		character.interrupt_all_moves()
		ExecuteOnce()
	

func _Setup() -> void:
	scale = animated_sprite.scale
	animated_sprite.material.set_shader_param("Darken",0.45)
	damage.deactivate()
	animated_sprite.play("deactivate")
	shutdown.play()
	Event.emit_signal("enemy_kill",character)
	character.emit_signal("death")
	remains.emitting = true
	smoke.emitting = true
	Tools.timer(0.1,"set_darken",self)

func _Update(delta) -> void:
	character.add_vertical_speed(900 * delta)
	if character.get_vertical_speed() > character.maximum_fall_velocity:
		character.set_vertical_speed(character.maximum_fall_velocity) 

func set_darken(value := 0.45):
	animated_sprite.material.set_shader_param("Darken",value)

func _EndCondition() -> bool:
	return false

func _Interrupt():
	pass
	
