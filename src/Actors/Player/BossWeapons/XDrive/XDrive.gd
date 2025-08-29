extends Weapon

export  var recharge_rate: = 1.0
export  var weapon: Resource
onready var parent: = get_parent()
onready var jump_damage: Node2D = $"../../JumpDamage"

onready var OriginalMainColor1: Color = MainColor1
onready var OriginalMainColor2: Color = MainColor2
onready var OriginalMainColor3: Color = MainColor3
onready var vfx: AnimatedSprite = $break_vfx

onready var tween: SceneTreeTween

var buffed: = false
onready var air_dash: Node2D = $"../../AirDash"
onready var dash: Node2D = $"../../Dash"
onready var life_steal: Node2D = $"../../LifeSteal"
onready var charge: Node2D = $"../../Charge"
onready var trail: Line2D = $node / trail
onready var sprite: AnimatedSprite = $"../../animatedSprite"
onready var activate: AudioStreamPlayer2D = $activate
onready var flash: Sprite = $flash
onready var particles_2d: Particles2D = $particles2D

signal activated
signal deactivated

var timer: = 0.0
var last_time_hit: = 0.0
const minimum_time_between_recharges: = 0.2

func _ready() -> void :
	character.listen("equipped_armor", self, "on_equip")
	character.listen("zero_health", self, "on_zero_health")
	Event.listen("capsule_entered", self, "remove_buff")
	Event.listen("hit_enemy", self, "recharge")
	Event.listen("enemy_kill", self, "recharge")
	Event.listen("special_end", self, "reset_ammo_to_zero")
	
func reset_ammo_to_zero() -> void:
	current_ammo = 0
	
func recharge(_d = null):
	if active and not buffed and current_ammo < max_ammo:
		if timer > last_time_hit + minimum_time_between_recharges:
			last_time_hit = timer
			current_ammo = clamp(current_ammo + 1.0, 0.0, max_ammo)

func _input(event: InputEvent) -> void :
	if active and has_ammo() and character.has_control():
		if event.is_action_pressed("select_special"):
			fire()

func on_equip():
	
	if character.is_full_armor() == "hermes":
		active = true
		current_ammo = max_ammo
		Event.emit_signal("special_activated", self, character)
		
	else:
		active = false
		remove_buff()
		
		if parent.current_weapon == self:
			parent.set_buster_as_weapon()
	parent.update_list_of_weapons()
	set_physics_process(active)

func on_zero_health() -> void :
	trail.visible = false

func has_ammo() -> bool:
	return current_ammo >= max_ammo

func can_shoot() -> bool:
	return has_ammo() and not buffed

func fire(_charge_level: = 0) -> void :
	apply_buff()
	Event.emit_signal("shot", self)
	parent.set_buster_as_weapon()
	Event.emit_signal("weapon_select_buster")
	character.is_executing_special = true

func apply_buff() -> void :
	if not buffed:
		activate.play()
		flash.start()
		particles_2d.emitting = true
		character.add_invulnerability("xdrive")
		vfx.frame = 0
		buffed = true
		emit_signal("activated")
		Event.emit_signal("xdrive")

func remove_buff() -> void :
	character.remove_invulnerability("xdrive")
	trail.visible = false
	buffed = false
	if is_instance_valid(particles_2d):
		particles_2d.emitting = false
	emit_signal("deactivated")
	if character.is_executing_special:
		character.is_executing_special = false
		Event.emit_signal("special_end")

func _physics_process(delta: float) -> void :
	timer += delta
	if buffed and character.has_control():
		current_ammo = clamp(current_ammo - delta * 5, 0.0, max_ammo)
		if current_ammo <= 0.0:
			remove_buff()
	
		
	if has_ammo():
		cycle_colors()
		parent.update_character_palette()
	else:
		if tween and tween.is_valid():
			tween.kill()
			MainColor2 = OriginalMainColor2
			MainColor3 = OriginalMainColor3
			parent.update_character_palette()

const color_cycle_duration: = 0.25
func cycle_colors() -> void :
	if not tween or not tween.is_valid():
		vfx.frame = 0
		tween = create_tween().set_loops()

		tween.tween_property(self, "MainColor2", weapon.MainColor2, color_cycle_duration)

		tween.set_parallel().tween_property(self, "MainColor3", weapon.MainColor3, color_cycle_duration * 2)

		tween.chain().tween_property(self, "MainColor2", OriginalMainColor2, color_cycle_duration)

		tween.set_parallel().tween_property(self, "MainColor3", OriginalMainColor3, color_cycle_duration * 2)
