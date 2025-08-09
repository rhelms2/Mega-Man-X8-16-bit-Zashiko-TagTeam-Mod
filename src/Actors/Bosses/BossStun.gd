extends AttackAbility
class_name BossStun

export  var stop_at_land: bool = false
export  var floor_time: float = 0.05

onready var damage: Node2D = $"../Damage"
onready var boss_ai: Node2D = $"../BossAI"

var side_hit: int = 0


func _ready() -> void :
	var _s = damage.connect("charged_weakness_hit", self, "start_stun")

func start_stun(hit_direction: int) -> void :
	if active and character.has_health():
		side_hit = hit_direction
		character.interrupt_all_moves()
		ExecuteOnce()

func _Setup() -> void :
	force_movement_toward_direction(horizontal_velocity, side_hit)
	set_vertical_speed( - jump_velocity)

func _Update(delta: float) -> void :
	process_gravity(delta)
	if character.is_on_floor():
		if stop_at_land:
			force_movement(0)

func _EndCondition() -> bool:
	return timer > floor_time and character.is_on_floor()

func _Interrupt() -> void :
	play_animation("idle")
	if stop_at_land:
		force_movement(0)

func reactivate(_s = null) -> void :
	Log("Reactivating Stun")
	activate()
