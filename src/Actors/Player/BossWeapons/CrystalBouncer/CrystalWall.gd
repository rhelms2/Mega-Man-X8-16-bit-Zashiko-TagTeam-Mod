extends SimplePlayerProjectile
onready var groundcheck: RayCast2D = $groundcheck
onready var wallcheck: RayCast2D = $wallcheck
onready var collider: CollisionShape2D = $collisionShape2D
onready var player_detector: Area2D = $playerDetector
onready var damaging_projectile: KinematicBody2D = $CrystalBouncerCharged

signal phased_in

func _ready() -> void :
	Tools.timer(0.05, "solidify_on_start", self)

func initialize(direction) -> void :
	.initialize(direction)
	damaging_projectile.initialize(direction)

func set_creator(creator) -> void :
	.set_creator(creator)
	damaging_projectile.set_creator(creator)

func _on_player_exited(body: Node) -> void :
	call_deferred("solidify_collider")

func solidify_on_start() -> void :
	if not is_overlapping_player():
		solidify_collider()

func solidify_collider() -> void :
	collider.disabled = false
	emit_signal("phased_in")

func is_overlapping_player() -> bool:
	return player_detector.overlaps_body(GameManager.player)

func _Setup() -> void :
	global_position = GameManager.get_player_position()
	position_horizontally()
	
	animatedSprite.playing = true

func _Update(delta: float) -> void :
	process_gravity(delta)

func position_horizontally() -> void :
	wallcheck.force_raycast_update()
	if wallcheck.is_colliding():
		global_position.x = wallcheck.get_collision_point().x
		global_position.x -= 8 * get_facing_direction()
	else:
		global_position.x += wallcheck.cast_to.x * get_facing_direction()
		global_position.x -= 8 * get_facing_direction()

func position_vertically() -> void :
	groundcheck.force_raycast_update()
	if groundcheck.is_colliding():
		global_position.y = groundcheck.get_collision_point().y
	else:
		destroy()
		
func _OnHit(_target_remaining_HP) -> void :
	pass
func _OnDeflect() -> void :
	pass


func _on_SolidPhaser_phased_in() -> void :
	set_collision_mask_bit(0, true)
	pass
