extends GenericProjectile

export var blast_area : PackedScene
var descending := false

func _Update(delta) -> void:
	rotate_towards_direction()
	if is_on_floor() or is_on_wall() or is_on_ceiling():
		explode()
	
	if not descending and timer > 1.8:
		Tools.tween_method(self,"set_vertical_speed",-100,500,2.0)
		descending = true

func set_direction(new_direction):
	Log("Seting direction: " + str (new_direction) )
	facing_direction = new_direction
	if not animatedSprite:
		animatedSprite = get_node("animatedSprite")

func explode() -> void:
	disable_visuals()
	deactivate()
	set_rotation(0)
	create_blast_area()

func _OnHit(_d) -> void:
	explode()
	disable_visuals()

func rotate_towards_direction() -> void:
	set_rotation(Vector2(get_horizontal_speed(),get_vertical_speed()).angle())

func create_blast_area(instance_position := global_position):
	var instance = blast_area.instance()
	get_tree().current_scene.add_child(instance,true)
	instance.set_global_position(instance_position)
