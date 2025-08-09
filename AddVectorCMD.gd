extends Command
class_name AddVectorCMD

var original
var adjust : Vector2

func _init(_original, _adjust:Vector2) -> void:
	self.original = _original
	self.adjust = _adjust

func Execute():
	original.position = original.position + adjust

func Undo():
	original.position = original.position - adjust


