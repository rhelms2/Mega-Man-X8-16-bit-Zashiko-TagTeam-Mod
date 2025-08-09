extends EventAbility

export var duration := 0.65
export var damage_value := 3
export var damage_to_bosses := 2
export var damage_frequency := 0.04
var next_damage_time := 0.02
var target_list = []
var damaged_target_list = []
var disappear := 0.0
onready var collider := $DamageArea/collisionShape2D
onready var effect = get_node("shield_effect")
onready var damage_area: RigidBody2D = $DamageArea

func _ready() -> void:
	effect.visible = false

func _Setup() -> void:
	stop_disappear()
	collider.disabled = false
	damage_area.facing_direction = character.get_facing_direction()
	effect.visible = true
	effect.position.x = 3 * character.get_facing_direction()
	effect.frame = 0
	damaged_target_list.clear()
	
func _EndCondition() -> bool:
	if timer > 0.15: #delay to not end just after start, as it's still grounded
		if character.is_on_floor():
			return true
		if character.get_vertical_speed() >= 0:
			return true
	if Has_time_ran_out():
		return true
	return false

func Has_time_ran_out() -> bool:
	return duration < timer

func on_melee_hit(body):
	if executing:
		if body.is_in_group("Enemies") or body.is_in_group("Enemy Projectile") :
			Log("Dealing " + str (damage_value) + " damage")
			body.damage(damage_value, self)
			damaged_target_list.append(body)

func _Update(_delta: float) -> void:
	if target_list.size() > 0:
		for target in target_list:
			if not target in damaged_target_list: 
				if is_instance_valid(target):
					on_melee_hit(target)

func _Interrupt():
	damaged_target_list.clear()
	collider.set_deferred("disabled",true)
	character.flash()
	disappear = 0.1

func leave(_target):
	if _target in target_list:
		Log("Removing from list: " + _target.name)
		target_list.erase(_target)

func _process(delta: float) -> void:
	if disappear > 0:
		disappear += delta * 8
		effect.speed_scale -= delta * 4
		effect.modulate = lerp(Color.white,Color(1,1,1,0),disappear)
		if disappear > 1:
			stop_disappear()

func stop_disappear():
	disappear = 0
	effect.visible = false
	effect.modulate = Color.white
	effect.speed_scale = 1

func hit(_body) -> void:
	if not (_body in target_list):
		Log("Adding to list: " + _body.name)
		target_list.append(_body)
