extends Sprite

onready var tween: = TweenController.new(self, false)

export  var speed: = 80

func _ready() -> void :
	region_rect.position.y = CharacterManager.elevator_walls_y
	descent()

func descent():
	tween.reset()
	tween.attribute("region_rect:position:y", region_rect.position.y + speed, 1.0)
	Tools.timer(1.0, "descent", self)
	
