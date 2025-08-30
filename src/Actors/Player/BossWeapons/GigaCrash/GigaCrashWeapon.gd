extends Weapon

const minimum_time_between_recharges: float = 0.2

export  var recharge_rate: float = 1.0
export  var weapon: Resource

onready var parent: = get_parent()
onready var animatedsprite: AnimatedSprite = $"../../animatedSprite"
onready var weapon_stasis: Node2D = $"../../WeaponStasis"
onready var jump_damage: Node2D = $"../../JumpDamage"
onready var OriginalMainColor1: Color = MainColor1
onready var OriginalMainColor2: Color = MainColor2
onready var OriginalMainColor3: Color = MainColor3
onready var vfx: AnimatedSprite = $break_vfx
onready var tween: SceneTreeTween

var timer: float = 0.0
var last_time_hit: float = 0.0
var is_executing_special: bool = false


func _input(event: InputEvent) -> void :
	if active and has_ammo() and character.has_control() and not character.is_riding():
		if event.is_action_pressed("select_special"):
			fire()

func _ready() -> void :
	character.listen("equipped_armor", self, "on_equip")
	character.listen("zero_health", self, "on_zero_health")
	Event.listen("hit_enemy", self, "recharge")
	Event.listen("enemy_kill", self, "recharge")
	Event.listen("special_end", self, "reset_ammo_to_zero")
	
func reset_ammo_to_zero() -> void:
	current_ammo = 0

func recharge(_d = null):
	if active and current_ammo < max_ammo:
		if timer > last_time_hit + minimum_time_between_recharges:
			last_time_hit = timer
			current_ammo = clamp(current_ammo + 1.0, 0.0, max_ammo)

func on_equip():
	if character.is_full_armor() == "icarus":
		active = true
		current_ammo = max_ammo
		Event.emit_signal("special_activated", self, character)
	else:
		active = false
		Event.emit_signal("special_deactivated", self, character)
	parent.update_list_of_weapons()
	set_physics_process(active)

func has_ammo() -> bool:
	return current_ammo >= max_ammo

func fire(_charge_level: = 0) -> void :
	.fire(0)
	weapon_stasis.ExecuteOnce()
	jump_damage.effect.visible = false
	animatedsprite.modulate = Color(1, 1, 1, 0.01)
	character.add_invulnerability("GigaCrash")
	parent.set_buster_as_weapon()
	Event.emit_signal("weapon_select_buster")
	is_executing_special = true
	character.is_executing_special = true

func connect_shot_event(_shot):
	_shot.connect("projectile_end", self, "on_shot_end")
	character.listen("zero_health", _shot, "on_death")

func on_zero_health() -> void :
	animatedsprite.modulate = Color.white

func position_shot(shot) -> void :
	shot.transform = global_transform
	shot.scale.x = character.get_facing_direction()

func on_shot_end(_shot):
	character.remove_invulnerability("GigaCrash")
	weapon_stasis.play_animation("fall")
	weapon_stasis.EndAbility()
	animatedsprite.modulate = Color.white
	is_executing_special = false
	character.is_executing_special = false
	Event.emit_signal("special_end")

func _physics_process(delta: float) -> void :
	timer += delta
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
