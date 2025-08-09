extends EventAbility

export var first_decay := 1.25
export var lifesteal_decay := 0.5
export var minimum_time_between_heals := 0.2
var first_decayed := false
var last_time_hit := 0.0
var last_time_decay := 0.0
var healable_amount := 0
onready var damage_module = get_parent().get_node("Damage")
onready var heal_sound = get_node("heal_sound")

func _ready() -> void:
	Event.listen("hit_enemy",self,"on_hit_enemy")
	Event.listen("charge_hit_enemy",self,"on_big_hit_enemy")
	Event.listen("enemy_kill",self,"on_kill_enemy")
	Event.connect("subtank_health_restore",self,"remove_healable_amount",[1])
	Event.connect("xdrive",self,"heal_all_at_once")
	character.listen("collected_health", self, "remove_healable_amount")

func play_sound_on_initialize():
	play_sound(sound,false)

func set_up_character_event_connection():
	call_deferred("setup_deferred")

func setup_deferred():
	damage_module.connect(start_event,self,execution_method)
	if stop_listening_on_death:
		character.listen("death",self,"deactivate")

func deactivate(_d = null) -> void:
	.deactivate()
	healable_amount = 0
	Event.emit_signal("disabled_lifesteal")

func setup_parameter(param = null):
	if param != null:
		if active:
			adjust_healable_amount(param)
	else:
		Log("Starting without damage for event " + start_event)

func execute() -> void:
	if not executing:
		ExecuteOnce()

func _Update(_delta):
	clamp_healable_amount_to_missing_health()
	if not first_decayed:
		if timer > first_decay:
			decay()
			first_decayed = true
	elif timer > last_time_decay + lifesteal_decay:
		decay()

func decay(decay_amount = -1):
	adjust_healable_amount(decay_amount)
	last_time_decay = timer
	Log("Decay. Heal up to: " + str(healable_amount))

func _Setup():
	last_time_hit = 0.0
	last_time_decay = 0.0
	first_decayed = false
	Log("Can heal up to: " + str(healable_amount))

func heal(amount := 1):
	amount = clamp(amount,0,healable_amount) # warning-ignore:narrowing_conversion
	character.current_health += amount
	remove_healable_amount(amount) # warning-ignore:narrowing_conversion
	heal_sound.play()
	character.flash()
	last_time_hit = timer
	Log("Healed "+str(amount)+". Heal up to: " + str(healable_amount))

func heal_all_at_once():
	if executing:
		heal(healable_amount)

func _EndCondition() -> bool:
	return healable_amount <= 0 or not character.has_health()

func _Interrupt() -> void:
	stop_sound()

func clamp_healable_amount_to_missing_health() -> void:
	healable_amount = clamp(healable_amount,0,character.max_health - character.current_health)

func adjust_healable_amount (adjust : int):
	healable_amount += adjust
	
	Event.emit_signal("healable_amount", healable_amount)
	
func remove_healable_amount (adjust : int):
	if executing:
		healable_amount -= adjust
# warning-ignore:narrowing_conversion
		healable_amount = clamp(healable_amount,0,16)
		Event.emit_signal("healable_amount", healable_amount)
		Log("Healed through other means. Removed: " + str(adjust))
		Log("Healable Amount: " + str(healable_amount))

func on_hit_enemy():
	if timer > last_time_hit + minimum_time_between_heals:
		heal()
			
func on_big_hit_enemy():
	if executing:
		pass#heal()

func on_kill_enemy(_param):
	on_hit_enemy()
