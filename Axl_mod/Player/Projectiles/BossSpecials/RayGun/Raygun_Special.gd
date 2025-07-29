extends SpecialAbilityAxl

onready var raygun_special: = preload("res://src/Actors/Player/BossWeapons/OpticShield/OpticRadar.res")
onready var laser: PackedScene = preload("res://src/Actors/Player/BossWeapons/OpticShield/OpticShieldCharged.tscn")
onready var laser_material: = preload("res://src/Effects/Materials/crushtarget_mat.tres")
onready var ground_check: RayCast2D = $ground_check

var cast_timer: float = 0.0
var should_cast: bool = false
var interval: float = 1.5
var max_casts: int = 8
var casts: int = 1
var direction: int = 1
var damage: float = 4
var damage_to_bosses: float = 0.75
var damage_to_weakness: float = 15


func deactivate() -> void :
	queue_free()

func destroy(enemy) -> void :
	if typeof(enemy) == TYPE_STRING:
		if enemy == "boss":
			queue_free()

func initialize() -> void :
	Event.connect("normal_door_open", self, "deactivate")
	Event.connect("boss_door_open", self, "deactivate")
	Event.connect("vile_door_open", self, "deactivate")
	first_instantiate()

func _physics_process(delta: float) -> void :
	if should_cast:
		if casts < max_casts:
			cast_timer += delta
			if cast_timer >= interval:
				casts += 1
				cast_timer = 0.0
				instantiate(character.get_facing_direction())
		else:
			deactivate()

func set_should_cast() -> void :
	should_cast = true
	
func first_instantiate() -> void :
	Tools.timer(animation_time, "set_should_cast", self)
	var projectile = raygun_special.instance()
	get_tree().current_scene.add_child(projectile, true)
	projectile.global_position = self.global_position
	projectile.laser_damage = damage
	projectile.laser_damage_to_bosses = damage_to_bosses
	projectile.laser_damage_to_weakness = damage_to_weakness
	projectile.z_index = 100

	projectile.initial_speed = 0.0

	projectile.tracker_radius = 400.0
	projectile.tracker_tolerance = 1.0
	projectile.laser_material = laser_material
	projectile.modulate = Color(1, 1, 1, 0.75)
	projectile.call_deferred("initialize", character.get_facing_direction())

func instantiate(dir) -> void :
	var projectile = raygun_special.instance()
	get_tree().current_scene.add_child(projectile, true)
	projectile.global_position = self.global_position
	projectile.laser_damage = damage
	projectile.laser_damage_to_bosses = damage_to_bosses
	projectile.laser_damage_to_weakness = damage_to_weakness
	projectile.z_index = 100
	projectile.duration = 0.2
	projectile.initial_speed = 0.0
	projectile.pursuit_speed = 2000.0
	projectile.tracker_radius = 400.0
	projectile.tracker_tolerance = 1.0
	projectile.laser_material = laser_material
	projectile.modulate = Color(1, 1, 1, 0.75)
	projectile.call_deferred("initialize", dir)

func fire_laser() -> void :
	var ground_position = Vector2(self.global_position.x, self.global_position.y + 256)
	if ground_check.is_colliding():
		ground_position = ground_check.get_collision_point()
	create_laser(ground_position)

func create_laser(ground_position) -> void :
	var instance = laser.instance()
	get_tree().current_scene.get_node("Objects").call_deferred("add_child", instance, true)
	instance.z_index = 100
	instance.modulate = Color(1, 1, 1, 0.75)
	instance.damage = damage
	instance.damage_to_bosses = damage_to_bosses
	instance.damage_to_weakness = damage_to_weakness
	if laser_material != null:
		instance.get_node("animatedSprite").material = laser_material
		instance.get_node("animatedSprite2").material = laser_material
	instance.set_global_position(ground_position)
	instance.call_deferred("initialize", character.get_facing_direction())
