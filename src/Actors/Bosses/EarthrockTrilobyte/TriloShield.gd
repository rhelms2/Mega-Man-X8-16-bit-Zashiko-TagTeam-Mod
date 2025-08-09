extends EnemyShield

var armor_cooldown := 1.0
onready var flash: AnimatedSprite = $flash
onready var armor_equip: AudioStreamPlayer2D = $armor_equip
export var breakable_on_start := true
signal catch

func _ready() -> void:
	if breakable_on_start:
		character.listen("intro_concluded",self,"activate_breakable")
	
func activate_breakable() -> void:
	breakable = true
	pass
	
func connect_player_death() -> void:
	pass

func _on_removed_armor() -> void:
	if active:
		deactivate()
		armor_cooldown = 1.25
		Tools.tween(self,"armor_cooldown",0.0,armor_cooldown)

func _on_armor_catch(armor) -> void:
	if not active and armor_cooldown <= 0.0 and character.has_health():
		armor.catch()
		activate()
		flash.frame = 0
		armor_equip.play()
		emit_signal("catch")

func _on_BossAI_activated() -> void:
	pass
