extends Area2D

var activated: = false
onready var previous_limit: Area2D = $"../../Limits/pre_boss"
onready var next_limit: Area2D = $"../../Limits/final_boss"
onready var invisible_wall: CollisionShape2D = $"../../Scenery/invisible_wall/collisionShape2D"

func _ready() -> void :
	Event.connect("lumine_went_seraph", self, "debug_seraph")

func _on_body_entered(_body: Node) -> void :
	if not activated:
		activated = true
		previous_limit.disable()
		invisible_wall.set_deferred("disabled", false)
		Event.emit_signal("boss_door_closed")
		GameManager.player.cutscene_deactivate()
		GameManager.camera.update_area_limits(next_limit)
		GameManager.camera.start_door_translate(next_limit.global_position, next_limit, false)
		Event.emit_signal("show_warning")

func debug_seraph():
	if not activated:
		previous_limit.disable()
		invisible_wall.set_deferred("disabled", false)
		queue_free()
	
