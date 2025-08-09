extends Node2D
onready var laser: AnimatedSprite = $laser
onready var laser_damage: Node2D = $laser/damage
onready var sprite: AnimatedSprite = $ball
onready var shot_sfx: AudioStreamPlayer2D = $prepare
onready var damage = get_parent().get_node_or_null("Damage")
onready var shield: Node2D = $EnemyShield
var deflects := 2
var target : Vector2
var active := true
signal started_deflect
signal deflected
signal resetted
signal vanished


func _ready() -> void:
	Tools.timer(0.1,"deactivate_damage",self)
	set_physics_process(false)

func reset():
	laser.visible = false
	deflects = 2
	deactivate_damage()
	emit_signal("resetted")
	
func deactivate_damage():
	shield.activate()
	if damage != null:
		damage.deactivate()

func activate_damage():
	shield.deactivate()
	if damage != null:
		damage.activate()
	
func aim_laser():
	laser.visible = true
	target = GameManager.get_player_position()
	laser.look_at(target)
	Tools.timer(0.16,"fire_laser",self)
	laser.play("ready")
	set_physics_process(true)
	
func fire_laser():
	set_physics_process(false)
	emit_signal("deflected")
	laser.look_at(target)
	laser_damage.activate()
	laser.play("fire")
	sprite.frame = 0
	sprite.play("explode")
	shot_sfx.play_r()
	
	if deflects == 0:
		activate_damage()

func _physics_process(_delta: float) -> void:
	laser.look_at(target)


func _on_shield_hit(projectile) -> void:
	if active and not immunity and deflects > 0:
		if "GigaCrash" in projectile.name:
			deflects = 0
			activate_damage()
			emit_signal("vanished")
			pass
		elif not "DamageArea" in projectile.name:
			deflects -= 1
			emit_signal("started_deflect")
			start_immunity()
			Tools.timer(0.16,"end_immunity",self)
			aim_laser()
		
var immunity := false

func start_immunity():
	immunity = true
	
func end_immunity():
	immunity = false

func deactivate():
	active = false
	shield.deactivate()
	
func activate():
	active = true
	if deflects == 0:
		activate_damage()
	else:
		deactivate_damage()

func hide_laser():
	laser.visible = false
