extends VisibilityNotifier2D

onready var parent :Node2D= get_parent()
#onready var shape: CollisionShape2D = $collisionShape2D
var debug_logs := false
var main_tileset : TileMap

func _ready() -> void:
	Log("Initializing")
	if not copied_data_from_custom_enabler():
		set_main_tileset()
		set_extents()

func copied_data_from_custom_enabler() -> bool:
	var custom_enabler = parent.get_node_or_null("visibilityEnabler2D")
	if custom_enabler != null:
		position = custom_enabler.position
		rect = custom_enabler.rect
		scale = custom_enabler.scale
		Log("copied data from custom_enabler")
		Log(custom_enabler.get_path())
		return true
	return false

func set_main_tileset() -> void:
	main_tileset = parent.get_node_or_null("Main")
	if not main_tileset:
		main_tileset = parent.get_child(0)
	Log("Set main tileset")
	Log(main_tileset.name)

func set_extents() -> void:
	position = Vector2.ZERO
	rect = Rect2(0,0,1,1)
	scale = main_tileset.get_used_rect().size * 16
	Log("Set rect extents")
	Log(scale)

func _on_camera_entered() -> void:
	Log("Enabled")
	parent.visible = true

func _on_camera_exited() -> void:
	Log("Disabled")
	parent.visible = false

func Log(msg) -> void:
	if debug_logs:
		print("SegmentEnabler (" + parent.name + "): " + str(msg))
