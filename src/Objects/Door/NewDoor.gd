extends StaticBody2D
class_name NewDoor

export  var able_to_open: bool = true
export  var able_to_explode: bool = true
export  var alternate_sprite_frames: SpriteFrames
export  var boss_spawner: NodePath

signal open
signal passing
signal close
signal explode
signal finish


func _ready() -> void :
	if alternate_sprite_frames:
		$animatedSprite.frames = alternate_sprite_frames

func _on_Open_start(_ability_name) -> void :
	emit_signal("open")
	Event.emit_signal("normal_door_open")

func _on_PassThrough_start(_ability_name) -> void :
	emit_signal("passing")

func _on_Close_start(_ability_name) -> void :
	emit_signal("close")

func _on_Explode_start(_ability_name) -> void :
	emit_signal("explode")

func _on_Close_stop(_ability_name) -> void :
	emit_signal("finish")

func _on_Unlock() -> void :
	able_to_open = true

func _on_Unlock_and_able_to_explode() -> void :
	_on_Unlock()
	able_to_explode = true

func _on_Lock() -> void :
	able_to_open = false
	able_to_explode = false

func destroy() -> void :
	queue_free()
