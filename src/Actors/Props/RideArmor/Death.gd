extends NewAbility

var flash_interval := 0.5
onready var stage = AbilityStage.new(self)
onready var explosion: Particles2D = $explosion
onready var remains: Particles2D = $remains
onready var explosion_sfx: AudioStreamPlayer2D = $explosion_sfx

func should_execute() -> bool:
	return current_conflicts.size() == 0

func _Setup() -> void:
	character.current_health = 0
	Tools.timer(5.5,"next",self,stage)
	flash_interval = 0.5

func _Update(_delta) -> void:
	if stage.is_initial():
		if timer > flash_interval:
			character.flash()
			timer = 0.0
			flash_interval = clamp(flash_interval *0.9,0.064,1)
	
	elif stage.currently_is(1):
		character.emit_signal("death")
		stage.end()

func on_death() -> void:
	character.make_invisible()
	explosion.emitting = true
	remains.emitting = true
	explosion_sfx.play()
	end_all_abilities()
	Tools.timer(1.0,"after_death",self)

func after_death() -> void:
	explosion.emitting = false
	Tools.timer(1.0,"EndAbility",self)

func _Interrupt() -> void:
	character.queue_up_for_destruction()

func end_all_abilities() -> void:
	var exceptions := ["Death","Shutdown"]
	for ability in character.get_all_abilities():
		if not ability.name in exceptions:
			ability.EndAbility()
