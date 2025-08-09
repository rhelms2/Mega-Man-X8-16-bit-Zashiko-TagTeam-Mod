extends RigidBody2D
onready var button: Node2D = $"../BossButton"
onready var button_2: Node2D = $"../BossButton2" #<
onready var tween := TweenController.new(self,false)

func _ready() -> void:
	button_2.press()

func _on_BossButton_button_press() -> void:
	tween.attribute("position:x",button_2.position.x + 96,1.0)
	tween.get_last().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BOUNCE)

func _on_BossButton2_button_press() -> void:
	tween.attribute("position:x",button.position.x - 96,1.0)
	tween.set_ease_out()

func hit(boss) -> void:
	boss.damage(25,self)
	Event.emit_signal("screenshake",2.0)
