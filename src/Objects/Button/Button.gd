extends Node2D
class_name ShootableButton

export (AudioStream) var button_sound
var state: = false
signal button_press
onready var anim: = $animatedSprite
var saber_rehit = 0

func press():
	state = true
	anim.play("off")
	emit_signal("button_press")

func unpress():
	state = false
	anim.play("on")

func _on_area2D_body_entered(body: Node) -> void :
	if state == false and body.is_in_group("Player Projectile"):
		if GameManager.precise_is_on_screen(self.global_position):
			press()
			body.hit(self)
			play_sound()

func play_sound() -> void :
	if button_sound != null:
		var audio = $audioStreamPlayer2D
		audio.pitch_scale = rand_range(0.9,1.1)
		audio.stream = button_sound
		audio.play()
	

func damage(_value, _object) -> float:
	return 0.0

func _on_Press_close() -> void :
	unpress()


