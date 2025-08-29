extends Weapon

export  var recharge_rate: = 1.0
export  var weapon: Resource
onready var parent: = get_parent()
onready var animatedsprite: AnimatedSprite = $"../../animatedSprite"
onready var weapon_stasis: Node2D = $"../../WeaponStasis"
onready var nova_strike: Node2D = $"../../NovaStrike"
onready var jump_damage: Node2D = $"../../JumpDamage"

onready var OriginalMainColor1: Color = MainColor1
onready var OriginalMainColor2: Color = MainColor2
onready var OriginalMainColor3: Color = MainColor3
onready var OriginalMainColor4: Color = MainColor4
onready var OriginalMainColor5: Color = MainColor5
onready var OriginalMainColor6: Color = MainColor6

export  var CrystalColor1: Color
export  var CrystalColor2: Color
export  var CrystalColor3: Color
export  var CrystalColor4: Color

onready var vfx: AnimatedSprite = $break_vfx

onready var tween: SceneTreeTween

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
var vfx_casted: bool = false

func _ready() -> void :
	character.listen("equipped_armor", self, "on_equip")
	character.listen("zero_health", self, "on_zero_health")
	
func recharge(_d = null):
	if active and current_ammo < max_ammo:
		if timer > last_time_hit + minimum_time_between_recharges:
			last_time_hit = timer
			current_ammo = clamp(current_ammo + 1.0, 0.0, max_ammo)

func _input(event: InputEvent) -> void :
	if active and has_ammo() and character.has_control():
		if event.is_action_pressed("select_special"):
			fire()

func fire_charged(_charge_level):
	if active and has_ammo() and character.has_control():
		vfx_casted = false
		jump_damage.effect.visible = false
		character.execute_nova_strike = true
		reduce_ammo(ammo_per_shot)
		Input.action_press("select_special")

func fire(_charge_level: = 0) -> void :
	if active and has_ammo() and character.has_control():
		vfx_casted = false
		jump_damage.effect.visible = false
		character.execute_nova_strike = true
		reduce_ammo(ammo_per_shot)
		Input.action_press("select_special")

func on_equip():
	if character.is_full_armor() == "ultimate":
		active = true
		current_ammo = max_ammo
		Event.emit_signal("special_activated", self, character)
	else:
		active = false
		Event.emit_signal("special_deactivated", self, character)
		if parent.current_weapon == self:
			parent.set_buster_as_weapon()
	parent.update_list_of_weapons()
	set_physics_process(active)

func has_ammo() -> bool:
	return current_ammo >= max_ammo

func can_shoot() -> bool:
	return has_ammo()

func _physics_process(delta: float) -> void :
	timer += delta
	if current_ammo < max_ammo:
		current_ammo = clamp(current_ammo + delta * 10, 0.0, max_ammo)
	
	if has_ammo() and not vfx_casted:
		vfx.frame = 0
		vfx_casted = true

	if has_ammo():
		cycle_colors()
		parent.update_character_palette()
	else:
		if tween and tween.is_valid():
			tween.kill()
			parent.update_character_palette()

const color_cycle_duration: = 0.25
func cycle_colors() -> void :
	if not tween or not tween.is_valid():
		tween = create_tween().set_loops()
		tween.tween_property(self, "CrystalColor1", Color("ffb4ff"), color_cycle_duration)
		tween.set_parallel().tween_property(self, "CrystalColor2", Color("d77be6"), color_cycle_duration * 2)
		tween.set_parallel().tween_property(self, "CrystalColor3", Color("8d2bba"), color_cycle_duration * 2)
		
		tween.chain().tween_property(self, "CrystalColor1", Color("d77be6"), color_cycle_duration)
		tween.set_parallel().tween_property(self, "CrystalColor2", Color("8d2bba"), color_cycle_duration * 2)
		tween.set_parallel().tween_property(self, "CrystalColor3", Color("60008d"), color_cycle_duration * 2)
		



