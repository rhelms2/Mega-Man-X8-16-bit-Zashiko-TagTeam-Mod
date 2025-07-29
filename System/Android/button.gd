extends TouchScreenButton

export  var _action: String

func _ready():
	connect("pressed", self, "_on_button_pressed")
	connect("released", self, "_on_button_released")

func _on_button_pressed() -> void :
	Input.action_press(_action)
	self.modulate.a = 0.5


func _on_button_released() -> void :
	Input.action_release(_action)
	self.modulate.a = 1.0






