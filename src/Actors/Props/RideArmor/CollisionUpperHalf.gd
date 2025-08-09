extends CollisionShape2D
onready var death_up: RayCast2D = $"../CrushCheck/death_up"
onready var death_right: RayCast2D = $"../CrushCheck/death_right"
onready var death_left: RayCast2D = $"../CrushCheck/death_left"
const length := -24

func _on_Start_stand_up() -> void:
	set_disabled(false)
	restore_raycasts()
	
func _on_Eject_lay_down() -> void:
	set_disabled(true)
	disable_raycasts()

func restore_raycasts() -> void:
	death_up.cast_to.y = length
	death_right.enabled = true
	death_left.enabled = true

func disable_raycasts() -> void:
	death_up.cast_to.y = -8
	death_right.enabled = false
	death_left.enabled = false
	
